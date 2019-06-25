package actions

import (
	"encoding/json"
	"fmt"
	"bytes"
	"io/ioutil"
	"strings"

	faktory "github.com/contribsys/faktory/client"
	"log"
	"github.com/getsentry/raven-go"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"

)

// rl is the rate limited to 5 requests per second.
// var rl = ratelimit.New(5)

// SurveyResponse is a data type for the survey
type SurveyResponse struct {
	ID               string `json:"uuid"`
	UserID           string `json:"user_id"`
	Email            string `json:"user_email"`
	Org              string `json:"org"`
	AnswerID         string `json:"answer_id"`
	GroupNumber      int    `json:"group_number"`
	PointsAssigned   int    `json:"points_assigned"`
	CreatedAt        string `json:"created_at"`
	SurveyResponseID string `json:"survey_response_id"`
}

// RegistrationStruct is a struct for the funnel
type resultsStruct struct {
	Results []SurveyResponse `json:"survey_results"`
}

// SurveysHandler accepts json
func SurveysHandler(c buffalo.Context) error {
	rl.Take()

	request := c.Request()
	var results resultsStruct
	body, err := ioutil.ReadAll(request.Body)

	dec := json.NewDecoder(bytes.NewReader(body))
	if err := dec.Decode(&results); err != nil {
		return c.Error(400, fmt.Errorf("malformed post"))
	}

	if err != nil {
		raven.CaptureError(err, nil)
		return c.Error(500, err)
	}
	log.Printf("body: %s", body)

	remoteAddress := strings.Split(request.RemoteAddr, ":")[0]

	surveyID, err := SaveSurveyResponses(results.Results, c)
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(
			500,
			fmt.Errorf(
				"Error inserting survey to database: %s for remote address %s",
				err.Error(),
				remoteAddress))
	}

	// Add job to the queue
	client, err := faktory.Open()
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}

	createSlideJob := faktory.NewJob("CreateSlide", surveyID, c.Value("email") )
	err = client.Push(createSlideJob)
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}

	return c.Render(200, r.JSON(map[string]string{"message": surveyID}))
}

// SaveSurveyResponses creates a survey_response and saves all responses
func SaveSurveyResponses(responses []SurveyResponse, c buffalo.Context) (string, error) {
	tx := c.Value("tx").(*pop.Connection)
	rows, err := tx.TX.Query("INSERT INTO mappa.survey_responses DEFAUlT VALUES RETURNING uuid;")
	if err != nil {
		return "", err
	}
	defer rows.Close()
	var surveyResponseID string
	for rows.Next() {
		var uuid string
		err = rows.Scan(&uuid)
		fmt.Println("Created new survey_response:", uuid)
		if err != nil {
			return "", err
		}
		surveyResponseID = uuid
	}

	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}

	for _, response := range responses {
		_, err = tx.TX.Exec(
			"INSERT INTO mappa.ipsative_responses (answer_id, group_number, points_assigned, survey_response_id) VALUES ($1, $2, $3, $4)",
			response.AnswerID,
			response.GroupNumber,
			response.PointsAssigned,
			surveyResponseID,
		)
		if err != nil {
			return "", err
		}
	}

	return surveyResponseID, err
}