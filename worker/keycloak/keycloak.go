package keycloak

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"strings"
	"time"

	"github.com/deis/helm/log"
	"golang.org/x/net/html"
)

type token struct {
	AccessToken    string `json:"access_token"`
	Expires        int    `json:"expires_in"`
	NotBefore      int    `json:"not-before-policy"`
	RefreshExpires int    `json:"refresh_expires_in"`
	RefreshToken   string `json:"refresh_token"`
	Scope          string `json:"scope"`
	SessionState   string `json:"session_state"`
	TokenType      string `json:"token_type"`
}

// Users is a struct that contains useful user data.
type Users struct {
	UserName string `json:"username"`
	ID       string `json:"id"`
}

var adminToken = token{}
var currentTime = time.Now()
var expirationDate = currentTime.Unix()

// Example env vars (KC_HOST=http://localhost | KC_PORT=2015)
var adminUser = os.Getenv("KC_ADMIN")
var adminPw = os.Getenv("KC_PW")
var keycloakHost = os.Getenv("KC_HOST") + ":" + os.Getenv("KC_PORT")
var getTokenURL = "/auth/realms/master/protocol/openid-connect/token"
var getUsersURL = "/auth/admin/realms/havendev/users"
var getFormURL = "/auth/realms/havendev/protocol/openid-connect/auth" +
	"?client_id=magic-link&response_mode=fragment&response_type=code" +
	"&login=true&redirect_uri=%2Fdashboard&auth_session_id=none"

// GetToken grabs the token for the admin api.
func GetToken() error {
	currentTime = time.Now()
	fmt.Println("Expiration: ", expirationDate)
	if currentTime.Unix() < expirationDate {
		log.Info("the admin api token is still valid.")
		return nil
	}
	log.Info("the admin api token is being renewed.")

	// set up some default values for unit test environment
	if adminUser == "" {
		adminUser = "admin"
	}

	if adminPw == "" {
		adminPw = "admin"
	}

	if keycloakHost == ":" {
		keycloakHost = "http://dev.havengrc.com:2015"
	}

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
		return fmt.Errorf("Trouble fetching the token: %s", err.Error())
	}

	defer resp.Body.Close()

	bodyByte, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return fmt.Errorf("Trouble processing the response body: %s", err.Error())
	}

	err = json.Unmarshal(bodyByte, &adminToken)
	if err != nil {
		log.Info(string(bodyByte))
		log.Info("StatusCode: %d", resp.StatusCode)
		return fmt.Errorf("Trouble processing the json result: %s", err.Error())
	}
	expirationDate = currentTime.Unix() + int64(adminToken.Expires-5)
	return err
}

// GetUser checks if the user exists first.
func GetUser(email string) ([]Users, error) {
	err := GetToken()
	if err != nil {
		return nil, fmt.Errorf("Trouble getting the auth token: %s", err.Error())
	}
	client := &http.Client{}
	data := []Users{}
	req, err := http.NewRequest("GET", keycloakHost+getUsersURL, nil)
	if err != nil {
		return data, fmt.Errorf("Trouble creating an http request: %s", err.Error())
	}
	req.Header.Add("Authorization", "bearer "+adminToken.AccessToken)
	q := req.URL.Query()
	q.Add("username", email)

	req.URL.RawQuery = q.Encode()

	resp, err := client.Do(req)
	if err != nil {
		return data, fmt.Errorf("Trouble getting the list of users: %s", err.Error())
	}

	defer resp.Body.Close()

	// Look for an empty array if no users exist with that email.
	err = json.NewDecoder(resp.Body).Decode(&data)
	if err == io.EOF {
		err = nil
	}
	if err != nil {
		return data, fmt.Errorf("Error checking for existing user: %s", err.Error())
	}

	return data, err

}

// UserExistsError is returned when the user already exists
type UserExistsError struct {
	User string
}

func (e *UserExistsError) Error() string {
	return fmt.Sprintf("keycloak: could not create user: %s because it already exists", e.User)
}

// CreateUser creates a new user if the user does not already exist.
func CreateUser(email string) error {
	err := GetToken()
	if err != nil {
		return fmt.Errorf("Trouble getting the auth token: %s", err.Error())
	}
	client := &http.Client{}
	log.Info("Try to create: %s", email)
	userList, err := GetUser(email)
	if err != nil {
		return fmt.Errorf("trouble creating user:%s because %v", email, err)
	}
	if len(userList) > 0 {
		return &UserExistsError{email}
	}

	components := strings.Split(email, "@")
	var jsonStr = []byte(
		fmt.Sprintf(`{
			"username": "%s",
			"email": "%s",
			"enabled": true,
			"firstName": "%s",
			"lastName": "",
			"attributes": {
				"role": "member"
			}
			}`,
			email,
			email,
			components[0],
		))

	body := bytes.NewBuffer(jsonStr)
	req, err := http.NewRequest(
		"POST",
		keycloakHost+getUsersURL,
		body,
	)

	if err != nil {
		return fmt.Errorf("Trouble creating new user: %s", err.Error())
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Add("Authorization", "bearer "+adminToken.AccessToken)
	log.Info("Added headers")
	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("Trouble processing the response body error: %s", err.Error())
	}

	defer resp.Body.Close()

	if resp.StatusCode != 201 {
		return fmt.Errorf("Trouble creating user - StatusCode: %d", resp.StatusCode)
	}

	err = SendWelcomeEmail(email)
	if err != nil {
		return fmt.Errorf("Trouble sending verification email: %s", err.Error())
	}

	return err
}

// SendVerificationEmail verifies the email and let the user set a password.
func SendVerificationEmail(email string) error {
	err := GetToken()
	if err != nil {
		return fmt.Errorf("Trouble getting the auth token: %s", err.Error())
	}
	client := &http.Client{}
	log.Info("Try to verify email for: %s", email)
	userList, err := GetUser(email)
	if err != nil {
		return fmt.Errorf("Could not find user:%s because of: %s", email, err.Error())
	}

	var jsonStr = []byte(
		fmt.Sprintf(`["UPDATE_PASSWORD"]`))

	body := bytes.NewBuffer(jsonStr)
	redirectURI := "&redirect_uri=/#new-user"
	req, err := http.NewRequest(
		"PUT",
		keycloakHost+getUsersURL+"/"+userList[0].ID+"/execute-actions-email?client_id=havendev"+redirectURI,
		body,
	)

	if err != nil {
		return fmt.Errorf("Trouble executing verify email for user: %s", err.Error())
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Add("Authorization", "bearer "+adminToken.AccessToken)
	log.Info("Added headers")
	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("Trouble processing the response body error: %s", err.Error())
	}

	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return fmt.Errorf(
			"Trouble sending verify email for user - StatusCode: %d - Url: %s %s",
			resp.StatusCode,
			req.Host,
			req.URL.Path)
	}

	return err
}

// ParseMagicLinkForm parses the formUrl out of a keycloak magic link http response
func ParseMagicLinkForm(body io.Reader) (string, error) {
	doc, err := html.Parse(body)
	formURL := ""
	if err != nil {
		return formURL, fmt.Errorf("http read error: %s", err.Error())
	}
	var f func(*html.Node)
	f = func(n *html.Node) {
		if n.Type == html.ElementNode && n.Data == "form" {
			for _, s := range n.Attr {
				if s.Key == "action" {
					formURL = s.Val
				}
			}
		}
		for c := n.FirstChild; c != nil; c = c.NextSibling {
			f(c)
		}
	}
	f(doc)

	return formURL, nil
}

// SendWelcomeEmail sends the user a magic link
func SendWelcomeEmail(email string) error {
	err := GetToken()
	if err != nil {
		return fmt.Errorf("Trouble getting the auth token: %s", err.Error())
	}
	log.Info("Try to get form url for: %s", email)
	_, err = GetUser(email)
	if err != nil {
		return fmt.Errorf("Could not find user:%s because of: %s", email, err.Error())
	}

	resp, err := http.Get(keycloakHost + getFormURL)
	if err != nil {
		return fmt.Errorf("http get error: %s because of: %s", email, err.Error())
	}
	defer resp.Body.Close()

	formURL, err := ParseMagicLinkForm(resp.Body)
	if err != nil {
		return fmt.Errorf("Could not parse MagicLinkForm because %s", err.Error())
	}

	urlData := url.Values{}
	urlData.Set("email", email)

	response, err := http.PostForm(
		formURL,
		urlData,
	)
	if response.StatusCode != 200 {
		return fmt.Errorf("Trouble sending welcome email to user - StatusCode: %d", response.StatusCode)
	}

	if err != nil {
		return fmt.Errorf("http get error: %s because of: %s", email, err.Error())
	}

	return err
}
