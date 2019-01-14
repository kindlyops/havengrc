package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"

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

// SurveyData is a data type for the db select to create the csv
type SurveyData struct {
	ID       string `db:"uuid"`
	Question int    `db:"question_order"`
	Answer   int    `db:"answer_order"`
	Category string `db:"category"`
	Points   int    `db:"points_assigned"`
	UserID   string `db:"user_id"`
}

// SurveyResponse is a data type for the survey
type SurveyResponse struct {
	ID               string `json:"uuid"`
	UserID           string `json:"user_id"`
	Email            string `json:"user_email"`
	Org              string `json:"org"`
	AnswerID         string `json:"answer_id"`
	GroupNumber      int    `json:"group_number"`
	PointsAssigned   int    `json:"points_assigned"`
	CreatedAt        string `json:"created_at"`
	SurveyResponseID string `json:"survey_response_id"`
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
	// Get user id for registered user.
	users, err := keycloak.GetUser(userEmail)
	handleError(err)
	if len(users) == 0 {
		return fmt.Errorf("USER: User not registered yet. Try again later. %s", userEmail)
	}
	// Set registered to true
	tx, err := db.Beginx()
	handleError(err)

	_, err = tx.Exec("UPDATE mappa.registration_funnel_1 SET registered = true WHERE email=$1", userEmail)
	handleError(err)
	_, err = tx.Exec("SELECT set_config('request.jwt.claim.email', $1, true)", userEmail)
	handleError(err)
	_, err = tx.Exec("SELECT set_config('request.jwt.claim.sub', $1, true)", users[0].ID)
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
	surveyID, err := SaveSurveyResponses(responses, tx)
	handleError(err)
	err = createSurveyInput(surveyID, tx)
	handleError(err)
	err = createSlide(surveyID, userEmail)
	handleError(err)
	err = tx.Commit()
	if err != nil {
		log.Fatal(err)
	}
	return err
}

// SaveSurveyResponses creates a survey_response and saves all responses
func SaveSurveyResponses(responses []SurveyResponse, tx *sqlx.Tx) (string, error) {

	rows, err := tx.Query("INSERT INTO mappa.survey_responses DEFAUlT VALUES RETURNING uuid;")
	handleError(err)
	defer rows.Close()
	var surveyResponseID string
	for rows.Next() {
		var uuid string
		err = rows.Scan(&uuid)
		fmt.Println("Created new survey_response:", uuid)
		if err != nil {
			return "", err
		}
		surveyResponseID = uuid
	}

	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}

	for _, response := range responses {
		_, err = tx.Exec(
			"INSERT INTO mappa.ipsative_responses (answer_id, group_number, points_assigned, survey_response_id) VALUES ($1, $2, $3, $4)",
			response.AnswerID,
			response.GroupNumber,
			response.PointsAssigned,
			surveyResponseID,
		)
		handleError(err)
	}

	return surveyResponseID, err
}

// CreateSlideJob creates a slide using R for testing
func CreateSlideJob(ctx worker.Context, args ...interface{}) error {
	fmt.Println("Working on CreateSlide job ", ctx.Jid())
	surveyResponseID := args[0].(string)
	userEmail := args[1].(string)
	err := createSlide(surveyResponseID, userEmail)
	handleError(err)
	return err
}

// createSlide creates a slide user R
func createSlide(surveyID string, userEmail string) error {
	var inputFile = "/tmp/" + surveyID + ".csv"
	var outputDir = "output/"
	var outputFile = outputDir + surveyID + ".pptx"
	fmt.Println("Creating Slide for survey id: ", surveyID)
	compileReport := exec.Command("compilereport", "-d", inputFile, "-o", outputFile)
	compileReportOut, err := compileReport.Output()
	if err != nil {
		handleError(err)
	}
	fmt.Println("Output: ", compileReportOut)

	_, err = keycloak.GetUser(userEmail)
	handleError(err)
	fmt.Println("Created Slide for: ", userEmail)
	err = saveFileToDB(userEmail, outputFile)
	handleError(err)
	return err
}

// createSurveyInput creates a new survey input file for the user
func createSurveyInput(surveyID string, tx *sqlx.Tx) error {

	surveyData := []SurveyData{}

	err := tx.Select(&surveyData, `WITH current_survey AS(
		SELECT mappa.ipsative_responses.answer_id, mappa.survey_responses.user_id,
			mappa.ipsative_responses.points_assigned
		FROM mappa.ipsative_responses
		INNER JOIN mappa.survey_responses
		ON mappa.ipsative_responses.user_id=mappa.survey_responses.user_id
		WHERE mappa.ipsative_responses.survey_response_id = $1)
		SELECT mappa.ipsative_answers.uuid, (
			SELECT mappa.ipsative_questions.order_number
			FROM mappa.ipsative_questions
			WHERE mappa.ipsative_answers.question_id =  mappa.ipsative_questions.uuid)
			AS question_order, mappa.ipsative_answers.order_number AS answer_order, (
				SELECT mappa.ipsative_categories.category
				FROM mappa.ipsative_categories
				WHERE mappa.ipsative_answers.category_id =  mappa.ipsative_categories.uuid)
			, points_assigned
		FROM current_survey
		INNER JOIN mappa.ipsative_answers
		ON mappa.ipsative_answers.uuid = current_survey.answer_id`, surveyID)
	handleError(err)
	fileContents := "question,Process,Compliance,Autonomy,Trust,respondent\n"
	questions := make([][]int, 10)
	// Collect answer point assignments
	for i := range surveyData {
		questions[surveyData[i].Question-1] = append(
			questions[surveyData[i].Question-1],
			surveyData[i].Points)
	}
	// Supports only 1 respondent currently.
	respondent := "1"
	for i := range questions {
		fileContents += fmt.Sprintf("%d,%s,%s\n", i, strings.Trim(strings.Join(strings.Fields(fmt.Sprint(questions[i])), ","), "[]"), respondent)
	}

	// Create new file
	file, err := os.Create("/tmp/" + surveyID + ".csv")
	handleError(err)

	// Close file on exit and check for its returned error
	defer func() {
		err := file.Close()
		handleError(err)
	}()

	// Write the string to the file
	_, err = file.WriteString(fileContents)
	handleError(err)

	return err
}

func saveFileToDB(userEmail string, fileName string) error {
	file, err := os.Open(fileName)
	handleError(err)
	users, err := keycloak.GetUser(userEmail)
	handleError(err)
	db, err := sqlx.Connect(
		"postgres",
		dbOptions,
	)
	handleError(err)

	defer db.Close()

	tx, err := db.Begin()
	handleError(err)

	buf := new(bytes.Buffer)
	buf.ReadFrom(file)
	_, err = tx.Exec("SELECT set_config('request.jwt.claim.sub', $1, true)", users[0].ID)
	handleError(err)
	_, err = tx.Exec("INSERT INTO mappa.files (name, file) VALUES ($1, $2)", "report.pptx", buf.Bytes())
	handleError(err)

	err = tx.Commit()
	handleError(err)

	fmt.Println("processed a file")
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
	mgr.Register("CreateSlide", CreateSlideJob)

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
