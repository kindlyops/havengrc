module Page.Home exposing (Model, view)

import Html exposing (..)


type alias Model =
    { pendingTasks : List String
    }


view : model -> Html msg
view model =
    div []
        [ text "This is the HOME view" ]
