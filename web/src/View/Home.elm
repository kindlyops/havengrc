module View.Home exposing (view)

import Authentication
import Auth0
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Button as Button
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.List as List
import Material.Icon as Icon
import Material.Options as Options exposing (css, when, Property, onClick)
import Route exposing (Location(..), locFor)
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Auth0.UserProfile -> Html Msg
view model user =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            , Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            ]
            { header = mainHeader model
            , drawer = drawer model
            , tabs = ( [ text "Controls", text "Activities" ], [ Color.background (Color.color Color.Teal Color.S400) ] )
            , main = [ viewBody model user ]
            }


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


mainHeader : Model -> List (Html Msg)
mainHeader model =
    []


drawHeader : Model -> Html Msg
drawHeader model =
    let
        ( name, avatar ) =
            (case Authentication.tryGetUserProfile model.authModel of
                Nothing ->
                    ( "unknown", "unknown" )

                Just user ->
                    ( user.firstName, "" )
             -- TODO figure out where to get avatar
            )
    in
        (header
            []
            [ List.avatarImage avatar [ Options.css "margin-right" "16px" ]
            , text name
            ]
        )


drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.title [] [ drawHeader model ]
    , Layout.navigation
        [ Options.css "flex-grow" "1" ]
        (List.map (drawerMenuItem model) menuItems)
    ]


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Home }
    , { text = "Users", iconName = "group", route = Just Users }
    , { text = "Last Activity", iconName = "alarm", route = Nothing }
    , { text = "Timesheets", iconName = "event", route = Nothing }
    , { text = "Reports", iconName = "list", route = Nothing }
    , { text = "Organizations", iconName = "store", route = Just Organizations }
    , { text = "Projects", iconName = "view_list", route = Just Projects }
    ]


drawerMenuItem : Model -> MenuItem -> Html Msg
drawerMenuItem model menuItem =
    Layout.link
        [ Options.onClick <| NavigateTo <| menuItem.route
        , (if model.route == menuItem.route then
            Color.text <| Color.primaryContrast
           else
            Color.text <| Color.primaryDark
          )
        , Options.css "font-weight" "500"
        , Options.css "cursor" "pointer"
          -- http://outlinenone.com/ TODO: tl;dr don't do this (from Elm Daily Drip example)
          -- should be using ":focus { outline: 0 }" but can't with inline styles so hack
        , Options.css "outline" "none"
        ]
        [ Icon.view menuItem.iconName
            [ Options.css "margin-right" "32px"
            ]
        , text menuItem.text
        ]


viewBody : Model -> Auth0.UserProfile -> Html Msg
viewBody model user =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ Button.render Mdl
            [ 0 ]
            model.mdl
            [ Options.onClick
                (Msg.AuthenticationMsg Authentication.LogOut)
            , Options.css "margin" "0 24px"
            ]
            [ text "Logout" ]
        , a [ href "http://localhost:8080/auth/realms/havendev/account/" ] [ text "Edit user profile" ]
        , (case model.selectedTab of
            0 ->
                ul []
                    (List.map (\r -> li [] [ text r.description ]) model.regulations)

            1 ->
                text "Second tab content"

            _ ->
                text "We don't have this tab"
          )
        ]
