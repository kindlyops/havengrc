package fix

import (
	"testing"

	"github.com/gobuffalo/packr"
	"github.com/stretchr/testify/require"
)

func Test_Init_And_Find(t *testing.T) {
	r := require.New(t)

	box := packr.NewBox("./init-fixtures")

	r.NoError(Init(box))

	s, err := Find("lots of widgets")
	r.NoError(err)
	r.Equal("lots of widgets", s.Name)

	r.Len(s.Tables, 2)

	table := s.Tables[0]
	r.Equal("widgets", table.Name)
	r.Len(table.Row, 2)

	row := table.Row[0]
	r.NotZero(row["id"])
	r.NotZero(row["created_at"])
	r.NotZero(row["updated_at"])
	r.Equal("This is widget #1", row["name"])
	r.Equal("some widget body", row["body"])

	wid := row["id"]

	row = table.Row[1]
	r.NotZero(row["id"])
	r.NotZero(row["created_at"])
	r.NotZero(row["updated_at"])
	r.Equal("This is widget #2", row["name"])
	r.Equal("some widget body", row["body"])

	table = s.Tables[1]
	r.Equal("users", table.Name)
	r.Len(table.Row, 1)

	row = table.Row[0]
	r.NotZero(row["id"])
	r.NotZero(row["created_at"])
	r.NotZero(row["updated_at"])
	r.True(row["admin"].(bool))
	r.Equal(19.99, row["price"].(float64))
	r.Equal(wid, row["widget_id"])
}
