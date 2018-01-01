package actions

func (as *ActionSuite) Test_HomeHandler() {
	res := as.JSON("/healthz").Get()
	as.Equal(200, res.Code)
	as.Contains(res.Body.String(), "I love you")
}
