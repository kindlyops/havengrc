module Page.Reports exposing (view)

import Html exposing (Html, a, div, li, ol, text)
import Html.Attributes exposing (href, target)


view : Html msg
view =
    div []
        [ div []
            [ text "This is the reports view"
            , ol []
                [ li []
                    [ a [ href "../js/pdf/web/viewer.html?file=haven-booth-concepts.pdf", target "_blank" ]
                        [ text "Report" ]
                    ]
                , li []
                    [ a [ href "../js/pdf/web/viewer.html", target "_blank" ]
                        [ text "Same report" ]
                    ]
                ]
            ]
        ]
