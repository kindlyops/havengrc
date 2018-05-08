module Page.Login exposing (Model, view)

import Html exposing (..)


type alias Model =
    { email : String
    , password : String
    }


view : Model -> Html msg
view model =
    div []
        [ text "This is the LOGIN view" ]
