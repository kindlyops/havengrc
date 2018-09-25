package actions

import (
	"fmt"
	"strings"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/mappamundi/havenapi/models"
)

// RegistrationHandler accepts json
func RegistrationHandler(c buffalo.Context) error {
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

	log.Info("processed a registration")
	message := "success"
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}
