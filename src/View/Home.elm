module View.Home exposing (view)

import Authentication
import Auth0
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Button as Button
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Icon as Icon
import Material.Options as Options exposing (css, when, Property)
import Route exposing (Location(..))
import Model exposing (Model)
import Msg exposing (..)
import Navigation
import Route exposing (locFor)


view : Model -> Auth0.UserProfile -> Html Msg
view model user =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            ]
            { header = header model
            , drawer = drawer model
            , tabs = ( [ text "Controls", text "Activities" ], [ Color.background (Color.color Color.Teal Color.S400) ] )
            , main = [ viewBody model user ]
            }


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


header : Model -> List (Html Msg)
header model =
    [ h1 [ style [ ( "padding", "2rem" ) ] ] [ text "ComplianceOps" ] ]


drawer : Model -> List (Html Msg)
drawer model =
    [ Layout.title []
        [ text "Compliance Ops" ]
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
        [ Layout.onClick <| NavigateTo <| menuItem.route
        , -- (if model.route == menuItem.route then
          -- TODO fix this chunk of code up to only highlight the current route
          -- Color.text <| Color.accent
          -- else
          Color.text <| Color.primaryDark
          --)
          -- 0.18 upgrade `when` |> when (model.route == menuItem.route)
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
        [ div []
            [ p [] [ img [ src user.picture ] [] ]
            , p [] [ text ("Hello, " ++ user.name ++ "!") ]
            ]
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.onClick
                (Msg.AuthenticationMsg Authentication.LogOut)
            , Options.css "margin" "0 24px"
            ]
            [ text "Logout" ]
        , text "hello"
        ]
