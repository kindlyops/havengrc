package actions

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
)

type token struct {
	Token string `json:"access_token"`
}

// For example purposes
type users struct {
	LastName string `json:"email"`
	ID       int    `json:"id"`
}

var adminToken = token{}

// Example env vars (KC_HOST=http://localhost | KC_PORT=2015)
var adminUser = os.Getenv("KC_ADMIN")
var adminPw = os.Getenv("KC_PW")
var keycloakHost = os.Getenv("KC_HOST") + ":" + os.Getenv("KC_PORT")
var getTokenURL = "/auth/realms/master/protocol/openid-connect/token"
var getUsersURL = "/auth/admin/realms/havendev/users"

// KeycloakGetToken grabs the token for the admin api.
func KeycloakGetToken() bool {

	form := url.Values{
		"username":   {adminUser},
		"password":   {adminPw},
		"client_id":  {"admin-cli"},
		"grant_type": {"password"},
	}

	body := bytes.NewBufferString(form.Encode())
	resp, err := http.Post(
		keycloakHost+getTokenURL,
		"application/x-www-form-urlencoded",
		body,
	)
	if err != nil {
		return false
	}
	defer resp.Body.Close()

	bodyByte, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return false
	}

	err = json.Unmarshal(bodyByte, &adminToken)
	if err != nil {
		fmt.Println(err)
		return false
	}
	return true
}

// KeycloakGetUsers grabs the users from the admin api.
func KeycloakGetUsers() {
	client := &http.Client{}

	req, err := http.NewRequest("GET", keycloakHost+getUsersURL, nil)
	req.Header.Add("Authorization", "bearer "+adminToken.Token)

	if err != nil {
		return
	}
	resp, err := client.Do(req)
	defer resp.Body.Close()
	data := []users{}

	bodyByte, err := ioutil.ReadAll(resp.Body)
	err = json.Unmarshal(bodyByte, &data)

	//s := string(bodyByte[:])
	fmt.Printf("%#v", data)

	if err != nil {
		return
	}
}
