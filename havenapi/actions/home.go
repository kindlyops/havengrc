package actions

import (
	"fmt"

	"github.com/gobuffalo/buffalo"
	"github.com/kindlyops/mappamundi/havenapi/models"
)

// HomeHandler is a default handler to serve up
// a home page.
func HomeHandler(c buffalo.Context) error {
	err := models.DB.RawQuery("set search_path to 'mappa'").Exec()
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	var count []int
	err = models.DB.RawQuery("select count(*) from comment").All(&count)
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	message := fmt.Sprintf("Welcome to HavenGRC! There are %d comments", count[0])
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}
