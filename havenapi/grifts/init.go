package grifts

import (
	"github.com/gobuffalo/buffalo"
	"github.com/kindlyops/havengrc/havenapi/actions"
)

func init() {
	buffalo.Grifts(actions.App())
}
