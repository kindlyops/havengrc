package responder

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gobuffalo/buffalo"
	"github.com/stretchr/testify/require"
)

type context struct {
	buffalo.Context
	request *http.Request
}

func (c context) Request() *http.Request {
	return c.request
}

var htmlCtx = newContext("text/html")
var formCtx = newContext("multipart-form")
var jsonCtx = newContext("application/json")

func newContext(ct string) buffalo.Context {
	ctx := context{Context: &buffalo.DefaultContext{}}
	req := httptest.NewRequest("GET", "/", nil)
	req.Header.Set("Content-Type", ct)
	ctx.request = req
	return ctx
}

func Test_Wants(t *testing.T) {
	r := require.New(t)

	var value string
	res := Wants("html", func(c buffalo.Context) error {
		value = "html!"
		return nil
	})

	res.Wants("json", func(c buffalo.Context) error {
		value = "json!"
		return nil
	})

	err := res.Respond(htmlCtx)
	r.NoError(err)
	r.Equal("html!", value)

	err = res.Respond(jsonCtx)
	r.NoError(err)
	r.Equal("json!", value)

	value = ""
	err = res.Respond(formCtx)
	r.NoError(err)
	r.Equal("html!", value)
}

func Test_Wants_Chain(t *testing.T) {
	r := require.New(t)

	var value string
	res := Wants("html", func(c buffalo.Context) error {
		value = "html!"
		return nil
	}).Wants("json", func(c buffalo.Context) error {
		value = "json!"
		return nil
	})

	err := res.Respond(htmlCtx)
	r.NoError(err)
	r.Equal("html!", value)

	err = res.Respond(jsonCtx)
	r.NoError(err)
	r.Equal("json!", value)

	value = ""
	err = res.Respond(formCtx)
	r.NoError(err)
	r.Equal("html!", value)
}
