package cmd

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/gobuffalo/makr"
	"github.com/gobuffalo/packr"
	"github.com/markbates/inflect"
	"github.com/pkg/errors"
	"github.com/spf13/cobra"
)

var mailer = struct {
	name     string
	skipInit bool
}{}

var mailerCmd = &cobra.Command{
	Use:   "mailer",
	Short: "Generates a new mailer for Buffalo",
	RunE: func(cmd *cobra.Command, args []string) error {
		if len(args) == 0 {
			return errors.New("you must supply a name for your mailer")
		}
		mailer.name = args[0]
		data := makr.Data{
			"ProperName": inflect.Camelize(mailer.name),
			"FileName":   inflect.Underscore(mailer.name),
			"TitleName":  inflect.Titleize(mailer.name),
		}
		err := initGenerator(data)
		if err != nil {
			return errors.WithStack(err)
		}
		return mailerGenerator(data)

	},
}

func init() {
	RootCmd.AddCommand(mailerCmd)
	mailerCmd.Flags().BoolVar(&mailer.skipInit, "skip-init", false, "skip initializing mailers/")
}

func mailerGenerator(data makr.Data) error {
	g := makr.New()
	fn := data["FileName"].(string)
	g.Add(makr.NewFile(filepath.Join("mailers", fn+".go"), mailerTmpl))
	g.Add(makr.NewFile(filepath.Join("templates", "mail", fn+".html"), mailTmpl))
	return g.Run(".", data)
}

func initGenerator(data makr.Data) error {
	box := packr.NewBox("./init")
	g := makr.New()
	err := box.Walk(func(p string, f packr.File) error {
		info, err := f.FileInfo()
		if err != nil {
			return errors.WithStack(err)
		}
		if info.IsDir() {
			return nil
		}
		if strings.HasSuffix(p, ".tmpl") {
			fp := strings.TrimSuffix(p, ".tmpl")
			g.Add(makr.NewFile(fp, box.String(p)))
		}
		return nil
	})
	if err != nil {
		return errors.WithStack(err)
	}
	g.Should = func(data makr.Data) bool {
		if mailer.skipInit {
			return false
		}
		if _, err := os.Stat(filepath.Join("mailers", "mailers.go")); err == nil {
			return false
		}
		return true
	}
	return g.Run(".", data)
}

const mailerTmpl = `package mailers

import (
	"github.com/gobuffalo/buffalo/render"
	"github.com/gobuffalo/x/mail"
	"github.com/pkg/errors"
)

func Send{{.ProperName}}() error {
	m := mail.NewMessage()

	// fill in with your stuff:
	m.Subject = "{{.TitleName}}"
	m.From = ""
	m.To = []string{}
	err := m.AddBody(r.HTML("{{.FileName}}.html"), render.Data{})
	if err != nil {
		return errors.WithStack(err)
	}
	return smtp.Send(m)
}
`

const mailTmpl = `<h2>{{.TitleName}}</h2>

<h3>../templates/mail/{{.FileName}}.html</h3>`
