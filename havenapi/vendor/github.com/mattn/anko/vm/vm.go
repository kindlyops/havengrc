package vm

import (
	"errors"
	"fmt"
	"reflect"

	"github.com/mattn/anko/ast"
	"github.com/mattn/anko/parser"
)

var (
	NilValue   = reflect.New(reflect.TypeOf((*interface{})(nil)).Elem()).Elem()
	NilType    = reflect.TypeOf(nil)
	TrueValue  = reflect.ValueOf(true)
	FalseValue = reflect.ValueOf(false)
)

// Error provides a convenient interface for handling runtime error.
// It can be Error interface with type cast which can call Pos().
type Error struct {
	Message string
	Pos     ast.Position
}

var (
	BreakError     = errors.New("Unexpected break statement")
	ContinueError  = errors.New("Unexpected continue statement")
	ReturnError    = errors.New("Unexpected return statement")
	InterruptError = errors.New("Execution interrupted")
)

// NewStringError makes error interface with message.
func NewStringError(pos ast.Pos, err string) error {
	if pos == nil {
		return &Error{Message: err, Pos: ast.Position{1, 1}}
	}
	return &Error{Message: err, Pos: pos.Position()}
}

// NewErrorf makes error interface with message.
func NewErrorf(pos ast.Pos, format string, args ...interface{}) error {
	return &Error{Message: fmt.Sprintf(format, args...), Pos: pos.Position()}
}

// NewError makes error interface with message.
// This doesn't overwrite last error.
func NewError(pos ast.Pos, err error) error {
	if err == nil {
		return nil
	}
	if err == BreakError || err == ContinueError || err == ReturnError {
		return err
	}
	if pe, ok := err.(*parser.Error); ok {
		return pe
	}
	if ee, ok := err.(*Error); ok {
		return ee
	}
	return &Error{Message: err.Error(), Pos: pos.Position()}
}

// Error returns the error message.
func (e *Error) Error() string {
	return e.Message
}

// Func is function interface to reflect functions internaly.
type Func func(args ...reflect.Value) (reflect.Value, error)

func (f Func) String() string {
	return fmt.Sprintf("[Func: %p]", f)
}

// Interrupts the execution of any running statements in the specified environment.
//
// Note that the execution is not instantly aborted: after a call to Interrupt,
// the current running statement will finish, but the next statement will not run,
// and instead will return a NilValue and an InterruptError.
func Interrupt(env *Env) {
	env.Lock()
	*(env.interrupt) = true
	env.Unlock()
}

func isNil(v reflect.Value) bool {
	if !v.IsValid() || v.Kind().String() == "unsafe.Pointer" {
		return true
	}
	if (v.Kind() == reflect.Interface || v.Kind() == reflect.Ptr) && v.IsNil() {
		return true
	}
	return false
}

func isNum(v reflect.Value) bool {
	switch v.Kind() {
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64, reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64, reflect.Uintptr, reflect.Float32, reflect.Float64:
		return true
	}
	return false
}

// equal returns true when lhsV and rhsV is same value.
func equal(lhsV, rhsV reflect.Value) bool {
	lhsIsNil, rhsIsNil := isNil(lhsV), isNil(rhsV)
	if lhsIsNil && rhsIsNil {
		return true
	}
	if (!lhsIsNil && rhsIsNil) || (lhsIsNil && !rhsIsNil) {
		return false
	}
	if lhsV.Kind() == reflect.Interface || lhsV.Kind() == reflect.Ptr {
		lhsV = lhsV.Elem()
	}
	if rhsV.Kind() == reflect.Interface || rhsV.Kind() == reflect.Ptr {
		rhsV = rhsV.Elem()
	}
	if !lhsV.IsValid() || !rhsV.IsValid() {
		return true
	}

	// Compare a string and a number.
	// This will attempt to convert the string to a number,
	// while leaving the other side alone. Code further
	// down takes care of converting ints and floats as needed.
	if isNum(lhsV) && rhsV.Kind() == reflect.String {
		rhsF, err := tryToFloat64(rhsV)
		if err != nil {
			// Couldn't convert RHS to a float, they can't be compared.
			return false
		}
		rhsV = reflect.ValueOf(rhsF)
	} else if lhsV.Kind() == reflect.String && isNum(rhsV) {
		// If the LHS is a string formatted as an int, try that before trying float
		lhsI, err := tryToInt64(lhsV)
		if err != nil {
			// if LHS is a float, e.g. "1.2", we need to set lhsV to a float64
			lhsF, err := tryToFloat64(lhsV)
			if err != nil {
				return false
			}
			lhsV = reflect.ValueOf(lhsF)
		} else {
			lhsV = reflect.ValueOf(lhsI)
		}
	}

	if isNum(lhsV) && isNum(rhsV) {
		if rhsV.Type().ConvertibleTo(lhsV.Type()) {
			rhsV = rhsV.Convert(lhsV.Type())
		}
	}

	// Try to compare bools to strings and numbers
	if lhsV.Kind() == reflect.Bool || rhsV.Kind() == reflect.Bool {
		lhsB, err := tryToBool(lhsV, false)
		if err != nil {
			return false
		}
		rhsB, err := tryToBool(rhsV, false)
		if err != nil {
			return false
		}
		return lhsB == rhsB
	}

	if lhsV.CanInterface() && rhsV.CanInterface() {
		return reflect.DeepEqual(lhsV.Interface(), rhsV.Interface())
	}
	return reflect.DeepEqual(lhsV, rhsV)
}
