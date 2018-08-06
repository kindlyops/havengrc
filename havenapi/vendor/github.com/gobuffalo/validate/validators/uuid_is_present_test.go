package validators_test

import (
	"testing"

	uuid "github.com/gobuffalo/uuid"
	"github.com/gobuffalo/validate"
	. "github.com/gobuffalo/validate/validators"
	"github.com/stretchr/testify/require"
)

func Test_UUIDIsPresent(t *testing.T) {
	r := require.New(t)

	id, err := uuid.NewV4()
	r.NoError(err)
	v := UUIDIsPresent{"Name", id}
	errors := validate.NewErrors()
	v.IsValid(errors)
	r.Equal(errors.Count(), 0)

	v = UUIDIsPresent{"Name", uuid.UUID{}}
	v.IsValid(errors)
	r.Equal(errors.Count(), 1)
	r.Equal(errors.Get("name"), []string{"Name can not be blank."})
}
