package actions

import (
	"fmt"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/kindlyops/havengrc/havenapi/models"
)

// CommentPostHandler accepts a comment upost
func CommentPostHandler(c buffalo.Context) error {
	err := models.DB.RawQuery("set local search_path to mappa, public").Exec()
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	// TODO: parse json, insert the comment, and send back the representation
	//request := c.Request()
	//buf := new(bytes.Buffer)
	//buf.ReadFrom(file)
	//err = models.DB.RawQuery(models.Q["insertcomment"], header.Filename, buf.Bytes()).Exec()
	//if err != nil {
	//	return c.Error(500, fmt.Errorf("error inserting comment to database: %s", err.Error()))
	//}

	message := "success"
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}

// CommentGetHandler accepts a comment upost
func CommentGetHandler(c buffalo.Context) error {
	err := models.DB.RawQuery("set local search_path to mappa, public").Exec()
	if err != nil {
		log.Info("Something went wrong in CommentGetHandler")
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	// TODO: figure out range, select, return JSON
	//request := c.Request()
	//buf := new(bytes.Buffer)
	//buf.ReadFrom(file)
	//err = models.DB.RawQuery(models.Q["getcomment"], header.Filename, buf.Bytes()).Exec()
	//if err != nil {
	//	return c.Error(500, fmt.Errorf("error inserting comment to database: %s", err.Error()))
	//}

	message := "success"
	return c.Render(200, r.JSON(map[string]string{"message": message}))
}
