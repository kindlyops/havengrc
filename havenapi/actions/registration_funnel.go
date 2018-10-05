package actions

import (
	"bytes"
	"fmt"
	"net/http"
	"os"
	"strings"

	faktory "github.com/contribsys/faktory/client"
	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/mappamundi/havenapi/models"
	"go.uber.org/ratelimit"
)

// rl is the rate limited to 5 requests per second.
var rl = ratelimit.New(5)

// RegistrationHandler accepts json
func RegistrationHandler(c buffalo.Context) error {
	rl.Take()
	tx := c.Value("tx").(*pop.Connection)
	request := c.Request()
	request.ParseForm()

	remoteAddress := strings.Split(request.RemoteAddr, ":")[0]

	err := tx.RawQuery(
		models.Q["registeruser"],
		request.FormValue("email"),
		remoteAddress,
		request.FormValue("survey_results"),
	).Exec()

	if err != nil {
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
		return c.Error(500, err)
	}
	createUserJob := faktory.NewJob("CreateUser", request.FormValue("email"))
	err = client.Push(createUserJob)
	if err != nil {
		return c.Error(500, err)
	}
	saveSurveyJob := faktory.NewJob("SaveSurvey", request.FormValue("email"))
	err = client.Push(saveSurveyJob)
	if err != nil {
		return c.Error(500, err)
	}
	message := fmt.Sprintf("New registration for: %s", request.FormValue("email"))
	_ = sendSlackNotification(message)

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
