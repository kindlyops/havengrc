package main

import (
	"log"

	"github.com/kindlyops/mappamundi/havenapi/actions"
)

func main() {
	app := actions.App()
	if err := app.Serve(); err != nil {
		log.Fatal(err)
	}
}
