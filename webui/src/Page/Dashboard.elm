module Page.Dashboard exposing (Model, Msg(..), init, update, view)

import Html exposing (Html, br, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)
import Ports
import Process
import Task


type Msg
    = ShowError String
    | HideError


type alias Model =
    { data : List Float
    , errorModel : ErrorData
    }


init : Model
init =
    { data = [ 1, 1, 2, 3, 5, 8, 13 ]
    , errorModel = errorInit
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowError errMsg ->
            ( { model | errorModel = setErrorMessage model.errorModel errMsg }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        HideError ->
            ( { model | errorModel = errorInit }, Cmd.none )


view : Model -> Html Msg
view model =
    div
        []
        [ div [] [ text "This used to be the Centroid" ]
        , br [] []
        , button
            [ class "btn btn-secondary"
            , onClick (ShowError "this is an error message")
            ]
            [ text "Show Error" ]
        , viewError model.errorModel
        ]
