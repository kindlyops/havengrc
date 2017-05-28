module View.Home exposing (view)

import Authentication
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Keycloak
import Route exposing (Location(..), locFor)
import Types exposing (Model, Msg)
import WebComponents.App exposing (appDrawer, appDrawerLayout, appToolbar, appHeader, appHeaderLayout, ironSelector)


header : Model -> Html Msg
header model =
    appHeaderLayout
        [ attribute "has-scrolling-region" "" ]
        [ appHeader
            [ attribute "reveals" ""
            ]
            [ appToolbar
                -- top toolbar
                []
                [ node "paper-icon-button"
                    [ attribute "icon" "menu"
                    , attribute "drawer-toggle" ""
                      -- TODO add "hidden$=" attribute to hide when drawer is open
                    ]
                    []
                , div
                    [ attribute "main-title" "" ]
                    []
                ]
            , appToolbar
                -- bottom toolbar
                []
                []
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
                [ appHeader [ attribute "fixed" "", attribute "slot" "header" ]
                    [ appToolbar [] []
                    , appToolbar [ classList [ ( "title-toolbar", True ), ( "nav-title-toolbar", True ) ] ]
                        [ div [ class "title" ] [ text "Haven GRC" ] ]
                    ]
                , ironSelector
                    [ class "nav-menu"
                    , attribute "attr-for-selected" "name"
                    ]
                    [ a [ href "http://elm-lang.org/" ] [ text "item 1" ]
                    , a [ href "http://elm-lang.org/" ] [ text "item 2" ]
                    ]
                ]
            ]
        , header model
        , body model
        ]


body : Model -> Html Msg
body model =
    div
        [ style
            [ ( "min-height", "2000px" )
            ]
        ]
        [ text "This is the logged in view"
        , div
            []
            [ node "paper-button"
                -- Add this attribute
                [ attribute "raised" "raised"
                , onClick (Types.AuthenticationMsg Authentication.LogOut)
                ]
                [ text "Logout" ]
            ]
        ]



-- view : Model -> Keycloak.UserProfile -> Html Msg
-- view model user =
--     Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
--         Layout.render Types.Mdl
--             model.mdl
--             [ Layout.fixedHeader
--             , Layout.fixedDrawer
--             , Layout.selectedTab model.selectedTab
--             , Layout.onSelectTab Types.SelectTab
--             ]
--             { header = mainHeader model
--             , drawer = drawer model
--             , tabs = ( [ text "Controls", text "Activities" ], [ Color.background (Color.color Color.Teal Color.S400) ] )
--             , main = [ viewBody model user ]
--             }
--
--
-- type alias MenuItem =
--     { text : String
--     , iconName : String
--     , route : Maybe Route.Location
--     }
--
--
-- mainHeader : Model -> List (Html Msg)
-- mainHeader model =
--     []
--
--
-- drawHeader : Model -> Html Msg
-- drawHeader model =
--     let
--         ( name, avatar ) =
--             (case Authentication.tryGetUserProfile model.authModel of
--                 Nothing ->
--                     ( "unknown", "unknown" )
--
--                 Just user ->
--                     ( user.firstName, "" )
--              -- TODO figure out where to get avatar
--             )
--     in
--         (header
--             []
--             [ List.avatarImage avatar [ Options.css "margin-right" "16px" ]
--             , text name
--             ]
--         )
--
--
-- drawer : Model -> List (Html Msg)
-- drawer model =
--     [ Layout.title [] [ drawHeader model ]
--     , Layout.navigation
--         [ Options.css "flex-grow" "1" ]
--         (List.map (drawerMenuItem model) menuItems)
--     ]
--
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
-- viewBody : Model -> Keycloak.UserProfile -> Html Msg
-- viewBody model user =
--     div
--         [ style [ ( "padding", "2rem" ) ] ]
--         [ Button.render Types.Mdl
--             [ 0 ]
--             model.mdl
--             [ Options.onClick
--                 (Types.AuthenticationMsg Authentication.LogOut)
--             , Options.css "margin" "0 24px"
--             ]
--             [ text "Logout" ]
--         , a [ href "http://localhost:8080/auth/realms/havendev/account/" ] [ text "Edit user profile" ]
--         , (case model.selectedTab of
--             0 ->
--                 ul []
--                     (List.map (\r -> li [] [ text r.description ]) model.regulations)
--
--             1 ->
--                 text "Second tab content"
--
--             _ ->
--                 text "We don't have this tab"
--           )
--         ]
