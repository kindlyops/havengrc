package suite

import (
	"github.com/gobuffalo/envy"
	"github.com/markbates/pop"
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
)

type Model struct {
	suite.Suite
	*require.Assertions
	DB *pop.Connection
}

func (m *Model) SetupTest() {
	m.Assertions = require.New(m.T())
	if m.DB != nil {
		err := m.DB.TruncateAll()
		m.NoError(err)
	}
}

func (m *Model) TearDownTest() {}

func NewModel() *Model {
	m := &Model{}
	c, err := pop.Connect(envy.Get("GO_ENV", "test"))
	if err == nil {
		m.DB = c
	}
	return m
}
