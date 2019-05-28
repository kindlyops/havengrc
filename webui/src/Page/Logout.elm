module Page.Logout exposing (view)

import Html exposing (..)


view : Html msg
view =
    div []
        [ div [] [ text "You have been logged out. Close your browser if you are using a shared computer." ]
        ]
