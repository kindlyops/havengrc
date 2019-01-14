package grifts

import (
	"regexp"

	"github.com/kindlyops/havengrc/havenapi/actions"
	. "github.com/markbates/grift/grift"
)

// TODO needs refactor after recent changes to CreateSlide
var _ = Namespace("files", func() {

	Desc("create_slide", "Create a test slide.")
	Add("create_slide", func(c *Context) error {
		// Ensure the args are email addresses.
		var rxEmail = regexp.MustCompile("^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
		if len(c.Args) >= 1 {
			for _, e := range c.Args {
				if len(e) < 254 || rxEmail.MatchString(e) {
					actions.CreateSlide(e)
				}
			}
		} else {
			actions.CreateSlide("user1@havengrc.com")
		}
		return nil
	})

})
