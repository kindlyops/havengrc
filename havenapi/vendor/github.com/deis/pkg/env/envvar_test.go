package env

import (
	"fmt"
	"os"
	"testing"

	"github.com/Masterminds/cookoo"
)

func TestGet(t *testing.T) {
	reg, router, cxt := cookoo.Cookoo()

	drink := "DEIS_DRINK_OF_CHOICE"
	cookies := "DEIS_FAVORITE_COOKIES"
	snack := "DEIS_SNACK_TIME"
	snackVal := fmt.Sprintf("$%s and $%s cookies", drink, cookies)

	// Set drink, but not cookies.
	os.Setenv(drink, "coffee")

	reg.Route("test", "Test route").
		Does(Get, "res").
		Using(drink).WithDefault("tea").
		Using(cookies).WithDefault("chocolate chip").
		Does(Get, "res2").
		Using(snack).WithDefault(snackVal)

	err := router.HandleRequest("test", cxt, true)
	if err != nil {
		t.Error(err)
	}

	// Drink should still be coffee.
	if coffee := cxt.Get(drink, "").(string); coffee != "coffee" {
		t.Errorf("A great sin has been committed. Expected coffee, but got '%s'", coffee)
	}
	// Env var should be untouched
	if coffee := os.Getenv(drink); coffee != "coffee" {
		t.Errorf("Environment was changed from 'coffee' to '%s'", coffee)
	}

	// Cookies should have been set to the default
	if cookies := cxt.Get(cookies, "").(string); cookies != "chocolate chip" {
		t.Errorf("Expected chocolate chip cookies, but instead, got '%s' :-(", cookies)
	}

	// In the environment, cookies should have been set.
	if cookies := os.Getenv(cookies); cookies != "chocolate chip" {
		t.Errorf("Expected environment to have chocolate chip cookies, but instead, got '%s'", cookies)
	}

	if both := cxt.Get(snack, "").(string); both != "coffee and chocolate chip cookies" {
		t.Errorf("Expected 'coffee and chocolate chip cookies'. Got '%s'", both)
	}
}

func TestSet(t *testing.T) {
	reg, router, cxt := cookoo.Cookoo()

	os.Setenv("SLURM", "COFFEE")

	reg.Route("test", "Test route").
		Does(Set, "res").
		Using("HELLO").WithDefault("hello").
		Using("EMPTY").WithDefault(nil).
		Using("FAVORITE_DRINK").WithDefault("$SLURM")

	if err := router.HandleRequest("test", cxt, true); err != nil {
		t.Error(err)
	}

	expect := map[string]string{
		"HELLO":          "hello",
		"EMPTY":          "",
		"FAVORITE_DRINK": "COFFEE",
	}

	for k, v := range expect {
		if v != os.Getenv(k) {
			t.Errorf("Expected env var %s to be '%s', got '%s'", k, v, os.Getenv(k))
		}
		if cv := cxt.Get(k, "___").(string); cv != v {
			t.Errorf("Expected context var %s to be '%s', got '%s'", k, v, cv)
		}
	}

}

// TestGetInterpolation is a regression test to make sure that values are
// interpolated correctly.
func TestGetInterpolation(t *testing.T) {
	reg, router, cxt := cookoo.Cookoo()

	os.Setenv("TEST_ENV", "is")

	reg.Route("test", "Test route").
		Does(Get, "res").
		Using("TEST_ENV2").WithDefault("de$TEST_ENV")

	if err := router.HandleRequest("test", cxt, true); err != nil {
		t.Error(err)
	}

	if os.Getenv("TEST_ENV2") != "deis" {
		t.Errorf("Expected 'deis', got '%s'", os.Getenv("TEST_ENV2"))
	}
}
