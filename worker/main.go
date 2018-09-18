package main

import (
	"fmt"
	worker "github.com/contribsys/faktory_worker_go"
)

func someFunc(ctx worker.Context, args ...interface{}) error {
	fmt.Println("Working on job", ctx.Jid())
	return nil
}

func main() {
	mgr := worker.NewManager()

	// register job types and the function to execute them
	mgr.Register("SomeJob", someFunc)
	//mgr.Register("AnotherJob", anotherFunc)

	// use up to N goroutines to execute jobs
	mgr.Concurrency = 20

	// pull jobs from these queues, in this order of precedence
	mgr.Queues = []string{"critical", "default", "bulk"}

	// Start processing jobs, this method does not return
	mgr.Run()
}
