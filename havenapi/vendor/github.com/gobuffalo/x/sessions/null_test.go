package sessions

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_Null_Get(t *testing.T) {
	r := require.New(t)

	n := Null{}
	s, err := n.Get(nil, "foo")
	r.NoError(err)
	r.NotNil(s)
	s.Values["foo"] = "bar"
	err = s.Save(nil, nil)
	r.NoError(err)
}

func Test_Null_New(t *testing.T) {
	r := require.New(t)

	n := Null{}
	s, err := n.New(nil, "foo")
	r.NoError(err)
	r.NotNil(s)
	s.Values["foo"] = "bar"
	err = s.Save(nil, nil)
	r.NoError(err)
}
