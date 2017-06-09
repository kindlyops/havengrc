module View.Home exposing (view)

import Authentication
import List exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions)
import Keycloak
import Route exposing (Location(..), locFor)
import String exposing (toLower)
import Types exposing (Model, Msg)
import WebComponents.App exposing (appDrawer, appDrawerLayout, appToolbar, appHeader, appHeaderLayout, ironSelector)


header : Model -> Html Msg
header model =
    appHeaderLayout
        []
        [ appHeader
            [ attribute "fixed" ""
            , attribute "effects" "waterfall"
            ]
            [ appToolbar
                [ classList [ ( "title-toolbar", True ), ( "nav-title-toolbar", True ) ] ]
                [ node "paper-icon-button"
                    [ attribute "icon" "menu"
                    , attribute "drawer-toggle" ""

                    -- TODO fix main toolbar scrolling offscreen for dashboard with long content
                    ]
                    []
                ]
            ]
        ]


view : Model -> Keycloak.UserProfile -> Html Msg
view model user =
    appDrawerLayout
        []
        [ appDrawer
            [ attribute "slot" "drawer"
            , attribute "id" "drawer"
            ]
            [ appHeaderLayout
                [ attribute "has-scrolling-region" "" ]
                [ appHeader
                    [ attribute "fixed" ""
                    , attribute "slot" "header"
                    , class "main-header"
                    ]
                    [ appToolbar []
                        [ div
                            [ class "title" ]
                            [ text "Haven GRC" ]
                        ]
                    , appToolbar
                        [ attribute "id" "profiletoolbar" ]
                        [ node "ash-avatar" [ attribute "name" user.firstName ] []
                        , text user.username
                        ]
                    ]
                , ironSelector
                    [ class "nav-menu"
                    , attribute "attr-for-selected" "name"
                    , attribute "selected" (selectedItem model)
                    ]
                    (List.map drawerMenuItem menuItems)

                -- TODO center in drawer, move to bottom
                , div
                    [ class "layout vertical fit"
                    ]
                    [ div [ class "layout flex" ] []
                    , node "iron-image"
                        [ attribute "src" "/img/logo.png"
                        , attribute "id" "drawerlogo"
                        ]
                        []
                    ]
                ]
            ]
        , header model
        , body model
        ]


selectedItem : Model -> String
selectedItem model =
    -- TODO refactor / clean up
    case model.route of
        Nothing ->
            "dashboard"

        Just Home ->
            "dashboard"

        Just Reports ->
            "reports"

        Just Regulations ->
            "regulations"

        Just _ ->
            ""


body : Model -> Html Msg
body model =
    case model.route of
        Nothing ->
            dashboardBody model

        Just Home ->
            dashboardBody model

        Just Reports ->
            reportsBody model

        Just Regulations ->
            regulationsBody model

        Just _ ->
            notFoundBody model


dashboardBody : Model -> Html Msg
dashboardBody model =
    div
        [ style
            [ ( "min-height", "2000px" )
            ]
        ]
        [ text "This is the dashboard view"
        , div
            []
            [ a [ href "/auth/realms/havendev/account/" ]
                [ node "paper-button"
                    [ attribute "raised" "raised" ]
                    [ text "Edit account" ]
                ]
            ]
        , div
            []
            [ node "paper-button"
                [ attribute "raised" "raised"
                , onClick (Types.AuthenticationMsg Authentication.LogOut)
                ]
                [ text "Logout" ]
            ]
        ]


reportsBody : Model -> Html Msg
reportsBody model =
    div [] [ text "This is the reports view" ]


regulationsBody : Model -> Html Msg
regulationsBody model =
    div [] [ text "This is the regulations view" ]


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "icons:dashboard", route = Just Home }
    , { text = "Activity", iconName = "icons:history", route = Nothing }
    , { text = "Reports", iconName = "av:library-books", route = Just Reports }
    , { text = "Regulations", iconName = "icons:gavel", route = Just Regulations }
    ]


drawerMenuItem : MenuItem -> Html Msg
drawerMenuItem menuItem =
    div
        [ attribute "name" (toLower menuItem.text)
        , onClick <| Types.NavigateTo <| menuItem.route
        ]
        [ node "iron-icon" [ attribute "icon" menuItem.iconName ] []
        , text (" " ++ menuItem.text)
        ]
