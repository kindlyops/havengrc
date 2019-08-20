package actions

import (

	"fmt"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/havengrc/havenapi/models"

)

// DashboardData is a struct of what data we want on the dashboard
type DashboardData struct {
	Slide      models.FileInfo `json:"slide"`
	Zip        models.FileInfo `json:"zip"`
}

// DashboardGetHandler returns all goodies for the dashboard
// the path GET /api/dashboard
func DashboardGetHandler(c buffalo.Context) error {

	dashboard := DashboardData{}

	tx := c.Value("tx").(*pop.Connection)
	// Get latest Powerpoint file
	err := tx.Where("name LIKE '%' || ($1) || '%'", "pptx").Order("created_at desc").Limit(1).First(&dashboard.Slide)
	if err != nil {
		log.Info("Something went wrong in DashboardGetHandler getting pptx")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}

	// Get latest Zip file
	err = tx.Where("name LIKE '%' || ($1) || '%'", "zip").Order("created_at desc").Limit(1).First(&dashboard.Zip)
	if err != nil {
		log.Info("Something went wrong in DashboardGetHandler getting zip")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}
	return c.Render(200, r.JSON(dashboard))
}
