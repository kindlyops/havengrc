package actions

func (as *ActionSuite) Test_KeycloakGetToken() {
	err := KeycloakGetToken()
	as.NoError(err)
}
