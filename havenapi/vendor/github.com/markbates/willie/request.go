package willie

import (
	"io"
	"net/http"
	"net/http/httptest"
	"strings"

	"github.com/ajg/form"
	"github.com/markbates/hmax"
)

type Request struct {
	URL      string
	Willie   *Willie
	Headers  map[string]string
	Username string
	Password string
}

func (r *Request) SetBasicAuth(username, password string) {
	r.Username = username
	r.Password = password
}

func (r *Request) Get() *Response {
	req, _ := http.NewRequest("GET", r.URL, nil)
	return r.perform(req)
}

func (r *Request) Delete() *Response {
	req, _ := http.NewRequest("DELETE", r.URL, nil)
	return r.perform(req)
}

func (r *Request) Post(body interface{}) *Response {
	req, _ := http.NewRequest("POST", r.URL, toReader(body))
	r.Headers["Content-Type"] = "application/x-www-form-urlencoded"
	return r.perform(req)
}

func (r *Request) Put(body interface{}) *Response {
	req, _ := http.NewRequest("PUT", r.URL, toReader(body))
	r.Headers["Content-Type"] = "application/x-www-form-urlencoded"
	return r.perform(req)
}

func (r *Request) MultiPartPost(body interface{}) *Response {
	req, _ := http.NewRequest("POST", r.URL, toReader(body))
	r.Headers["Content-Type"] = "multipart/form-data"
	return r.perform(req)
}

func (r *Request) MultiPartPut(body interface{}) *Response {
	req, _ := http.NewRequest("PUT", r.URL, toReader(body))
	r.Headers["Content-Type"] = "multipart/form-data"
	return r.perform(req)
}

func (r *Request) perform(req *http.Request) *Response {
	if r.Willie.HmaxSecret != "" {
		hmax.SignRequest(req, []byte(r.Willie.HmaxSecret))
	}
	if r.Username != "" || r.Password != "" {
		req.SetBasicAuth(r.Username, r.Password)
	}
	res := &Response{httptest.NewRecorder()}
	for key, value := range r.Headers {
		req.Header.Set(key, value)
	}
	req.Header.Set("Cookie", r.Willie.Cookies)
	r.Willie.ServeHTTP(res, req)
	c := res.HeaderMap["Set-Cookie"]
	r.Willie.Cookies = strings.Join(c, ";")
	return res
}

func toReader(body interface{}) io.Reader {
	if _, ok := body.(encodable); !ok {
		body, _ = form.EncodeToValues(body)
	}
	return strings.NewReader(body.(encodable).Encode())
}
