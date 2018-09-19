package actions

import (
	"fmt"

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

	err := tx.RawQuery(
		models.Q["registeruser"],
		request.FormValue("email"),
		request.FormValue("ip_address"),
		request.FormValue("survey_results"),
	).Exec()

	if err != nil {
		return c.Error(500, fmt.Errorf("error inserting registration to database: %s", err.Error()))
	}

	log.Info("processed a registration")
	message := "success"
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}
