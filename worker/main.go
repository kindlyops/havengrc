package main

import (
	"fmt"
	"log"

	worker "github.com/contribsys/faktory_worker_go"
	"github.com/gobuffalo/envy"
	"github.com/jmoiron/sqlx"
	keycloak "github.com/kindlyops/mappamundi/havenapi/keycloak"
	_ "github.com/lib/pq"
	"github.com/nleof/goyesql"
)

// Registration is a data type for the registration funnel
type Registration struct {
	ID         string `db:"uuid"`
	Email      string `db:"email"`
	IP         string `db:"ip_address"`
	SurveyJSON string `db:"survey_results"`
	Registered bool   `db:"registered"`
	CreatedAt  string `db:"created_at"`
}

var dbUser = envy.Get("DATABASE_USERNAME", "postgres")
var dbName = envy.Get("DATABASE_NAME", "mappamundi_dev")
var dbPassword = envy.Get("DATABASE_PASSWORD", "postgres")
var dbHost = envy.Get("DATABASE_HOST", "db")
var dbOptions = fmt.Sprintf(
	"user=%s dbname=%s password=%s host=%s sslmode=disable",
	dbUser,
	dbName,
	dbPassword,
	dbHost,
)

// Q is a map of SQL queries
var Q goyesql.Queries

// CreateUser creates a new user with keycloak
func CreateUser(ctx worker.Context, args ...interface{}) error {
	fmt.Println("Working on job", ctx.Jid())
	userEmail := args[0].(string)
	err := keycloak.CreateUser(userEmail)
	if err != nil {
		return ctx.Err()
	}
	// db is for the postgres connection.
	db, err := sqlx.Connect(
		"postgres",
		dbOptions,
	)
	if err != nil {
		log.Fatal(err)
	}
	// Grab the users registration funnel info so we can use the survey data.
	registration := []Registration{}
	err = db.Select(&registration, "SELECT * FROM mappa.registration_funnel_1 WHERE registered=false AND email=$1 LIMIT 1", userEmail)
	log.Printf("SQL Result found user: %s", registration)
	if err != nil {
		log.Fatal(err)
	}
	// Set registered to true
	tx := db.MustBegin()
	tx.MustExec("UPDATE mappa.registration_funnel_1 SET registered = true WHERE email=$1", userEmail)
	tx.Commit()
	err = db.Close()
	if err != nil {
		log.Fatal(err)
	}
	return err
}

func main() {
	mgr := worker.NewManager()

	// register job types and the function to execute them
	mgr.Register("CreateUser", CreateUser)
	//mgr.Register("AnotherJob", anotherFunc)

	// use up to N goroutines to execute jobs
	mgr.Concurrency = 20

	// pull jobs from these queues, in this order of precedence
	mgr.Queues = []string{"critical", "default", "bulk"}

	// Start processing jobs, this method does not return
	mgr.Run()
}
