package grifts

import (
	"fmt"
	"regexp"

	"github.com/kindlyops/havengrc/havenapi/actions"
	. "github.com/markbates/grift/grift"
)

var _ = Namespace("files", func() {

	Desc("create_slide", "Create a test slide.")
	Add("create_slide", func(c *Context) error {
		// Ensure the args are email addresses.
		var userEmail = "user1@havengrc.com"
		var surveyID = c.Args[0]
		var rxEmail = regexp.MustCompile("^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
		if len(c.Args) >= 1 {
			for _, e := range c.Args {
				if len(e) < 254 || rxEmail.MatchString(e) {
					userEmail = e
				}
			}
		}
		fmt.Println("Grift SurveyID: ", surveyID)
		fmt.Println("Grift userEmail: ", userEmail)
		actions.CreateSlide(surveyID, userEmail)
		return nil
	})

})
