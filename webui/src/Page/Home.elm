module Page.Home exposing (view)

import Authentication
import Browser
import Html exposing (Html, a, button, div, footer, h1, h2, h3, img, nav, p, span, text)
import Html.Attributes exposing (alt, attribute, class, height, href, id, src, title, type_, width)
import Html.Events exposing (onClick)


view : Html Authentication.Msg
view =
    div [ class "" ]
        [ nav [ class "navbar navbar-expand-sm" ]
            [ img [ class "img-fluid", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
                []
            , button [ class "navbar-toggler", type_ "button", attribute "data-toggle" "collapse", attribute "data-target" "#NavbarLogin" ]
                [ span [ class "navbar-toggler-icon" ] [] ]
            , div [ class "collapse navbar-collapse", id "NavbarLogin" ]
                [ div [ class "ml-auto my-2 my-lg-0 d-flex justify-content-end" ]
                    [ button
                        [ class "btn btn-outline-default my-2 my-sm-0"
                        , onClick Authentication.LoginMsg
                        ]
                        [ text "Login" ]
                    ]
                ]
            ]
        , div [ class "" ]
            [ div [ class "jumbotron text-center" ]
                [ div [ class "container" ]
                    [ h3 [ class "login-header" ]
                        [ text "cyber risk governance for real people"
                        ]
                    , p [ class "homeparagraph" ]
                        [ text "Haven GRC is the only Governance, Risk, and Compliance solution build on a foundation of empathy for humans. Security culture is beliefs and assumptions that drive decisions and behavior. We call these mental models." ]
                    , p [ class "homeparagraph" ]
                        [ text "Take this free 10 question security culture survey to learn which model your team currently uses for security and see how that fits with where your team needs to go this year." ]
                    , button
                        [ class "btn btn-primary btn-block mx-auto login-btn"
                        , onClick Authentication.StartSurveyMsg
                        ]
                        [ text "Take the survey" ]
                    ]
                ]
            ]
        , div [ class "py-5 bg-light text-center " ]
            [ div [ class "" ]
                [ div [ class "pb-5" ]
                    [ img [ class "img-lg d-none d-md-inline", id "Wireframe", width 552, height 375, alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/wireframe-large.png" ]
                        []
                    , img [ class "img-sm d-md-none", id "Wireframe", width 329, height 229, alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/wireframe@2x.png" ]
                        []
                    ]
                , div [ class "row mx-5" ]
                    [ div [ class "col-sm-12 col-lg-4 px-4" ]
                        [ img [ alt "Clipboard check list", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/record_assets.png" ]
                            []
                        , h3 [ class "py-3" ]
                            [ text "SECURITY METRICS" ]
                        , p [ class "homeparagraph" ]
                            [ text "Each security culture has strengths and weaknesses. Measure your team's security culture along with metrics that measure the performance of your cyber security program. Understanding the different security models will help your team appreciate the benefits of learning new approaches as you work to take on calculated risk for innovation or improve discipline to meet regulatory compliance goals." ]
                        ]
                    , div [ class "col-sm-12 col-lg-4 px-4" ]
                        [ img [ alt "icon with exclaimation point warning symbol alert", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/track_risk.png" ]
                            []
                        , h3 [ class "py-3" ]
                            [ text "RISK REGISTER" ]
                        , p [ class "homeparagraph" ]
                            [ text "A risk register that actually gets used! When reviewing applications, services, and vendors for regulatory compliance, you inevitably find issues that need to be addressed. We help you quantify the relative importance and risk of each issue to the overall business so that everyone can see what needs priority attention. You can then easily track those issues through all stages of remediation and provide at-a-glance status for your overall risk profile to all stakeholders." ]
                        ]
                    , div [ class "col-sm-12 col-lg-4 px-4" ]
                        [ img [ alt "Award badge ribbon", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/give_credit.png" ]
                            []
                        , h3 [ class "py-3" ]
                            [ text "GIVE CREDIT" ]
                        , p [ class "homeparagraph" ]
                            [ text "Compliance + risk work can seem never-ending and thankless. Resilience and safety comes from humans, and giving people credit for their work means they are more engaged and better at identifying and mitigating risks as they emerge. People get excited about how they are helping to improve the company risk profile rather than dragging their feet about the rules. Empower your team to innovate with confidence!" ]
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
                            [ text "KINDLY OPS " ]
                        , a
                            [ class "text-white underline"
                            , href "/privacy"
                            , title "Privacy Policy "
                            ]
                            [ text "Privacy Policy " ]
                        , a
                            [ class "text-white underline"
                            , href "/cookie"
                            , title "Cookie Policy "
                            ]
                            [ text "Cookie Policy" ]
                        , a
                            [ class "text-white underline"
                            , href "/terms"
                            , title "Terms of Service "
                            ]
                            [ text "Terms of Service " ]
                        ]
                    ]
                ]
            ]
        ]
