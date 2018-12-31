port module Main exposing (emit, main)

import Json.Encode exposing (Value)
import Test.Runner.Node exposing (run)
import Tests


main : Test.Runner.Node.TestProgram
main =
    run emit Tests.all


port emit : ( String, Value ) -> Cmd msg
