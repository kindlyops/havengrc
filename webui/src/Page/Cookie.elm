module Page.Cookie exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


viewCookie : Html msg
viewCookie =
    div []
        [ a
            -- TODO: make this loaded from the database rather than hardcoded to kindlyops
            [ href "https://www.iubenda.com/privacy-policy/52382945/cookie-policy"
            , class "iubenda-white no-brand iubenda-embed iub-no-markup iub-body-embed"
            ]
            [ text "Cookie Policy" ]
        ]


view : Html msg
view =
    div [ class "" ]
        [ div [ class "" ]
            [ div [ class "jumbotron text-center" ]
                [ div [ class "container" ]
                    [ img [ class "img-fluid mb-4", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
                        []
                    , h1 []
                        [ text "Haven GRC Software Service Cookie Policy" ]
                    ]
                ]
            ]
        , div [ class "py-5 bg-light" ]
            [ div [ class "" ]
                [ div [ class "pb-5" ]
                    [ div [ class "row px-5" ]
                        [ div [ class "col-12 px-12" ]
                            [ viewCookie ]
                        ]
                    ]
                ]
            ]
        , div [ class "text-center bg-light", id "footer-container" ]
            [ img [ class "", id "footer-image", alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/footer_lines@2x.png" ]
                []
            , footer [ class "bg-primary py-4" ]
                [ div [ class "text-white" ]
                    [ span []
                        [ text "© 2019 "
                        , a [ class "text-white underline", href "https://kindlyops.com", title "Kindly Ops Website" ]
                            [ text "KINDLY OPS" ]
                        ]
                    ]
                ]
            ]
        ]
