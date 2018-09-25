package main

import (
	"fmt"

	worker "github.com/contribsys/faktory_worker_go"
	keycloak "github.com/kindlyops/mappamundi/havenapi/keycloak"
)

// CreateUser creates a new user with keycloak
func CreateUser(ctx worker.Context, args ...interface{}) error {
	fmt.Println("Working on job", ctx.Jid())
	err := keycloak.KeycloakCreateUser(args[0])
	if err != nil {
		return ctx.Error(500, err)
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
