# github.com/gobuffalo/x/responder

```bash
$ go get -u github.com/gobuffalo/x/responder
```

This packages allows you to easily write "responders" that trigger different functions based on the incoming request `Content-Type` header.

For example, if you have a `UserList` `buffalo.Handler` that you want to be able to respond differently to `HTML` or `JSON` you can write a couple of responder functions that handle those different requests.

```go
func UserList(c buffalo.Context) error {
  // do some work
  return responder.Wants("html", func (c buffalo.Context) error {
    return c.Render(200, r.HTML("some/template.html"))
  }).Wants("json", func (c buffalo.Context) error {
    return c.Render(200, r.JSON(user))
  }).Respond(c)
}

// Alternate version
func UserList(c buffalo.Context) error {
  // do some work
  res :=  responder.Wants("html", func (c buffalo.Context) error {
    return c.Render(200, r.HTML("some/template.html"))
  })
  res.Wants("json", func (c buffalo.Context) error {
    return c.Render(200, r.JSON(user))
  })
  return res.Respond(c)
}
```
