package sigtx

import (
	"context"
	"syscall"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func Test_WithCancel(t *testing.T) {
	r := require.New(t)
	ctx, cancel := WithCancel(context.Background(), syscall.SIGHUP)
	defer cancel()

	syscall.Kill(syscall.Getpid(), syscall.SIGHUP)

	var exit int
	select {
	case <-time.After(time.Second):
		exit = 1
	case <-ctx.Done():
		r.Error(ctx.Err())
		exit = 2
	}
	r.Equal(2, exit)
}

func Test_WithCancel_NoSignal(t *testing.T) {
	r := require.New(t)
	ctx, cancel := WithCancel(context.Background(), syscall.SIGHUP)
	defer cancel()

	var exit int
	select {
	case <-time.After(time.Second):
		exit = 1
	case <-ctx.Done():
		r.Error(ctx.Err())
		exit = 2
	}
	r.Equal(1, exit)
}
