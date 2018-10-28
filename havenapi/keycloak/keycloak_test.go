package keycloak

import (
	"testing"
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
}

func TestVerifyEmail(t *testing.T) {
	err := SendVerificationEmail("user1@havengrc.com")
	if err != nil {
		t.Errorf("Failed test because: %s", err.Error())
	}
}
