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
