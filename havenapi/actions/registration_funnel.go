package actions

import (
	"fmt"
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

	log.Info("processed a registration")
	message := "success"
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}
