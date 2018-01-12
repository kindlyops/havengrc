module Page.Reports exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onWithOptions, on)
import Misc exposing (showDebugData)


type alias Model =
    { report : String
    }


type Msg
    = SubmitForm


view : Model -> Html Msg
view model =
    div []
        [ text "This is the reports view" ]
