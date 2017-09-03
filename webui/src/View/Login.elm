module View.Login exposing (view)

import Authentication
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg)


view : Model -> Html Msg
view model =
    div []
        [ div [ class "jumbotron" ]
            [ div [ class "container-fluid text-center" ]
                [ img [ alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo.png" ]
                    []
                , h1 [ class "text-uppercase" ]
                    [ span [ class "text-success" ]
                        [ text "Compliance" ]
                    , span [ class "text-primary" ]
                        [ text " + " ]
                    , span [ class "text-success" ]
                        [ text "Risk " ]
                    , text "Dashboard"
                    ]
                , p []
                    [ a
                        [ class "btn btn-primary btn-lg"
                        , href ""
                        , attribute "role" "button"
                        , onClick (Types.AuthenticationMsg Authentication.ShowLogIn)
                        ]
                        [ text "LOGIN" ]
                    ]
                ]
            ]
        , div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col-md-12 text-center", id "wireframe-container" ]
                    [ img [ alt "Wireframe graphic of compliance and risk dashboard Haven GRC", class "img-responsive center-block hidden-sm hidden-xs", attribute "data-rjs" "2", id "wireframe", src "/img/wireframe-large.png" ]
                        []
                    , img [ alt "Wireframe graphic of compliance and risk dashboard Haven GRC", class "img-responsive center-block hidden-lg hidden-md", attribute "data-rjs" "2", id "wireframe", src "/img/wireframe.png" ]
                        []
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-md-4 text-center" ]
                    [ img [ alt "Clipboard check list", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/record_assets.png" ]
                        []
                    , h2 [ class "text-uppercase" ]
                        [ text "Record Assets" ]
                    , p []
                        [ text "You already have well-defined controls, but it’s nearly impossible to keep up with the speed at which applications and services are purchased and provisioned in the cloud.  Reduce the Shadow IT burden by allowing teams to identify and report new cloud services regularly. Everyone can easily see which cloud services are approved, which ones need review, which ones are being retired, as well as what type of data is stored and processed." ]
                    ]
                , div [ class "col-md-4 text-center" ]
                    [ img [ alt "icon with exclaimation point warning symbol alert", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/track_risk.png" ]
                        []
                    , h2 [ class "text-uppercase" ]
                        [ text "Track Risk" ]
                    , p []
                        [ text "When reviewing applications, services, and vendors for regulatory compliance, you inevitably find issues that need to be addressed. We help you quantify the relative importance and risk of each issue to the overall business so that everyone can see what needs priority attention. You can then easily track those issues through all stages of remediation and provide at-a-glance status for your overall risk profile to all stakeholders." ]
                    ]
                , div [ class "col-md-4 text-center" ]
                    [ img [ alt "Award badge ribbon", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/give_credit.png" ]
                        []
                    , h2 [ class "text-uppercase" ]
                        [ text "Give Credit" ]
                    , p []
                        [ text "Compliance + risk work can seem never-ending and thankless. Resilience and safety comes from humans, and giving people credit for their work results in higher engagement and improved acuity for identifying and mitigating risks as they emerge. People get excited about how they are helping to improve the company risk profile rather than dragging their feet about the rules. Empower your team to innovate with confidence!" ]
                    ]
                ]
            , div [ class "row" ]
                [ div [ class "col-md-12 text-center", id "footer-lines-container" ]
                    [ img [ alt "Wireframe graphic of compliance and risk dashboard Haven GRC", attribute "data-rjs" "2", id "footer-lines", src "/img/footer_lines.png" ]
                        []
                    ]
                ]
            ]
        , footer [ class "navbar-bottom" ]
            [ div [ class "container" ]
                [ p []
                    [ text "© 2017 "
                    , a [ href "https://kindlyops.com", title "Kindly Ops Website" ]
                        [ text "KINDLY OPS" ]
                    ]
                ]
            ]
        ]
