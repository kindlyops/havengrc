package actions

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"

	faktory "github.com/contribsys/faktory/client"
	"github.com/deis/helm/log"
	"github.com/getsentry/raven-go"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/havengrc/havenapi/models"
	"go.uber.org/ratelimit"
)

// rl is the rate limited to 5 requests per second.
var rl = ratelimit.New(5)

// ResultsStruct is a struct for the funnel
type ResultsStruct struct {
	ID     string `json:"answer_id"`
	Group  int    `json:"group_number"`
	Points int    `json:"points_assigned"`
}

// RegistrationStruct is a struct for the funnel
type RegistrationStruct struct {
	Email   string          `json:"email"`
	Results []ResultsStruct `json:"survey_results"`
}

// RegistrationHandler accepts json
func RegistrationHandler(c buffalo.Context) error {
	rl.Take()
	tx := c.Value("tx").(*pop.Connection)
	request := c.Request()
	var registration RegistrationStruct
	body, err := ioutil.ReadAll(request.Body)

	err = json.Unmarshal(body, &registration)

	if err != nil {
		raven.CaptureError(err, nil)
		return c.Error(500, err)
	}
	log.Info(registration.Email)
	log.Info("body: %s", body)
	results, err := json.Marshal(registration.Results)
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}
	remoteAddress := strings.Split(request.RemoteAddr, ":")[0]

	err = tx.RawQuery(
		models.Q["registeruser"],
		registration.Email,
		remoteAddress,
		results,
	).Exec()

	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(
			500,
			fmt.Errorf(
				"Error inserting registration to database: %s for remote address %s",
				err.Error(),
				remoteAddress))
	}

	// Add job to the queue
	client, err := faktory.Open()
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}
	createUserJob := faktory.NewJob("CreateUser", registration.Email)
	err = client.Push(createUserJob)
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}
	saveSurveyJob := faktory.NewJob("SaveSurvey", registration.Email)
	err = client.Push(saveSurveyJob)
	if err != nil {
		raven.CaptureError(err, nil)

		return c.Error(500, err)
	}
	message := fmt.Sprintf("New registration for: %s", registration.Email)
	err = sendSlackNotification(message)
	if err != nil {
		raven.CaptureError(err, nil)
	}

	log.Info(message)

	return c.Render(200, r.JSON(map[string]string{"message": message}))
}

func sendSlackNotification(msg string) error {
	slackURL, ok := getEnv("SLACK_WEBHOOK")
	if !ok {
		return fmt.Errorf("No Slack Webhook found")
	}
	client := &http.Client{}

	var jsonStr = []byte(fmt.Sprintf(`{"text": "%s"}`, msg))
	body := bytes.NewBuffer(jsonStr)
	req, err := http.NewRequest("POST", slackURL, body)
	if err != nil {
		return fmt.Errorf("Error creating slack webhook: %s", err.Error())
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("Error sending slack webhook: %s", err.Error())
	}

	defer resp.Body.Close()

	return nil
}

func getEnv(key string) (string, bool) {
	// Default returns false to signify no such env var.
	err := false
	if value, ok := os.LookupEnv(key); ok {
		return value, ok
	}
	return "", err
}
