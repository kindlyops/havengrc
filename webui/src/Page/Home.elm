module Page.Home exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Authentication


--view : Html Msg
--view : Html msg


view =
    div [ class "" ]
        [ div [ class "" ]
            [ div [ class "jumbotron text-center" ]
                [ div [ class "container" ]
                    [ img [ class "img-fluid mb-4", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
                        []
                    , h1 [ class "login-header" ]
                        [ span [ class "text-success" ]
                            [ text "Compliance" ]
                        , span [ class "text-primary" ]
                            [ text " & " ]
                        , span [ class "text-success" ]
                            [ text "Risk " ]
                        , text "Dashboard"
                        ]
                    , button
                        [ class "btn btn-primary mt-4"
                        , onClick (Authentication.ShowLogIn)
                        ]
                        [ text "Login" ]
                    ]
                ]
            ]
        , div [ class "py-5 bg-light text-center " ]
            [ div [ class "" ]
                [ div [ class "" ]
                    [ img [ class "img-lg", width 552, height 375, alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/wireframe-large.png" ]
                        []
                    ]
                , div [ class "row" ]
                    [ div [ class "col-4" ]
                        [ img [ alt "Clipboard check list", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/record_assets.png" ]
                            []
                        , h2 []
                            [ text "Record Assets" ]
                        , p []
                            [ text "You already have well-defined controls, but it’s nearly impossible to keep up with the speed at which applications and services are purchased and provisioned in the cloud.  Reduce the Shadow IT burden by allowing teams to identify and report new cloud services regularly. Everyone can easily see which cloud services are approved, which ones need review, which ones are being retired, as well as what type of data is stored and processed." ]
                        ]
                    , div [ class "col-4" ]
                        [ img [ alt "icon with exclaimation point warning symbol alert", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/track_risk.png" ]
                            []
                        , h2 []
                            [ text "Track Risk" ]
                        , p []
                            [ text "When reviewing applications, services, and vendors for regulatory compliance, you inevitably find issues that need to be addressed. We help you quantify the relative importance and risk of each issue to the overall business so that everyone can see what needs priority attention. You can then easily track those issues through all stages of remediation and provide at-a-glance status for your overall risk profile to all stakeholders." ]
                        ]
                    , div [ class "col-4" ]
                        [ img [ alt "Award badge ribbon", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/give_credit.png" ]
                            []
                        , h2 []
                            [ text "Give Credit" ]
                        , p []
                            [ text "Compliance + risk work can seem never-ending and thankless. Resilience and safety comes from humans, and giving people credit for their work results in higher engagement and improved acuity for identifying and mitigating risks as they emerge. People get excited about how they are helping to improve the company risk profile rather than dragging their feet about the rules. Empower your team to innovate with confidence!" ]
                        ]
                    ]
                ]
            ]
        , div [ class "text-center bg-light", id "footer-container" ]
            [ img [ class "", id "footer-image", alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/footer_lines@2x.png" ]
                []
            , footer [ class "bg-primary py-4" ]
                [ div [ class "" ]
                    [ span []
                        [ text "© 2018 "
                        , a [ href "https://kindlyops.com", title "Kindly Ops Website" ]
                            [ text "KINDLY OPS" ]
                        ]
                    ]
                ]
            ]
        ]