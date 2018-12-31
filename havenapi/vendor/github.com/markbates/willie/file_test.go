package willie_test

import (
	"os"
	"testing"

	"github.com/markbates/willie"
	"github.com/stretchr/testify/require"
)

func Test_FileUpload(t *testing.T) {
	r := require.New(t)
	w := willie.New(App())

	f := struct {
		Name string
	}{"Foo"}

	rr, err := os.Open("./file_test.go")
	r.NoError(err)
	wf := willie.File{
		ParamName: "MyFile",
		FileName:  "foo.go",
		Reader:    rr,
	}

	res, err := w.HTML("/up").MultiPartPost(f, wf)
	r.NoError(err)
	r.Equal(200, res.Code)
	r.Equal("Foo\nfoo.go\n", res.Body.String())
}
