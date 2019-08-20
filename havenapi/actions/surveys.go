package actions

import (
	"encoding/json"
	"fmt"
	"bytes"
	"io/ioutil"
	"strings"
	"log"
	"time"
	"github.com/gobuffalo/uuid"
	faktory "github.com/contribsys/faktory/client"
	helmLog "github.com/deis/helm/log"
	"github.com/getsentry/raven-go"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/havengrc/havenapi/models"
)

// rl is the rate limited to 5 requests per second.
// var rl = ratelimit.New(5)

// IpsativeResponse is a data type for the entered response
type IpsativeResponse struct {
	UUID             uuid.UUID   `json:"uuid" db:"uuid"`
	AnswerID         string      `json:"answer_id" db:"answer_id"`
	Category         string      `json:"category" db:"-"`
	GroupNumber      int         `json:"group_number" db:"group_number"`
	PointsAssigned   int         `json:"points_assigned" db:"points_assigned"`
	CreatedAt        time.Time   `json:"created_at" db:"created_at"`
	UserID           uuid.UUID   `json:"user_id" db:"user_id"`
	SurveyResponseID uuid.UUID   `json:"survey_response_id" db:"survey_response_id"`
	UserEmail        string      `json:"user_email" db:"user_email"`
}

// SurveyResult is a data type for the survey
type SurveyResult struct {
	AnswerID         string `json:"answer_id"`
	Category         string `json:"category"`
	GroupNumber      int    `json:"group_number"`
	PointsAssigned   int    `json:"points_assigned"`
}


// resultsStruct is a struct for the funnel
type resultsStruct struct {
	Results []SurveyResult `json:"survey_results"`
	SurveyID uuid.UUID     `json:"survey_id"`
// TODO add collectors	CollectorID uuid.UUID  `json:"collector_id"`
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

	remoteAddress := strings.Split(request.RemoteAddr, ":")[0]
	surveyID, err := SaveSurveyResults(results.Results, results.SurveyID, c)
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
	createSlideJob.ReserveFor = 60
	createSlideJob.Queue = "critical"
	err = client.Push(createSlideJob)
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}

	responses := []IpsativeResponse{}
	// To find the state the value of sub from the Middleware is used.
	tx := c.Value("tx").(*pop.Connection)
	err = tx.RawQuery("set local search_path to mappa, public").Exec()
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	query := tx.Where("survey_response_id = ($1)", surveyID )
	err = query.All(&responses)
	if err != nil {
		raven.CaptureError(err, nil)
		return c.Error(500, err)
	}

	return c.Render(200, r.JSON(responses))
}

// SaveSurveyResults creates a survey_response and saves all responses
func SaveSurveyResults(results []SurveyResult, surveyID uuid.UUID , c buffalo.Context) (string, error) {
	tx := c.Value("tx").(*pop.Connection)
	rows, err := tx.TX.Query("INSERT INTO mappa.survey_responses (survey_id) VALUES ($1) RETURNING id;", surveyID)
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

	for _, result := range results {
		_, err = tx.TX.Exec(
			"INSERT INTO mappa.ipsative_responses (answer_id, group_number, points_assigned, survey_response_id) VALUES ($1, $2, $3, $4)",
			result.AnswerID,
			result.GroupNumber,
			result.PointsAssigned,
			surveyResponseID,
		)
		if err != nil {
			return "", err
		}
	}

	return surveyResponseID, err
}

// GetIpsativeSurveys returns all ipsative surveys
// the path GET /api/ipsative_surveys
func GetIpsativeSurveys(c buffalo.Context) error {

	surveys := []models.IpsativeSurvey{}

	tx := c.Value("tx").(*pop.Connection)

	err := tx.All(&surveys)
	if err != nil {
		helmLog.Info("Something went wrong in GetSurveys")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}
	return c.Render(200, r.JSON(surveys))
}

// GetLikertSurveys returns all likert surveys
// the path GET /api/likert_surveys
func GetLikertSurveys(c buffalo.Context) error {

	surveys := []models.LikertSurvey{}

	tx := c.Value("tx").(*pop.Connection)

	err := tx.All(&surveys)
	if err != nil {
		helmLog.Info("Something went wrong in GetSurveys")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}
	return c.Render(200, r.JSON(surveys))
}

// GetLikertQuestions returns all likert questions
// the path GET /api/likert_questions
func GetLikertQuestions(c buffalo.Context) error {

	questions := []models.LikertQuestion{}

	tx := c.Value("tx").(*pop.Connection)

	err := tx.All(&questions)
	if err != nil {
		helmLog.Info("Something went wrong in GetLikertQuestions")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}
	return c.Render(200, r.JSON(questions))
}

// GetIpsativeData returns ipsative data
// the path GET /api/ipsative_data/{surveyID}
func GetIpsativeData(c buffalo.Context) error {

	data := []models.IpsativeData{}

	tx := c.Value("tx").(*pop.Connection)
	err := tx.Where("survey_id = ($1)", c.Param("surveyID") ).All(&data)
	if err != nil {
		helmLog.Info("Something went wrong in GetIpsativeData")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}
	return c.Render(200, r.JSON(data))
}