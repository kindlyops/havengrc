package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop"
	"github.com/gobuffalo/uuid"
	"github.com/gobuffalo/validate"
	"github.com/gobuffalo/validate/validators"
)

// Survey is the survey data
type Survey struct {
	ID        uuid.UUID `json:"id" db:"id"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	Author    string    `json:"author" db:"author"`
	Name      string    `json:"name" db:"name"`
	Description      string    	`json:"description" db:"description"`
	Instructions      string    	`json:"instructions" db:"instructions"`
}

// IpsativeSurvey Is for the ipsative surveys available
type IpsativeSurvey Survey
// LikertSurvey Is for the ipsative surveys available
type LikertSurvey Survey

// TableName overrides the schema and table name
func (IpsativeSurvey) TableName() string {
	// schema.table_name
	return "mappa.ipsative_surveys"
}

// TableName overrides the schema and table name
func (LikertSurvey) TableName() string {
	// schema.table_name
	return "mappa.likert_surveys"
}
// String is not required by pop and may be deleted
func (s Survey) String() string {
	js, _ := json.Marshal(s)
	return string(js)
}
// Surveys is not required by pop and may be deleted
type Surveys []Survey

// String is not required by pop and may be deleted
func (s Surveys) String() string {
	js, _ := json.Marshal(s)
	return string(js)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (s *Survey) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.UUIDIsPresent{Field: s.ID, Name: "ID"},
		&validators.StringIsPresent{Field: s.Name, Name: "Name"},
		&validators.StringIsPresent{Field: s.Author, Name: "Author"},
		&validators.StringIsPresent{Field: s.Description, Name: "Description"},
		&validators.StringIsPresent{Field: s.Instructions, Name: "Instructions"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (s *Survey) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (s *Survey) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
