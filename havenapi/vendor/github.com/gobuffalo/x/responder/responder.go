package responder

import (
	"strings"
	"sync"

	"github.com/gobuffalo/buffalo"
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
	for _, ct := range contentTypes(ctx) {
		for w, h := range r.wants {
			if strings.Contains(ct, strings.ToLower(w)) {
				return h(ctx)
			}
		}
	}
	if h, ok := r.wants["html"]; ok {
		return h(ctx)
	}
	return errors.New("could not find any matching handlers for this request")
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

func contentTypes(ctx buffalo.Context) []string {
	var cts []string
	for _, x := range []string{"Accept", "Content-Type"} {
		ct := ctx.Request().Header.Get(x)
		if strings.Contains(ct, ",") {
			cts = append(cts, strings.Split(ct, ",")...)
		} else {
			cts = append(cts, strings.Split(ct, ";")...)
		}
		for _, c := range cts {
			c = strings.TrimSpace(c)
			if strings.HasPrefix(c, "*/*") {
				continue
			}
			cts = append(cts, strings.ToLower(c))
		}
	}
	return cts
}
