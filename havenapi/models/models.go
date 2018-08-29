package models

import (
	"log"

	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/packr"
	"github.com/gobuffalo/pop"
	"github.com/nleof/goyesql"
)

// DB is a connection to your database to be used
// throughout your application.
var DB *pop.Connection

// Q is a map of SQL queries
var Q goyesql.Queries

func init() {
	var err error
	env := envy.Get("GO_ENV", "development")
	DB, err = pop.Connect(env)
	if err != nil {
		log.Fatal(err)
	}
	pop.Debug = env == "development"
	box := packr.NewBox("./sql")
	sql, err := box.MustBytes("queries.sql")
	if err != nil {
		log.Fatal(err)
	}
	Q = goyesql.MustParseBytes(sql)
}
