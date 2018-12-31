package main

import (
	"encoding/json"
	"fmt"
	"log"

	worker "github.com/contribsys/faktory_worker_go"
	"github.com/getsentry/raven-go"
	"github.com/gobuffalo/envy"
	"github.com/jmoiron/sqlx"
	keycloak "github.com/kindlyops/havengrc/havenapi/keycloak"
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

// SurveyResponse is a data type for the survey
type SurveyResponse struct {
	ID             string `json:"uuid"`
	UserID         string `json:"user_id"`
	Email          string `json:"user_email"`
	Org            string `json:"org"`
	AnswerID       string `json:"answer_id"`
	GroupNumber    int    `json:"group_number"`
	PointsAssigned int    `json:"points_assigned"`
	CreatedAt      string `json:"created_at"`
}

// SurveyResponses is for a collection of SurveyResponse.
type SurveyResponses struct {
	Collection []SurveyResponse
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
	fmt.Println("Working on CreateUser job", ctx.Jid())
	userEmail := args[0].(string)
	err := keycloak.CreateUser(userEmail)
	switch err := err.(type) {
	case nil:
		fmt.Println("Created User: ", userEmail)
	case *keycloak.UserExistsError:
		// if we return an error from the job, it will be marked as failed
		// and tried again. We cannot recover from this error, so don't
		// get stuck in a retry loop.
		fmt.Println("user already exists")
	default:
		handleError(err)
	}

	return nil
}

// SaveSurvey saves the survey responses to the new user.
func SaveSurvey(ctx worker.Context, args ...interface{}) error {
	fmt.Println("Working on SaveSurvey job", ctx.Jid())
	userEmail := args[0].(string)

	// db is for the postgres connection.
	db, err := sqlx.Connect(
		"postgres",
		dbOptions,
	)
	handleError(err)

	defer db.Close()

	// Grab the users registration funnel info so we can use the survey data.
	registration := []Registration{}
	err = db.Select(&registration, "SELECT * FROM mappa.registration_funnel_1 WHERE registered=false AND email=$1 LIMIT 1", userEmail)
	log.Printf("SQL Result found user: %v", registration)
	handleError(err)

	// Set registered to true
	tx, err := db.Begin()
	handleError(err)

	_, err = tx.Exec("UPDATE mappa.registration_funnel_1 SET registered = true WHERE email=$1", userEmail)
	handleError(err)
	_, err = tx.Exec("SELECT set_config('request.jwt.claim.email', $1, true)", userEmail)
	handleError(err)
	_, err = tx.Exec("SELECT set_config('request.jwt.claim.sub', $1, true)", registration[0].ID)
	handleError(err)
	org, _ := json.Marshal(nil)
	_, err = tx.Exec("SELECT set_config('request.jwt.claim.org', $1, true)", string(org))
	handleError(err)

	// Collect the survey JSON
	surveyString := registration[0].SurveyJSON
	log.Printf("Survey Json found: %s", surveyString)
	responses := make([]SurveyResponse, 0)
	err = json.Unmarshal([]byte(surveyString), &responses)
	log.Printf("Responses found: %v", responses)
	if err != nil {
		log.Fatal(err)
	}

	for _, response := range responses {
		_, err = tx.Exec(
			"INSERT INTO mappa.ipsative_responses (answer_id, group_number, points_assigned) VALUES ($1, $2, $3)",
			response.AnswerID,
			response.GroupNumber,
			response.PointsAssigned,
		)
		handleError(err)
	}

	err = tx.Commit()
	if err != nil {
		log.Fatal(err)
	}
	return err
}

func handleError(err error) {
	if err != nil {
		raven.CaptureErrorAndWait(err, nil)
		log.Fatal(err)
	}
}

func setupAndRun() {

	mgr := worker.NewManager()

	// register job types and the function to execute them
	mgr.Register("CreateUser", CreateUser)
	mgr.Register("SaveSurvey", SaveSurvey)

	// use up to N goroutines to execute jobs
	mgr.Concurrency = 20

	// pull jobs from these queues, in this order of precedence
	mgr.Queues = []string{"critical", "default", "bulk"}
	fmt.Printf("Haven worker started, processing jobs\n")
	// Start processing jobs, this method does not return
	mgr.Run()
}

func main() {
	raven.CapturePanic(setupAndRun, nil)
}
