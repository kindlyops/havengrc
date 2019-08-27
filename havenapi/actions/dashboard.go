package actions

import (
	"time"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/gobuffalo/pop/slices"
	"github.com/gobuffalo/uuid"
	"github.com/kindlyops/havengrc/havenapi/models"
)

// lastSurveyResponse holds the survey responses and metadata
type lastSurveyResponse struct {
	ID             uuid.UUID  `json:"uuid" db:"uuid"`
	CreatedAt      time.Time  `json:"created_at" db:"created_at"`
	UserID         uuid.UUID  `json:"user_id" db:"user_id"`
	UserEmail      string     `json:"user_email" db:"user_email"`
	Org            slices.Map `json:"org" db:"org"`
	AnswerID       uuid.UUID  `json:"answer_id" db:"answer_id"`
	GroupNumber    int        `json:"group_number" db:"group_number"`
	PointsAssigned int        `json:"points_assigned" db:"points_assigned"`
	SurveyID       uuid.UUID  `json:"survey_response_id" db:"survey_response_id"`
}

type lastSurveyResponses []lastSurveyResponse

// DashboardData is a struct of what data we want on the dashboard
type DashboardData struct {
	Slide              models.FileInfo       `json:"slide"`
	Zip                models.FileInfo       `json:"zip"`
	LastSurveyResponse models.SurveyResponse `json:"last_survey_response"`
}

// partialResult is a struct of partial data for the dashboard
type partialResult struct {
	Slide              slices.Map            `json:"slide"`
	Zip                slices.Map            `json:"zip"`
	LastSurveyResponse models.SurveyResponse `json:"last_survey_response"`
}

// emptyResult is a struct of empty data for the dashboard
type emptyResult struct {
	Slide              slices.Map `json:"slide"`
	Zip                slices.Map `json:"zip"`
	LastSurveyResponse slices.Map `json:"last_survey_response"`
}

// DashboardGetHandler returns all goodies for the dashboard
// the path GET /api/dashboard
func DashboardGetHandler(c buffalo.Context) error {

	dashboard := DashboardData{}

	tx := c.Value("tx").(*pop.Connection)
	// Get latest survey response
	err := tx.Where("user_id = ($1)", c.Value("sub")).Order("created_at desc").Limit(1).First(&dashboard.LastSurveyResponse)
	if err != nil {
		log.Info("Something went wrong in DashboardGetHandler getting latest survey response")
		return c.Render(200, r.JSON(emptyResult{}))
	}
	// Provide partial data unless the files have been created.
	partial := partialResult{LastSurveyResponse: dashboard.LastSurveyResponse}
	// Get latest Powerpoint file
	err = tx.Where("name LIKE '%' || ($1) || '%'", "pptx").Order("created_at desc").Limit(1).First(&dashboard.Slide)
	if err != nil {
		log.Info("Something went wrong in DashboardGetHandler getting pptx")
		return c.Render(200, r.JSON(partial))
	}

	// Get latest Zip file
	err = tx.Where("name LIKE '%' || ($1) || '%'", "zip").Order("created_at desc").Limit(1).First(&dashboard.Zip)
	if err != nil {
		log.Info("Something went wrong in DashboardGetHandler getting zip")
		return c.Render(200, r.JSON(partial))
	}

	return c.Render(200, r.JSON(dashboard))
}
