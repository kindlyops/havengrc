module Page.Activity exposing (view)

import Html exposing (Html, div, text)


view : Html msg
view =
    div []
        [ div []
            [ text "What is Risk Management?" ]
        , div [] [ text "This used to be the line chart, rebuild" ]
        ]
