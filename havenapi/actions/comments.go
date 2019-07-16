package actions

import (
	"fmt"
	"bytes"
	"io/ioutil"
	"encoding/json"

	"github.com/deis/helm/log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/gobuffalo/uuid"
	"github.com/kindlyops/havengrc/havenapi/models"
)

// CommentPostHandler accepts a comment post
func CommentPostHandler(c buffalo.Context) error {
	err := models.DB.RawQuery("set local search_path to mappa, public").Exec()
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	postComment := &models.PostComment{}
	request := c.Request()

	body, err := ioutil.ReadAll(request.Body)
	dec := json.NewDecoder(bytes.NewReader(body))
	dec.DisallowUnknownFields()
	if err := dec.Decode(&postComment); err != nil {
		return c.Error(400, fmt.Errorf("malformed post"))
	}
	comment := &models.Comment{}
	comment.Message   = postComment.Message
	comment.UserID, _ = uuid.FromString(c.Value("sub").(string))
	comment.UserEmail = c.Value("email").(string)

	// Allocate the db transaction
	tx := c.Value("tx").(*pop.Connection)
	verrs, err := tx.ValidateAndCreate(comment, "id", "created_at", "user_email", "user_id", "org")
	if err != nil {
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	if verrs.HasAny() {
		// Make the errors available inside the html template
		c.Set("errors", verrs)
		fmt.Printf("\nverrs: %v\n", verrs)

	}
	return c.Render(201, r.JSON(comment))
}

// CommentGetHandler accepts a comment get request
func CommentGetHandler(c buffalo.Context) error {
	err := models.DB.RawQuery("set local search_path to mappa, public").Exec()
	if err != nil {
		log.Info("Something went wrong in CommentGetHandler")
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	comments := []models.Comment{}
	tx := c.Value("tx").(*pop.Connection)

	err = tx.Where("user_id = ?", c.Value("sub")).All(&comments)
	if err != nil {
		log.Info("Something went wrong in CommentGetHandler")
		return c.Error(500, fmt.Errorf("Database error: %s", err.Error()))
	}
	return c.Render(200, r.JSON(comments))
}
