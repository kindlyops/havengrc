package actions

import (
	"fmt"
	"github.com/gobuffalo/uuid"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop"
	"github.com/kindlyops/havengrc/havenapi/models"

)

// GetState gets the data for one user. This function is mapped to
// the path GET /api/state
func GetState(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	// Allocate an empty State
	state := &models.State{}

	// To find the state the value of sub from the Middleware is used.
	if err := tx.Find(state, c.Value("sub")); err != nil {
		// If it cannot find an entry for the user create a new one
		state.ID, err = uuid.FromString(c.Value("sub").(string))
		state.JSON = make(map[string]interface{})
		state.JSON["status"] = "new"
		state.JSON["downloaded_report"] = false

		// State does not exist lets insert the first for the user.
		err = tx.RawQuery(
			models.Q["insertstate"],
			state.JSON,
		).Exec()
		if err != nil {
			return c.Error(404, err)
		}
	}

	return c.Render(200, r.JSON(state.JSON))
}


// UpdateState updates the state for a user. This function is mapped to
// the path POST /api/state
func UpdateState(c buffalo.Context) error {

	b := &models.StateBinding{}
  if err := c.Bind(b); err != nil {
    return err
	}

	tx := c.Value("tx").(*pop.Connection)

	// Allocate an empty State
	state := &models.State{}

	// To find the state the value of sub from the Middleware is used.
	if err := tx.Find(state, c.Value("sub")); err != nil {
		return c.Error(404, fmt.Errorf("cannot update state"))
	}

	state.JSON["status"] = b.Status
	state.JSON["downloaded_report"] = b.DownloadedReport

	// Update the state for the user (User determined by JWT sub.)
	err := tx.RawQuery(
		models.Q["updatestate"],
		state.JSON,
	).Exec()
	if err != nil {
		return c.Error(404, err)
	}

	return c.Render(200, r.JSON(state.JSON))
}