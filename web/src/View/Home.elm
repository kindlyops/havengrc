module View.Home exposing (view)

import Authentication
import List exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions, on)
import Json.Decode as Json
import Keycloak
import Route exposing (Location(..), locFor)
import String exposing (toLower)
import Types exposing (Model, Msg)
import WebComponents.App exposing (appDrawer, appDrawerLayout, appToolbar, appHeader, appHeaderLayout, ironSelector)
import WebComponents.Paper as Paper


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
                [ Paper.iconButton
                    [ attribute "icon" "menu"
                    , attribute "drawer-toggle" ""
                    ]
                    []
                , div [ attribute "main-title" "" ] [ text "Haven GRC" ]
                , Paper.iconButton [ attribute "icon" "search" ] []
                ]
            ]
        ]


view : Model -> Keycloak.UserProfile -> Html Msg
view model user =
    appDrawerLayout
        []
        [ appDrawer
            [ attribute "slot" "drawer"
            , id "drawer"
            ]
            [ appHeaderLayout
                [ attribute "has-scrolling-region" "" ]
                [ appHeader
                    [ attribute "fixed" ""
                    , attribute "slot" "header"
                    , class "main-header"
                    ]
                    [ appToolbar [] []
                    , appToolbar
                        [ id "profiletoolbar" ]
                        [ text user.username ]
                    ]
                , ironSelector
                    [ class "nav-menu"
                    , attribute "attr-for-selected" "name"
                    , attribute "selected" (selectedItem model)
                    ]
                    (List.map drawerMenuItem menuItems)
                , img
                    [ attribute "src" "/img/logo.png"
                    , id "drawerlogo"
                    ]
                    []
                ]
            ]
        , header model
        , body model
        ]


selectedItem : Model -> String
selectedItem model =
    let
        item =
            List.head (List.filter (\m -> m.route == model.route) menuItems)
    in
        case item of
            Nothing ->
                "dashboard"

            Just item ->
                String.toLower item.text


body : Model -> Html Msg
body model =
    div [ id "content" ]
        [ case model.route of
            Nothing ->
                dashboardBody model

            Just Home ->
                dashboardBody model

            Just Reports ->
                reportsBody model

            Just Regulations ->
                regulationsBody model

            Just Activity ->
                activityBody model

            Just _ ->
                notFoundBody model
        ]


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
                    [ attribute "raised" "" ]
                    [ text "Edit account" ]
                ]
            ]
        , div
            []
            [ node "paper-button"
                [ attribute "raised" ""
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
    div []
        [ text "This is the regulations view"
        , ul []
            (List.map (\l -> li [] [ text l.description ]) model.regulations)
        , regulationsForm model
        ]


onValueChanged : (String -> msg) -> Html.Attribute msg
onValueChanged tagger =
    on "value-changed" (Json.map tagger Html.Events.targetValue)


regulationsForm : Model -> Html Msg
regulationsForm model =
    div
        []
        -- TODO wire up a handler to save the data from these inputs into
        -- our model when they change
        [ Paper.input
            [ attribute "label" "URI"
            , onValueChanged Types.SetRegulationURIInput
            , value model.newRegulation.uri
            ]
            []
        , Paper.input
            [ attribute "label" "identifier"
            , onValueChanged Types.SetRegulationIDInput
            , value model.newRegulation.identifier
            ]
            []
        , Paper.textarea
            [ attribute "label" "description"
            , onValueChanged Types.SetRegulationDescriptionInput
            , value model.newRegulation.description
            ]
            []
        , Paper.button
            [ attribute "raised" ""
            , onClick (Types.GetRegulations model)
            ]
            [ text "Add" ]
        , div [ class "debug" ] [ text ("DEBUG: " ++ toString model.newRegulation) ]
        ]


activityBody : Model -> Html Msg
activityBody model =
    div [] [ text "This is the activity view" ]


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
    , { text = "Activity", iconName = "icons:history", route = Just Activity }
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
