package actions

import (
	"bytes"
	"fmt"

	faktory "github.com/contribsys/faktory/client"
	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/havengrc/havenapi/models"

)

// UploadHandler accepts a file upload
func UploadHandler(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	request := c.Request()
	err := request.ParseMultipartForm(1024 * 1024 * 10) // 10MB
	if err != nil {
		return c.Error(500, fmt.Errorf("Trouble parsing that form: %s", err.Error()))
	}
	file, header, err := request.FormFile("file")
	if err != nil {
		return c.Error(500, fmt.Errorf("Trouble extracting the file: %s", err.Error()))
	}
	defer file.Close()
	log.Info("the file we got is named %s and is %d bytes long", header.Filename, header.Size)
	buf := new(bytes.Buffer)
	buf.ReadFrom(file)
	err = tx.RawQuery(models.Q["insertfile"], header.Filename, buf.Bytes()).Exec()
	if err != nil {
		return c.Error(500, fmt.Errorf("error inserting file to database: %s", err.Error()))
	}

	log.Info("processed a file")
	message := "success"
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}

// DownloadHandler downloads a report
func DownloadHandler(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)

	file := models.File{}
	err := tx.Find(&file, c.Param("file_id"))
	if err != nil {
		return c.Error(500, fmt.Errorf("error retrieving file from database: %s", err.Error()))
	}

	log.Info("Got Download")
	return c.Render(200,  r.Download(c, "report.zip", bytes.NewReader(file.File)))
}

// CreateSlide triggers a worker job to create a report with R
func CreateSlide(surveyID string, email string) error {
	// Add job to the queue
	client, err := faktory.Open()
	if err != nil {
		return err
	}
	createSlideJob := faktory.NewJob("CreateSlide", surveyID, email)
	err = client.Push(createSlideJob)
	return err
}

// GetFiles returns all files available for the user
// the path GET /api/files
func GetFiles(c buffalo.Context) error {

	files := models.Files{}

	tx := c.Value("tx").(*pop.Connection)

	err := tx.All(&files)
	if err != nil {
		log.Info("Something went wrong in GetFiles")
		return c.Error(500, fmt.Errorf("Database error here: %s", err.Error()))
	}
	return c.Render(200, r.JSON(files))
}
