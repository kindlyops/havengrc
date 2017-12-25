package actions

import (
	"bytes"
	"fmt"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/kindlyops/mappamundi/havenapi/models"
)

// UploadHandler accepts a file upload
func UploadHandler(c buffalo.Context) error {
	tx := models.DB
	tx.RawQuery("BEGIN;")
	tx.RawQuery("set local search_path to mappa, public;")
//	err := models.DB.RawQuery("set local search_path to mappa, public").Exec()
	//if err != nil {
//		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
//	}
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
