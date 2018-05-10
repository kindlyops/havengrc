module Main exposing (..)

import Keycloak
import Navigation
import Gravatar
import Authentication
import Http
import Keycloak
import Ports
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Page.Home as Home
import Page.Dashboard as Dashboard
import Page.Comments as Comments
import Page.Activity as Activity
import Page.Reports as Reports
import Page.Survey as Survey


type alias Model =
    { route : Route.Model
    , authModel : Authentication.Model
    , dashboardModel : Dashboard.Model
    , commentsModel : Comments.Model
    , surveyModel : Survey.Model
    }


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


init : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
init initialUser location =
    let
        initialAuthModel =
            Authentication.init Ports.keycloakLogin Ports.keycloakLogout initialUser

        ( route, routeCmd ) =
            Route.init (Just location)

        ( commentsModel, commentsCmd ) =
            Comments.init initialAuthModel

        ( surveyModel, surveyCmd ) =
            Survey.init initialAuthModel

        model =
            { route = route
            , authModel = initialAuthModel
            , dashboardModel = Dashboard.init
            , commentsModel = commentsModel
            , surveyModel = surveyModel
            }
    in
        ( model
        , Cmd.batch
            [ routeCmd
            , (Cmd.map CommentsMsg commentsCmd)
            , (Cmd.map SurveyMsg surveyCmd)
            ]
        )


subscriptions : a -> Sub Msg
subscriptions model =
    Ports.keycloakAuthResult (Authentication.handleAuthResult >> AuthenticationMsg)


main : Program (Maybe Keycloak.LoggedInUser) Model Msg
main =
    Navigation.programWithFlags (UrlChange)
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Msg
    = NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | ShowError String
    | AuthenticationMsg Authentication.Msg
    | DashboardMsg Dashboard.Msg
    | CommentsMsg Comments.Msg
    | SurveyMsg Survey.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    model
                        ! [ Navigation.newUrl (Route.urlFor location)
                          , Ports.setTitle (Route.titleFor location)
                          ]

        UrlChange location ->
            let
                _ =
                    Debug.log "UrlChange: " location.hash
            in
                { model | route = Route.locFor (Just location) } ! []

        ShowError value ->
            model ! [ Ports.showError value ]

        AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel

                ( commentsModel, commentsCmd ) =
                    Comments.init authModel

                ( surveyModel, surveyCmd ) =
                    Survey.init authModel
            in
                ( { model
                    | authModel = authModel
                    , commentsModel = commentsModel
                    , surveyModel = surveyModel
                  }
                , Cmd.batch
                    [ Cmd.map AuthenticationMsg cmd
                    , (Cmd.map CommentsMsg commentsCmd)
                    , (Cmd.map SurveyMsg surveyCmd)
                    ]
                )

        DashboardMsg dashboardMsg ->
            let
                ( dashboardModel, cmd ) =
                    Dashboard.update dashboardMsg model.dashboardModel
            in
                ( { model | dashboardModel = dashboardModel }, Cmd.map DashboardMsg cmd )

        CommentsMsg commentMsg ->
            let
                ( commentsModel, cmd ) =
                    Comments.update commentMsg model.commentsModel model.authModel
            in
                ( { model | commentsModel = commentsModel }, Cmd.map CommentsMsg cmd )

        SurveyMsg surveyMsg ->
            let
                ( surveyModel, cmd ) =
                    Survey.update surveyMsg model.surveyModel model.authModel
            in
                ( { model | surveyModel = surveyModel }, Cmd.map SurveyMsg cmd )


getHTTPErrorMessage : Http.Error -> String
getHTTPErrorMessage error =
    case error of
        Http.NetworkError ->
            "Is the server running?"

        Http.BadStatus response ->
            (toString response.status)

        Http.BadPayload message _ ->
            "Decoding Failed: " ++ message

        _ ->
            (toString error)


selectedItem : Route.Model -> String
selectedItem route =
    let
        item =
            List.head (List.filter (\m -> m.route == route) navDrawerItems)
    in
        case item of
            Nothing ->
                "dashboard"

            Just item ->
                String.toLower item.text


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


navDrawerItems : List MenuItem
navDrawerItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Route.Dashboard }
    , { text = "Activity", iconName = "history", route = Just Route.Activity }
    , { text = "Reports", iconName = "library_books", route = Just Route.Reports }
    , { text = "Comments", iconName = "gavel", route = Just Route.Comments }
    , { text = "SurveyPrototype", iconName = "assignment", route = Just Route.SurveyPrototype }
    ]


view : Model -> Html Msg
view model =
    case Authentication.tryGetUserProfile model.authModel of
        Nothing ->
            Home.view |> Html.map AuthenticationMsg

        Just user ->
            viewMain model user


viewMain : Model -> Keycloak.UserProfile -> Html Msg
viewMain model user =
    div []
        [ viewNavBar model user
        , viewNavigationDrawer model
        , viewBody model
        ]


viewNavBar : Model -> Keycloak.UserProfile -> Html Msg
viewNavBar model user =
    nav [ class "navbar navbar-expand-lg fixed-top navbar-dark bg-primary " ]
        [ button [ attribute "aria-controls" "navdrawerDefault", attribute "aria-expanded" "false", attribute "aria-label" "Toggle Navdrawer", class "navbar-toggler d-lg-none", attribute "data-breakpoint" "lg", attribute "data-target" "#navdrawerDefault", attribute "data-toggle" "navdrawer", attribute "data-type" "permanent" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , a [ class "navbar-brand", href "#" ]
            [ text "Haven GRC" ]
        , button [ attribute "aria-controls" "navbarSupportedContent", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation", class "navbar-toggler", attribute "data-target" "#navbarSupportedContent", attribute "data-toggle" "collapse", type_ "button" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , viewNavUser model user
        , div [ class "collapse navbar-collapse", id "navbarSupportedContent" ]
            [ ul [ class "navbar-nav mr-auto" ]
                [ li [ class "nav-item active" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Home "
                        , span [ class "sr-only" ]
                            [ text "(current)" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Github" ]
                    ]
                ]
            , ul [ class "navbar-nav" ]
                [ li [ class "nav-item active" ] [ a [ class "nav-link" ] [ text "Programs" ] ]
                , li [ class "nav-item active" ] [ a [ class "nav-link" ] [ text "Assets" ] ]
                , li [ class "nav-item active" ] [ a [ class "nav-link" ] [ text "People" ] ]
                ]
            ]
        ]


viewNavigationDrawer : Model -> Html Msg
viewNavigationDrawer model =
    div [ attribute "aria-hidden" "true", class "navdrawer navdrawer-permanent-lg navdrawer-permanent-clipped", id "navdrawerDefault", attribute "tabindex" "-1" ]
        [ div [ class "navdrawer-content" ]
            [ div [ class "navdrawer-header" ]
                [ a [ class "navbar-brand px-0", href "#" ]
                    [ text "Pages" ]
                ]
            , viewNavDrawerItems navDrawerItems model.route
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    div [ id "content", class "content-wrapper" ]
        [ case model.route of
            Nothing ->
                (Dashboard.view model.dashboardModel) |> Html.map DashboardMsg

            Just Route.Home ->
                (Dashboard.view model.dashboardModel) |> Html.map DashboardMsg

            Just Route.Reports ->
                Reports.view

            Just Route.Dashboard ->
                (Dashboard.view model.dashboardModel) |> Html.map DashboardMsg

            Just Route.Comments ->
                Comments.view model.authModel model.commentsModel |> Html.map CommentsMsg

            Just Route.Activity ->
                Activity.view

            Just Route.SurveyPrototype ->
                Survey.view model.authModel model.surveyModel |> Html.map SurveyMsg

            Just _ ->
                notFoundBody model
        ]


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


viewHeader : Model -> Html Msg
viewHeader model =
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


viewNavUser : Model -> Keycloak.UserProfile -> Html Msg
viewNavUser model user =
    ul [ class "navbar-nav" ]
        [ li [ class "nav-item dropdown" ]
            [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link dropdown-toggle", attribute "data-toggle" "dropdown", href "#", id "navbarDropdown", attribute "role" "button" ]
                [ img
                    [ attribute "src" (getGravatar user.username)
                    , class "user-avatar"
                    ]
                    []
                ]
            , div [ attribute "aria-labelledby" "navbarDropdown", class "dropdown-menu" ]
                [ a [ class "dropdown-item", href "#" ]
                    [ text "Profile" ]
                , a [ class "dropdown-item", href "#" ]
                    [ text "Another action" ]
                , div [ class "dropdown-divider" ]
                    []
                , a [ class "dropdown-item", href "#", onClick (AuthenticationMsg Authentication.LogOut) ]
                    [ text "Logout" ]
                ]
            ]
        ]


viewUser : Model -> Keycloak.UserProfile -> Html Msg
viewUser model user =
    div [ class "user-container" ]
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
                        , onClick (AuthenticationMsg Authentication.LogOut)
                        , attribute "tabindex" "0"
                        ]
                        [ text "Log Out" ]
                    ]
                ]
            ]
        ]


viewNavDrawerItems : List MenuItem -> Route.Model -> Html Msg
viewNavDrawerItems menuItems route =
    nav [ class "navdrawer-nav" ]
        (List.map
            (\menuItem ->
                viewNavDrawerItem menuItem route
            )
            menuItems
        )


viewNavDrawerItem : MenuItem -> Route.Model -> Html Msg
viewNavDrawerItem menuItem route =
    a
        [ attribute "name" (String.toLower menuItem.text)
        , onClick <| NavigateTo <| menuItem.route

        --, href "#"
        , style [ ( "cursor", "pointer" ) ]
        , classList
            [ ( "nav-item", True )
            , ( "nav-link", True )
            , ( "active", (String.toLower menuItem.text) == (selectedItem route) )
            ]
        ]
        [ i [ class "material-icons" ] [ text menuItem.iconName ]
        , text menuItem.text
        ]
