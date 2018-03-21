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
import Page.Activity
import View.LineChart as LineChart
import View.Spinner exposing (spinner)
import Route
import String exposing (toLower)
import Types


header : Types.Model -> Keycloak.UserProfile -> Html Types.Msg
header model user =
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


view : Bool -> Types.Page -> Keycloak.UserProfile -> Html Types.Msg
view loading page user =
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
                            (List.map (\item -> drawerMenuItem page item) menuItems)
                        ]
                    , div [ class "drawer-logo" ]
                        [ img [ attribute "src" "%PUBLIC_URL%/img/logo@2x.png" ]
                            []
                        ]
                    ]
                ]
            ]
        , div [ class "mdc-toolbar-fixed-adjust" ]
            [ header page user
            , body page user
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


snackBar : Types.Model -> Keycloak.UserProfile -> Html Types.Msg
snackBar model user =
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


body : Types.Page -> Keycloak.UserProfile -> Html Types.Msg
body page user =
    div [ id "content" ]
        [ case page of
            Types.Home model ->
                dashboardBody model user

            Types.Comments model ->
                Page.Comments.view model user

            Types.Activity model ->
                activityBody model user

            Types.Blank ->
                notFoundBody user

            Types.NotFound ->
                notFoundBody user

            Types.Errored _ ->
                notFoundBody user
        , snackBar page user
        ]


dashboardBody : Page.Home.Model -> Keycloak.UserProfile -> Html Types.Msg
dashboardBody model user =
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


reportsBody : Types.Page -> Keycloak.UserProfile -> Html Types.Msg
reportsBody page user =
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


activityBody : Page.Activity.Model -> Keycloak.UserProfile -> Html Types.Msg
activityBody model user =
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


notFoundBody : Types.Model -> Keycloak.UserProfile -> Html Types.Msg
notFoundBody model user =
    div [] [ text "This is the notFound view" ]


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


menuItems : List MenuItem
menuItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Route.Home }
    , { text = "Activity", iconName = "history", route = Just Route.Activity }
    , { text = "Reports", iconName = "library_books", route = Just Route.Reports }
    , { text = "Comments", iconName = "gavel", route = Just Route.Comments }
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
