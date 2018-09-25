package keycloak

func (as *ActionSuite) Test_GetToken() {
	err := GetToken()
	as.NoError(err)
}
