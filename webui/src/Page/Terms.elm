module Page.Terms exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown exposing (..)


view : Html msg
view =
    div [ class "" ]
        [ div [ class "" ]
            [ div [ class "jumbotron text-center" ]
                [ div [ class "container" ]
                    [ img [ class "img-fluid mb-4", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
                        []
                    , h1 []
                        [ text "Haven GRC Software Service Terms" ]
                    ]
                ]
            ]
        , div [ class "py-5 bg-light" ]
            [ div [ class "" ]
                [ div [ class "pb-5" ] 
                    [ 
                    div [ class "row px-5" ]
                    [ div [ class "col-12 px-12" ]
                        [ Markdown.toHtml [class "terms"] """ 
                        **Haven GRC Software Service Terms**

**first edition, second update**

**Provider** and **Customer** agree:

1. _Software_.

(a) The **Software** is Haven GRC, for tamper proof evidence storage, security culture metrics, and risk dashboard.

(b) The **Website** is at https://havengrc.com/.

(c) The **Account Dashboard** is at https://account.havengrc.com/.

(d) The **Documentation** is at https://docs.havengrc.com/.
                        """ ]
        , div [ class "text-center bg-light", id "footer-container" ]
            [ img [ class "", id "footer-image", alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/footer_lines@2x.png" ]
                []
            , footer [ class "bg-primary py-4" ]
                [ div [ class "text-white" ]
                    [ span []
                        [ text "© 2018 "
                        , a [ class "text-white underline", href "https://kindlyops.com", title "Kindly Ops Website" ]
                            [ text "KINDLY OPS" ]
                        ]
                    ]
                ]
            ]
        ]