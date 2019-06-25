module Data.OnBoarding exposing (Model, Msg, State, get, init, set, update)

import Authentication
import Http
import Json.Decode as Decode exposing (Decoder, bool, field, map2, string)
import Json.Encode as Encode
import Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)
import Utils exposing (getHTTPErrorMessage)


type alias State =
    { status : String
    , downloaded_report : Bool
    }


type Msg
    = HandleStateResult (Result Http.Error State)


type alias Model =
    { currentState : State
    }


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    ( { currentState = { status = "", downloaded_report = False }
      }
    , Cmd.batch (initialCommands authModel)
    )


initialCommands : Authentication.Model -> List (Cmd Msg)
initialCommands authModel =
    if Authentication.isLoggedIn authModel then
        [ get ]

    else
        []


decode : Decoder State
decode =
    map2 State
        (field "status" string)
        (field "downloaded_report" bool)


url : String
url =
    "/api/onboarding"


get : Cmd Msg
get =
    Http.get
        { url = url
        , expect = Http.expectJson HandleStateResult decode
        }


encode : String -> Bool -> Encode.Value
encode status downloaded_report =
    Encode.object
        [ ( "status", Encode.string status )
        , ( "downloaded_report", Encode.bool downloaded_report )
        ]


set : String -> Bool -> Cmd Msg
set status downloaded_report =
    Http.post
        { url = url
        , body = Http.jsonBody (encode status downloaded_report)
        , expect = Http.expectJson HandleStateResult decode
        }


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        HandleStateResult (Ok state) ->
            ( { model | currentState = state }
            , Cmd.none
            )

        HandleStateResult (Err error) ->
            ( { model | currentState = { status = getHTTPErrorMessage error, downloaded_report = False } }
            , Cmd.none
            )
