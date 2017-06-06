module View.Home exposing (view)

import Authentication
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions)
import Keycloak
import Route exposing (Location(..), locFor)
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
                    -- TODO refactor rendering of drawer items
                    [ div
                        [ attribute "name" "dashboard"
                        , onClick <| Types.NavigateTo <| Just Home
                        ]
                        [ node "iron-icon" [ attribute "icon" "icons:dashboard" ] []
                        , text (" " ++ "Dashboard")
                        ]
                    , div
                        [ attribute "name" "reports"
                        , onClick <| Types.NavigateTo <| Just Projects
                        ]
                        [ node "iron-icon" [ attribute "icon" "av:library-books" ] []
                        , text (" " ++ "Reports")
                        ]
                    ]
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

        Just Projects ->
            "reports"

        Just _ ->
            "reports"


body : Model -> Html Msg
body model =
    case model.route of
        Nothing ->
            dashboardBody model

        Just Home ->
            dashboardBody model

        Just Projects ->
            reportsBody model

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


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]



--
-- type alias MenuItem =
--     { text : String
--     , iconName : String
--     , route : Maybe Route.Location
--     }
--
-- menuItems : List MenuItem
-- menuItems =
--     [ { text = "Dashboard", iconName = "dashboard", route = Just Home }
--     , { text = "Users", iconName = "group", route = Just Users }
--     , { text = "Last Activity", iconName = "alarm", route = Nothing }
--     , { text = "Timesheets", iconName = "event", route = Nothing }
--     , { text = "Reports", iconName = "list", route = Nothing }
--     , { text = "Organizations", iconName = "store", route = Just Organizations }
--     , { text = "Projects", iconName = "view_list", route = Just Projects }
--     ]
--
--
-- drawerMenuItem : Model -> MenuItem -> Html Msg
-- drawerMenuItem model menuItem =
--     Layout.link
--         [ Options.onClick <| Types.NavigateTo <| menuItem.route
--         , (if model.route == menuItem.route then
--             Color.text <| Color.primaryContrast
--            else
--             Color.text <| Color.primaryDark
--           )
--         , Options.css "font-weight" "500"
--         , Options.css "cursor" "pointer"
--
--         -- http://outlinenone.com/ TODO: tl;dr don't do this (from Elm Daily Drip example)
--         -- should be using ":focus { outline: 0 }" but can't with inline styles so hack
--         , Options.css "outline" "none"
--         ]
--         [ Icon.view menuItem.iconName
--             [ Options.css "margin-right" "32px"
--             ]
--         , text menuItem.text
--         ]
--
--
