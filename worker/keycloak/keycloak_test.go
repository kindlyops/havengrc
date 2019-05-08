package keycloak

import (
	"bytes"
	"io/ioutil"
	"net/url"
	"path/filepath"
	"testing"

	"github.com/google/go-cmp/cmp"
	"github.com/stretchr/testify/assert"
)

func TestGetToken(t *testing.T) {
	err := GetToken()
	if err != nil {
		t.Errorf("Failed test because: %s", err.Error())
	}
}

func TestGetUser(t *testing.T) {
	users, err := GetUser("user1@havengrc.com")
	if err != nil {
		t.Errorf("Failed test because: %s and %s", err.Error(), users)
	}
	if len(users) == 0 {
		t.Errorf("Failed and found %s", users)
	}
	t.Logf("Found %s", users[0].ID)
}

func TestVerifyEmail(t *testing.T) {
	err := SendVerificationEmail("user1@havengrc.com")
	if err != nil {
		t.Errorf("Failed test because: %s", err.Error())
	}
}

func helperLoadBytes(t *testing.T, name string) []byte {
	path := filepath.Join("testdata", name) // relative path
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		t.Fatal(err)
	}
	return bytes
}

func TestMagicLinkParser(t *testing.T) {
	body := helperLoadBytes(t, "sampleresponse.html")
	formURL, err := ParseMagicLinkForm(bytes.NewBuffer(body))
	if err != nil {
		t.Errorf("Failed TestMagicLinkParser because: %s", err.Error())
	}

	u, err := url.Parse(formURL)
	if err != nil {
		t.Errorf("Failed to parse URL because: %s", err.Error())
	}
	q := u.Query()

	if val, ok := q["client_id"]; ok {
		assert.Equal(t, val, []string{"magic-link"}, "The client_id parameter should be 'magic-link'.")
	} else {
		t.Errorf("URL query params did not contain %s", "client_id")
	}

	if _, ok := q["session_code"]; !ok {
		t.Errorf("URL query params did not contain %s", "session_code")
	}

	if _, ok := q["execution"]; !ok {
		t.Errorf("URL query params did not contain %s", "execution")
	}

	expectedPath := "/auth/realms/havendev/login-actions/authenticate"
	diff := cmp.Diff(u.Path, expectedPath)
	if diff != "" {
		t.Fatalf(diff)
	}
}

func TestWelcomeEmail(t *testing.T) {
	err := SendWelcomeEmail("user1@havengrc.com")
	if err != nil {
		t.Errorf("Failed test because: %s", err.Error())
	}
}
