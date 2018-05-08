module Page.Activity exposing (Model, view)

import Html exposing (..)


type alias Model =
    { count : Int
    }


view : Model -> Html msg
view model =
    div []
        [ text "This is the activity view" ]
