module Main exposing (main)

import Keycloak
import Navigation
import Gravatar
import Authentication
import Ports
import Html exposing (Html, div, nav, button, span, text, ul, li, a, img, i)
import Html.Attributes exposing (class, attribute, id, href, style, classList)
import Html.Events exposing (onClick)
import Route
import Page.Home as Home
import Page.Dashboard as Dashboard
import Page.Comments as Comments
import Page.Activity as Activity
import Page.Reports as Reports
import Page.Survey as Survey
import Page.SurveyResponses as SurveyResponses


type alias Model =
    { route : Route.Model
    , authModel : Authentication.Model
    , dashboardModel : Dashboard.Model
    , commentsModel : Comments.Model
    , surveyModel : Survey.Model
    , surveyResponseModel : SurveyResponses.Model
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

        ( surveyResponseModel, surveyResponsesCmd ) =
            SurveyResponses.init initialAuthModel

        model =
            { route = route
            , authModel = initialAuthModel
            , dashboardModel = Dashboard.init
            , commentsModel = commentsModel
            , surveyModel = surveyModel
            , surveyResponseModel = surveyResponseModel
            }
    in
        ( model
        , Cmd.batch
            [ routeCmd
            , Cmd.map CommentsMsg commentsCmd
            , Cmd.map SurveyMsg surveyCmd
            , Cmd.map SurveyResponseMsg surveyResponsesCmd
            ]
        )


subscriptions : a -> Sub Msg
subscriptions model =
    Ports.keycloakAuthResult (Authentication.handleAuthResult >> AuthenticationMsg)


main : Program (Maybe Keycloak.LoggedInUser) Model Msg
main =
    Navigation.programWithFlags UrlChange
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
    | SurveyResponseMsg SurveyResponses.Msg


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
                    , Cmd.map CommentsMsg commentsCmd
                    , Cmd.map SurveyMsg surveyCmd
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

        SurveyResponseMsg surveyResponseMsg ->
            let
                ( surveyResponseModel, cmd ) =
                    SurveyResponses.update surveyResponseMsg model.surveyResponseModel model.authModel
            in
                ( { model | surveyResponseModel = surveyResponseModel }, Cmd.map SurveyResponseMsg cmd )


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
    , { text = "Survey", iconName = "assignment", route = Just Route.Survey }
    , { text = "SurveyResponses", iconName = "insert_chart_outlined", route = Just Route.SurveyResponses }
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
        [ viewNavBar model
        , viewNavigationDrawer model user
        , viewBody model
        ]


viewNavBar : Model -> Html Msg
viewNavBar model =
    nav [ class "navbar navbar-expand-lg fixed-top navbar-dark bg-primary " ]
        [ button [ attribute "aria-controls" "navdrawerDefault", attribute "aria-expanded" "false", attribute "aria-label" "Toggle Navdrawer", class "navbar-toggler d-lg-none", attribute "data-breakpoint" "lg", attribute "data-target" "#navdrawerDefault", attribute "data-toggle" "navdrawer", attribute "data-type" "permanent" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , div [ class "navbar-brand" ]
            [ text "Haven GRC" ]
        ]


viewNavigationDrawer : Model -> Keycloak.UserProfile -> Html Msg
viewNavigationDrawer model user =
    div [ attribute "aria-hidden" "true", class "navdrawer navdrawer-permanent-lg navdrawer-permanent-clipped", id "navdrawerDefault", attribute "tabindex" "-1" ]
        [ div [ class "navdrawer-content" ]
            [ div [ class "navdrawer-header" ]
                [ viewNavUser model user ]
            , viewNavDrawerItems navDrawerItems model.route
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    div [ id "content", class "content-wrapper container" ]
        [ case model.route of
            Nothing ->
                Dashboard.view model.dashboardModel |> Html.map DashboardMsg

            Just Route.Home ->
                Dashboard.view model.dashboardModel |> Html.map DashboardMsg

            Just Route.Reports ->
                Reports.view

            Just Route.Dashboard ->
                Dashboard.view model.dashboardModel |> Html.map DashboardMsg

            Just Route.Comments ->
                Comments.view model.authModel model.commentsModel |> Html.map CommentsMsg

            Just Route.Activity ->
                Activity.view

            Just Route.Survey ->
                Survey.view model.authModel model.surveyModel |> Html.map SurveyMsg

            Just Route.SurveyResponses ->
                SurveyResponses.view model.authModel model.surveyResponseModel |> Html.map SurveyResponseMsg

            Just _ ->
                notFoundBody model
        ]


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


viewNavUser : Model -> Keycloak.UserProfile -> Html Msg
viewNavUser model user =
    ul [ class "navbar-nav" ]
        [ li [ class "nav-item dropdown" ]
            [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link dropdown-toggle", attribute "data-toggle" "dropdown", href "#", id "navbarDropdown", attribute "role" "button" ]
                [ text (user.firstName ++ " ")
                , img
                    [ attribute "src" (getGravatar user.username)
                    , class "user-avatar"
                    ]
                    []
                ]
            , div [ attribute "aria-labelledby" "navbarDropdown", class "dropdown-menu" ]
                [ a [ class "dropdown-item", href "/auth/realms/havendev/account/" ]
                    [ text "Profile" ]
                , div [ class "dropdown-divider" ]
                    []
                , a [ class "dropdown-item", href "#", onClick (AuthenticationMsg Authentication.LogOut) ]
                    [ text "Logout" ]
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
        , style [ ( "cursor", "pointer" ) ]
        , classList
            [ ( "nav-item", True )
            , ( "nav-link", True )
            , ( "active", String.toLower menuItem.text == selectedItem route )
            ]
        ]
        [ i [ class "material-icons" ] [ text menuItem.iconName ]
        , text menuItem.text
        ]
