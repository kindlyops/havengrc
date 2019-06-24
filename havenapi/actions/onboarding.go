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
		state.JSON["downloaded_report"] = "never"

		// State does not exist lets insert the first for the user.
		err = tx.RawQuery(
			models.Q["insertstate"],
			state.JSON,
		).Exec()
		if err != nil {
			return c.Error(404, err)
		}
	}

	return c.Render(200, r.JSON(state))
}


// UpdateState updates the state for a user. This function is mapped to
// the path POST /api/state
func UpdateState(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	// Check for a valid update
	if c.Param("status") == "" {
		return c.Error(404, fmt.Errorf("invalid request"))
	}

	if c.Param("downloaded_report") == "" {
		return c.Error(404, fmt.Errorf("invalid request"))
	}

	// Allocate an empty State
	state := &models.State{}

	// To find the state the value of sub from the Middleware is used.
	if err := tx.Find(state, c.Value("sub")); err != nil {
		return c.Error(404, fmt.Errorf("cannot update state"))
	}

	state.JSON["status"] = c.Param("status")
	state.JSON["downloaded_report"] = c.Param("downloaded_report")

	// Update the state for the user (User determined by JWT sub.)
	err := tx.RawQuery(
		models.Q["updatestate"],
		state.JSON,
	).Exec()
	if err != nil {
		return c.Error(404, err)
	}

	return c.Render(200, r.JSON(state))
}