package models

import (
	"encoding/json"

	"github.com/gobuffalo/pop"
	"github.com/gobuffalo/uuid"
	"github.com/gobuffalo/validate"
	"github.com/gobuffalo/validate/validators"
	"github.com/gobuffalo/pop/slices"
)

// State provides us with the current state of the user
type State struct {
	ID        uuid.UUID `json:"id" db:"id"`
	JSON      slices.Map    `json:"json" db:"json"`
}
// StateBinding provides us with something to bind to
type StateBinding struct {
	Status                string `json:"status"`
	DownloadedReport     bool `json:"downloaded_report"`
}

// String is not required by pop and may be deleted
func (c State) String() string {
	jc, _ := json.Marshal(c)
	return string(jc)
}

// States is not required by pop and may be deleted
type States []State

// String is not required by pop and may be deleted
func (c States) String() string {
	jc, _ := json.Marshal(c)
	return string(jc)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (c *State) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.UUIDIsPresent{Field: c.ID, Name: "ID"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (c *State) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (c *State) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
