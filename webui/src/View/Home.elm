module View.Home exposing (view)

import Authentication
import Gravatar
import View.Centroid as Centroid
import Date
import List exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onWithOptions, on)
import Json.Decode as Json
import Keycloak
import Page.Comments
import View.LineChart as LineChart
import View.Spinner exposing (spinner)
import Route exposing (Location(..), locFor)
import String exposing (toLower)
import Types


header : Types.Model -> Html Types.Msg
header model =
    div [ class "mdc-toolbar mdc-toolbar--fixed header" ]
        [ div [ class "mdc-toolbar__row" ]
            [ section [ class "mdc-toolbar__section mdc-toolbar__section--align-start" ]
                [ button
                    [ id "MenuButton"
                    , class "menu material-icons mdc-toolbar__icon--menu"
                    ]
                    [ text "menu" ]
                , h1 [ class "mdc-toolbar__title" ]
                    [ text "Haven GRC" ]
                ]
            ]
        ]


getGravatar : String -> String
getGravatar email =
    let
        options =
            Gravatar.defaultOptions
                |> Gravatar.withDefault Gravatar.Identicon

        url =
            Gravatar.url options email
    in
        "https:" ++ url


view : Types.Model -> Keycloak.UserProfile -> Html Types.Msg
view model user =
    div [ class "container" ]
        [ div
            [ id "MenuDrawer"
            , class "mdc-persistent-drawer mdc-typography sm-screen-drawer lg-screen-drawer"
            ]
            [ nav [ class "mdc-persistent-drawer__drawer sidebar" ]
                [ div [ class "mdc-persistent-drawer__toolbar-spacer" ]
                    []
                , div [ class "user-container" ]
                    [ img
                        [ attribute "sizing" "contain"
                        , attribute "src" (getGravatar user.username)
                        , class "user-avatar"
                        ]
                        []
                    , span [ class "user-name" ]
                        [ text user.firstName ]
                    , div [ class "mdc-menu-anchor" ]
                        [ button
                            [ id "UserDropdownButton"
                            , class "user-menu-btn"
                            ]
                            [ i [ class "material-icons" ]
                                [ text "arrow_drop_down" ]
                            ]
                        , div
                            [ id "UserDropdownMenu"
                            , class "mdc-simple-menu"
                            , attribute "tabindex" "-1"
                            ]
                            [ ul [ class "mdc-simple-menu__items mdc-list" ]
                                [ a
                                    [ class "mdc-list-item"
                                    , href "/auth/realms/havendev/account/"
                                    , attribute "tabindex" "0"
                                    ]
                                    [ text "Edit Account" ]
                                , li
                                    [ class "mdc-list-item"
                                    , onClick (Types.AuthenticationMsg Authentication.LogOut)
                                    , attribute "tabindex" "0"
                                    ]
                                    [ text "Log Out" ]
                                ]
                            ]
                        ]
                    ]
                , div [ class "nav-list-container" ]
                    [ div [ class "nav-flex" ]
                        [ nav [ class "mdc-persistent-drawer__content mdc-list" ]
                            (List.map (\item -> drawerMenuItem model item) menuItems)
                        ]
                    , div [ class "drawer-logo" ]
                        [ img [ attribute "src" "%PUBLIC_URL%/img/logo@2x.png" ]
                            []
                        ]
                    ]
                ]
            ]
        , div [ class "mdc-toolbar-fixed-adjust" ]
            [ header model
            , body model
            ]
        ]


selectedItem : Types.Model -> String
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


snackBar : Types.Model -> Html Types.Msg
snackBar model =
    div
        [ id "error-snackbar"
        , class "mdc-snackbar"
        , attribute "aria-live" "assertive"
        , attribute "aria-atomic" "true"
        , attribute "aria-hidden" "true"
          -- , onClick (Types.ShowError "this is an error message")
        ]
        [ div [ class "mdc-snackbar__text" ] []
        , div [ class "mdc-snackbar__action-wrapper" ]
            [ button [ class "mdc-snackbar__action-button" ] [] ]
        ]


body : Types.Model -> Html msg
body model =
    div [ id "content" ]
        [ case model.route of
            Nothing ->
                dashboardBody model

            Just Home ->
                dashboardBody model

            Just Reports ->
                -- reportsBody model
                spinner

            Just Comments ->
                Page.Comments.view model.authModel

            Just Activity ->
                activityBody model

            Just _ ->
                notFoundBody model
        , snackBar model
        ]


dashboardBody : Types.Model -> Html Types.Msg
dashboardBody model =
    let
        data =
            [ 1, 1, 2, 3, 5, 8, 13 ]
    in
        div
            []
            [ Centroid.view data
            , br [] []
            , button
                [ class "mdc-button mdc-button--raised mdc-button--accent"
                , attribute "data-mdc-auto-init" "MDCRipple"
                , onClick (Types.ShowError "this is an error message")
                ]
                [ text "Show Error" ]
            ]


reportsBody : Types.Model -> Html Types.Msg
reportsBody model =
    div []
        [ div []
            [ text "This is the reports view"
            , ol []
                [ li []
                    [ a [ href "../js/pdf/web/viewer.html?file=haven-booth-concepts.pdf", target "_blank" ]
                        [ text "Report" ]
                    ]
                , li []
                    [ a [ href "../js/pdf/web/viewer.html", target "_blank" ]
                        [ text "Same report" ]
                    ]
                ]
            ]
        ]


onValueChanged : (String -> msg) -> Html.Attribute msg
onValueChanged tagger =
    on "value-changed" (Json.map tagger Html.Events.targetValue)


activityBody : Types.Model -> Html Types.Msg
activityBody model =
    let
        data =
            [ ( Date.fromTime 1448928000000, 2 )
            , ( Date.fromTime 1451606400000, 2 )
            , ( Date.fromTime 1454284800000, 1 )
            , ( Date.fromTime 1456790400000, 1 )
            ]
    in
        div []
            [ div []
                [ text "What is Risk Management?" ]
            , LineChart.view data
            ]


notFoundBody : Types.Model -> Html Types.Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Home }
    , { text = "Activity", iconName = "history", route = Just Activity }
    , { text = "Reports", iconName = "library_books", route = Just Reports }
    , { text = "Comments", iconName = "gavel", route = Just Comments }
    ]


drawerMenuItem : Types.Model -> MenuItem -> Html Types.Msg
drawerMenuItem model menuItem =
    a
        [ attribute "name" (toLower menuItem.text)
        , onClick <| Types.NavigateTo <| menuItem.route
        , classList
            [ ( "mdc-list-item", True )
            , ( "mdc-persistent-drawer--selected", (toLower menuItem.text) == (selectedItem model) )
            ]
        ]
        [ i [ class "material-icons mdc-list-item__start-detail" ] [ text menuItem.iconName ]
        , text menuItem.text
        ]
