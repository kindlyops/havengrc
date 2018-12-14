module Page.Activity exposing (view)

import Date
import Html exposing (Html, div, text)
import Views.LineChart as LineChart


view : Html msg
view =
    let
        data =
            [ ( Date.fromTime 1448928000000, 2 )
            , ( Date.fromTime 1451606400000, 2 )
            , ( Date.fromTime 1454284800000, 1 )
            , ( Date.fromTime 1456790400000, 1 )
            ]
    in
    div []
        [ div []
            [ text "What is Risk Management?" ]
        , LineChart.view data
        ]
