package responder

import (
	"strings"
	"sync"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/x/httpx"
	"github.com/markbates/going/defaults"
	"github.com/pkg/errors"
)

// Responder holds the mappings of content-type to handler
type Responder struct {
	moot  *sync.Mutex
	wants map[string]buffalo.Handler
}

// Wants maps a content-type, or part of one ("json", "html", "form", etc...),
// to a buffalo.Handler to respond with when it gets that content-type.
func (r Responder) Wants(ct string, h buffalo.Handler) Responder {
	r.moot.Lock()
	defer r.moot.Unlock()
	ct = strings.ToLower(ct)
	r.wants[ct] = h
	if ct == "html" || ct == "form" {
		r.wants["html"] = h
		r.wants["form"] = h
	}
	return r
}

// Respond with a mapped buffalo.Handler, if one exists, returns an error if
// one does not.
/*
func UserList(c buffalo.Context) error {
	// do some work
	return responder.Wants("html", func (c buffalo.Context) error {
		return c.Render(200, r.HTML("some/template.html")
	}).Wants("json", func (c buffalo.Context) error {
		return c.Render(200, r.JSON(user))
	}).Respond(c)
}
*/
func (r Responder) Respond(ctx buffalo.Context) error {
	ct := defaults.String(httpx.ContentType(ctx.Request()), "html")
	for w, h := range r.wants {
		if strings.Contains(ct, strings.ToLower(w)) {
			return h(ctx)
		}
	}
	return errors.Errorf("could not find handler for content type %s", ct)
}

// Wants maps a content-type, or part of one ("json", "html", "form", etc...),
// to a buffalo.Handler to respond with when it gets that content-type, returns a
// Responder that can be used for further mappings.
func Wants(ct string, h buffalo.Handler) Responder {
	r := &Responder{
		moot:  &sync.Mutex{},
		wants: map[string]buffalo.Handler{},
	}
	return r.Wants(ct, h)
}
