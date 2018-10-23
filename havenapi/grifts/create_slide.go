package grifts

import (
	"../actions"

	. "github.com/markbates/grift/grift"
)

var _ = Namespace("files", func() {

	Desc("create_slide", "Create a test slide.")
	Add("create_slide", func(c *Context) error {
		actions.CreateSlide(c, "testemail@testemail.com")
		return nil
	})

})
