package grifts

import (
	"github.com/gobuffalo/buffalo"
	"github.com/kindlyops/mappamundi/havenapi/actions"
)

func init() {
	buffalo.Grifts(actions.App())
}
