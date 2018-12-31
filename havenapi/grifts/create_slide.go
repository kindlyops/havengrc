package grifts

import (
	"github.com/kindlyops/havengrc/havenapi/actions"

	. "github.com/markbates/grift/grift"
)

var _ = Namespace("files", func() {

	Desc("create_slide", "Create a test slide.")
	Add("create_slide", func(c *Context) error {
		actions.CreateSlide("testemail@testemail.com")
		return nil
	})

})
