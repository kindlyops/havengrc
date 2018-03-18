package nulls

import (
	"encoding/json"
	"testing"

	uuid "github.com/satori/go.uuid"
	"github.com/stretchr/testify/require"
)

func Test_UUID_UnmarshalJSON(t *testing.T) {
	r := require.New(t)
	id := uuid.NewV4()

	b, err := json.Marshal(id)
	r.NoError(err)

	nid := &UUID{}

	r.NoError(nid.UnmarshalJSON(b))

	r.True(nid.Valid)
	r.Equal(id.String(), nid.UUID.String())
}
