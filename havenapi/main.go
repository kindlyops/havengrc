package main

import (
	"log"

	"github.com/kindlyops/havengrc/havenapi/actions"
)

func main() {
	app := actions.App()
	if err := app.Serve(); err != nil {
		log.Fatal(err)
	}
}
