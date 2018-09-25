package keycloak

func (as *ActionSuite) Test_KeycloakGetToken() {
	err := KeycloakGetToken()
	as.NoError(err)
}
