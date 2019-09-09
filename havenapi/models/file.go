package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop"
	"github.com/gobuffalo/uuid"
	"github.com/gobuffalo/validate"
	"github.com/gobuffalo/validate/validators"
)

// File is the survey data file
type File struct {
	ID        uuid.UUID `json:"id" db:"id"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UserID    uuid.UUID `json:"user_id" db:"user_id"`
	Name      string    `json:"name" db:"name"`
	File      []byte    `json:"file" db:"file"`
}

// FileInfo is the survey data file info
type FileInfo struct {
	ID        uuid.UUID `json:"id" db:"id"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UserID    uuid.UUID `json:"user_id" db:"user_id"`
	Name      string    `json:"name" db:"name"`
}

// TableName overrides the schema and table name
func (FileInfo) TableName() string {
	// schema.table_name
	return "files"
}

// TableName overrides the schema and table name
func (File) TableName() string {
	// schema.table_name
	return "mappa.files"
}

// String is not required by pop and may be deleted
func (f FileInfo) String() string {
	jf, _ := json.Marshal(f)
	return string(jf)
}

// String is not required by pop and may be deleted
func (f File) String() string {
	jf, _ := json.Marshal(f)
	return string(jf)
}

// Files is not required by pop and may be deleted
type Files []FileInfo

// String is not required by pop and may be deleted
func (f Files) String() string {
	jf, _ := json.Marshal(f)
	return string(jf)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (f *File) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.UUIDIsPresent{Field: f.UserID, Name: "UserID"},
		&validators.StringIsPresent{Field: f.Name, Name: "Name"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (f *File) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (f *File) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
