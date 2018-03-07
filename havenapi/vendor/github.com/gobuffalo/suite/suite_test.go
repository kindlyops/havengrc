package suite

import (
	"errors"
	"testing"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo/render"
)

type aSuite struct {
	*Action
}

func Test_aSuite(t *testing.T) {
	app := buffalo.New(buffalo.Options{})
	app.GET("/session-hello", func(c buffalo.Context) error {
		if n, ok := c.Session().Get("name").(string); ok {
			return c.Render(200, render.String(n))
		}
		return c.Error(500, errors.New("could not find name in session"))
	})
	as := &aSuite{NewAction(app)}
	Run(t, as)
}

func (as *aSuite) Test_Session() {
	as.Session.Set("name", "Homer Simpson")
	res := as.HTML("/session-hello").Get()
	as.Equal(200, res.Code)
	as.Contains(res.Body.String(), "Homer Simpson")

	as.Session.Clear()
	res = as.HTML("/session-hello").Get()
	as.Equal(500, res.Code)
}

func (as *aSuite) Test_Session_Resets() {
	res := as.HTML("/session-hello").Get()
	as.Equal(500, res.Code)
}
