package hmax_test

import (
	"bytes"
	"io/ioutil"
	"net/http"
	"testing"

	"github.com/markbates/hmax"
	"github.com/stretchr/testify/require"
)

var message = []byte("secure message")
var signature = "nfVW5dkRrMtKxkn1gsCF0VeBi6/1ira0wmb3nW8YjK4="
var h = hmax.New("X-Signature", []byte("password"))

func Test_Sign(t *testing.T) {
	r := require.New(t)

	s := h.Sign(message)
	r.Equal(signature, s)
}

func Test_Verify(t *testing.T) {
	r := require.New(t)

	b, err := h.Verify(signature, message)
	r.NoError(err)
	r.True(b)
}

func Test_SignRequest(t *testing.T) {
	r := require.New(t)

	rr := bytes.NewReader(message)
	req, err := http.NewRequest("GET", "/", rr)
	r.NoError(err)

	err = h.SignRequest(req)
	r.NoError(err)

	xs := req.Header.Get("X-Signature")
	r.Equal(signature, xs)

	// ensure the body has been reset
	b, _ := ioutil.ReadAll(req.Body)
	r.Equal(message, b)
}

func Test_VerifyRequest(t *testing.T) {
	r := require.New(t)

	rr := bytes.NewReader(message)
	req, err := http.NewRequest("GET", "/", rr)
	r.NoError(err)
	req.Header.Set("X-Signature", signature)

	r.True(h.VerifyRequest(req))
}
