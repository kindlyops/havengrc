package fix

import (
	"testing"

	"github.com/gobuffalo/plush"
	"github.com/stretchr/testify/require"
)

func Test_hash(t *testing.T) {
	r := require.New(t)
	s, err := hash("password", map[string]interface{}{}, plush.HelperContext{})
	r.NoError(err)
	r.NotEqual("password", s)
}
