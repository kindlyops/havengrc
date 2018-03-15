package form

import "github.com/gobuffalo/tags"

func (f Form) InputTag(opts tags.Options) *tags.Tag {
	if opts["type"] == nil {
		opts["type"] = "text"
	}
	return tags.New("input", opts)
}

func (f Form) DateTimeTag(opts tags.Options) *tags.Tag {
	if opts["type"] == nil {
		opts["type"] = "datetime-local"
	}
	if opts["format"] == nil {
		opts["format"] = "2006-01-02T03:04"
	}
	return tags.New("input", opts)
}
