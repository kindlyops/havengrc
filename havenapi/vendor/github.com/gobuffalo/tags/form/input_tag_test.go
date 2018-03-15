package form_test

import (
	"testing"
	"time"

	"github.com/gobuffalo/tags"
	"github.com/gobuffalo/tags/form"
	"github.com/stretchr/testify/require"
)

func Test_Form_InputTag(t *testing.T) {
	r := require.New(t)
	f := form.New(tags.Options{})
	i := f.InputTag(tags.Options{})
	r.Equal(`<input type="text" />`, i.String())
}

func Test_Form_DateTimeTag(t *testing.T) {
	r := require.New(t)

	date, err := time.Parse("2006-01-02T03:04", "1976-08-24T06:17")
	r.NoError(err)

	f := form.New(tags.Options{})
	i := f.DateTimeTag(tags.Options{
		"value": date,
	})
	r.Equal(`<input type="datetime-local" value="1976-08-24T06:17" />`, i.String())
}
