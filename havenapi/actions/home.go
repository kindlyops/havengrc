package actions

import (
	"fmt"

	"github.com/gobuffalo/buffalo"
	"github.com/kindlyops/havengrc/havenapi/models"
)

// HealthzHandler checks for a working DB connection
func HealthzHandler(c buffalo.Context) error {
	err := models.DB.RawQuery("select 1").Exec()
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	return c.Render(200, r.JSON(map[string]string{"message": "I love you"}))
}
