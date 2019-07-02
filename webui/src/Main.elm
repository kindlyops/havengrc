module Main exposing (main)

import Authentication
import Browser
import Browser.Navigation as Nav
import Data.OnBoarding as OnBoarding
import Data.Survey as SurveyData
import Data.UserProfile as UserProfile
import Gravatar
import Html exposing (Html, a, button, div, i, img, li, nav, span, text, ul)
import Html.Attributes exposing (attribute, class, classList, href, id, style)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Page.Activity as Activity
import Page.Comments as Comments
import Page.Dashboard as Dashboard
import Page.Home as Home
import Page.Landing as Landing
import Page.Logout as Logout
import Page.Privacy as Privacy
import Page.Reports as Reports
import Page.Survey as Survey
import Page.SurveyResponses as SurveyResponses
import Page.Terms as Terms
import Ports
import Process
import Route
import Task
import Time
import Url
import Visualization exposing (havenSpecs)


type alias Model =
    { authModel : Authentication.Model
    , dashboardModel : Dashboard.Model
    , onBoardingModel : OnBoarding.Model
    , commentsModel : Comments.Model
    , reportsModel : Reports.Model
    , surveyModel : SurveyData.Model
    , surveyResponseModel : SurveyResponses.Model
    , key : Nav.Key
    , url : Url.Url
    , featureEnv : String
    }


type alias MenuItem =
    { text : String
    , iconName : String
    , path : String
    }


decodeSavedState : Decode.Value -> Maybe Survey.TestStructure
decodeSavedState json =
    json
        |> Decode.decodeValue Decode.string
        |> Result.toMaybe
        |> Maybe.andThen (Decode.decodeString Survey.testDecoder >> Result.toMaybe)


init : Decode.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init sessionStorage location key =
    let
        ( initialAuthModel, authCmd ) =
            Authentication.init key

        ( commentsModel, commentsCmd ) =
            Comments.init initialAuthModel

        ( onBoardingModel, onBoardingCmd ) =
            OnBoarding.init initialAuthModel

        ( dashboardModel, dashboardCmd ) =
            Dashboard.init initialAuthModel

        ( reportsModel, reportsCmd ) =
            Reports.init initialAuthModel

        ( ( surveyModel, surveyCmd ), featureEnv ) =
            case Result.toMaybe (Decode.decodeValue Survey.testDecoder sessionStorage) of
                Just savedState ->
                    ( Survey.initWithSave initialAuthModel savedState, savedState.featureEnv )

                Nothing ->
                    ( Survey.init initialAuthModel, "development" )

        ( surveyResponseModel, surveyResponsesCmd ) =
            SurveyResponses.init initialAuthModel

        model =
            { authModel = initialAuthModel
            , dashboardModel = dashboardModel
            , onBoardingModel = onBoardingModel
            , commentsModel = commentsModel
            , reportsModel = reportsModel
            , surveyModel = surveyModel
            , surveyResponseModel = surveyResponseModel
            , key = key
            , url = location
            , featureEnv = featureEnv
            }
    in
    ( model
    , Cmd.batch
        [ Cmd.map CommentsMsg commentsCmd
        , Cmd.map AuthenticationMsg authCmd
        , Cmd.map OnBoardingMsg onBoardingCmd
        , Cmd.map ReportsMsg reportsCmd
        , Cmd.map SurveyMsg surveyCmd
        , Cmd.map SurveyResponseMsg surveyResponsesCmd
        , Ports.renderVega (havenSpecs surveyModel)
        , Cmd.map AuthenticationMsg (Task.perform Authentication.AdjustTimeZone Time.here)
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map AuthenticationMsg
        (Time.every 1000 Authentication.Tick)


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
        }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChange Url.Url
    | AuthenticationMsg Authentication.Msg
    | DashboardMsg Dashboard.Msg
    | CommentsMsg Comments.Msg
    | OnBoardingMsg OnBoarding.Msg
    | ReportsMsg Reports.Msg
    | SurveyMsg Survey.Msg
    | SurveyResponseMsg SurveyResponses.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        -- a few paths in our application are not part of the SPA
                        -- but are instead other mini apps mounted at the path.
                        -- for things like keycloak (and in the future, unleash)
                        -- force a full browser page load even though it's a path
                        -- on the same domain.
                        isKeycloak =
                            String.startsWith "/auth" url.path

                        isGatekeeper =
                            String.startsWith "/oauth/" url.path
                    in
                    if isKeycloak then
                        ( model, Nav.load (Url.toString url) )

                    else if isGatekeeper then
                        ( model, Nav.load (Url.toString url) )

                    else
                        ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChange location ->
            case location.path of
                "/dashboard/" ->
                    let
                        ( reportsModel, reportsCmd ) =
                            Reports.update Reports.GetReports model.reportsModel model.authModel
                    in
                    ( { model | url = location, reportsModel = reportsModel }
                    , Cmd.map ReportsMsg reportsCmd
                    )

                _ ->
                    ( { model | url = location }, Cmd.none )

        OnBoardingMsg onBoardingMsg ->
            let
                ( onBoardingModel, cmd ) =
                    OnBoarding.update onBoardingMsg model.onBoardingModel model.authModel
            in
            ( { model | onBoardingModel = onBoardingModel }, Cmd.none )

        AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
            ( { model | authModel = authModel }
            , Cmd.batch
                [ Cmd.map AuthenticationMsg cmd ]
            )

        DashboardMsg dashboardMsg ->
            let
                ( dashboardModel, cmd ) =
                    Dashboard.update dashboardMsg model.dashboardModel

                newModel =
                    { model | dashboardModel = dashboardModel }
            in
            ( newModel
            , Cmd.map DashboardMsg cmd
            )

        CommentsMsg commentMsg ->
            let
                ( commentsModel, cmd ) =
                    Comments.update commentMsg model.commentsModel model.authModel
            in
            ( { model | commentsModel = commentsModel }, Cmd.map CommentsMsg cmd )

        ReportsMsg reportMsg ->
            let
                ( reportsModel, cmd ) =
                    Reports.update reportMsg model.reportsModel model.authModel
            in
            ( { model | reportsModel = reportsModel }, Cmd.map ReportsMsg cmd )

        SurveyMsg surveyMsg ->
            case surveyMsg of
                Survey.SaveCurrentSurvey ->
                    let
                        ( surveyModel, cmd ) =
                            Survey.update surveyMsg model.surveyModel model.authModel

                        ( surveyResponseModel, respCmd ) =
                            SurveyResponses.update SurveyResponses.GetResponses model.surveyResponseModel model.authModel
                    in
                    ( { model | surveyModel = surveyModel, surveyResponseModel = surveyResponseModel }
                    , Cmd.batch [ Cmd.map SurveyResponseMsg respCmd, Cmd.map SurveyMsg cmd ]
                    )

                _ ->
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


navDrawerItems : Model -> List MenuItem
navDrawerItems model =
    let
        baseItems =
            [ { text = "Dashboard", iconName = "dashboard", path = "/dashboard/" }
            , { text = "Survey", iconName = "assignment", path = "/survey/" }
            ]

        allItems =
            if String.startsWith "dev" model.featureEnv then
                baseItems
                    ++ [ { text = model.featureEnv, iconName = "history", path = "/activity/" }
                       , { text = "Reports", iconName = "library_books", path = "/reports/" }
                       , { text = "Comments", iconName = "gavel", path = "/comments/" }
                       , { text = "SurveyResponses", iconName = "insert_chart", path = "/surveyResponses/" }
                       ]

            else
                baseItems
    in
    allItems


view : Model -> Browser.Document Msg
view model =
    let
        r =
            Route.locFor model.url

        t =
            Route.titleFor r
    in
    { title = t
    , body =
        [ case Authentication.tryGetUserProfile model.authModel of
            Nothing ->
                outsideView model

            Just user ->
                insideView model user
        ]
    }


outsideContainer : Html msg -> Html msg
outsideContainer html =
    div [ class "container p-3" ]
        [ html ]


outsideView : Model -> Html Msg
outsideView model =
    case Route.locFor model.url of
        Route.Privacy ->
            outsideContainer Privacy.view

        Route.Terms ->
            outsideContainer Terms.view

        Route.Landing ->
            outsideContainer (Landing.view |> Html.map AuthenticationMsg)

        Route.Survey ->
            outsideContainer (Survey.view model.authModel model.surveyModel |> Html.map SurveyMsg)

        Route.Logout ->
            outsideContainer Logout.view

        -- everything else gets the front page
        _ ->
            Home.view |> Html.map AuthenticationMsg


insideView : Model -> UserProfile.UserProfile -> Html Msg
insideView model user =
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


viewNavigationDrawer : Model -> UserProfile.UserProfile -> Html Msg
viewNavigationDrawer model user =
    div [ attribute "aria-hidden" "true", class "navdrawer navdrawer-permanent-lg navdrawer-permanent-clipped", id "navdrawerDefault", attribute "tabindex" "-1" ]
        [ div [ class "navdrawer-content" ]
            [ div [ class "navdrawer-header" ]
                [ img
                    [ attribute "src" (getGravatar user.username)
                    , class "user-avatar"
                    ]
                    []
                , viewNavUser model user
                ]
            , viewNavDrawerItems (navDrawerItems model) model.url
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    div [ id "content", class "content-wrapper container" ]
        [ case Route.locFor model.url of
            Route.Home ->
                Dashboard.view model.authModel model.dashboardModel model.reportsModel |> Html.map DashboardMsg

            Route.Reports ->
                Reports.view model.authModel model.reportsModel |> Html.map ReportsMsg

            Route.Privacy ->
                Privacy.view

            Route.Terms ->
                Terms.view

            Route.Dashboard ->
                Dashboard.view model.authModel model.dashboardModel model.reportsModel |> Html.map DashboardMsg

            Route.Comments ->
                Comments.view model.authModel model.commentsModel |> Html.map CommentsMsg

            Route.Activity ->
                Activity.view

            Route.Survey ->
                Survey.view model.authModel model.surveyModel |> Html.map SurveyMsg

            Route.SurveyResponses ->
                SurveyResponses.view model.authModel model.surveyResponseModel |> Html.map SurveyResponseMsg

            Route.NotFound ->
                notFoundBody model

            Route.Login ->
                -- TODO: do we need this?
                notFoundBody model

            Route.EditComment _ ->
                -- TODO: do we need this?
                notFoundBody model

            Route.Landing ->
                -- TODO: do we need this?
                notFoundBody model

            Route.ShowComment _ ->
                -- TODO: do we need this?
                notFoundBody model

            Route.Logout ->
                notFoundBody model
        ]


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


viewNavUser : Model -> UserProfile.UserProfile -> Html Msg
viewNavUser model user =
    ul [ class "navbar-nav" ]
        [ li [ class "nav-item dropdown" ]
            [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link dropdown-toggle", attribute "data-toggle" "dropdown", href "#", id "navbarDropdown", attribute "role" "button" ]
                [ text (user.firstName ++ " ")
                ]
            , div [ attribute "aria-labelledby" "navbarDropdown", class "dropdown-menu dropdown-menu-right" ]
                [ a [ class "dropdown-item", href "/auth/realms/havendev/account/" ]
                    [ text "Profile" ]
                , div [ class "dropdown-divider" ]
                    []
                , a [ class "dropdown-item", href "/oauth/logout?redirect=/logout" ]
                    [ text "Logout" ]
                ]
            ]
        ]


viewNavDrawerItems : List MenuItem -> Url.Url -> Html Msg
viewNavDrawerItems menuItems url =
    nav [ class "navdrawer-nav" ]
        (List.map
            (\menuItem ->
                viewNavDrawerItem menuItem url
            )
            menuItems
        )


viewNavDrawerItem : MenuItem -> Url.Url -> Html Msg
viewNavDrawerItem menuItem url =
    li [ class "nav-item" ]
        [ a
            [ attribute "name" (String.toLower menuItem.text)
            , href menuItem.path
            , style "cursor" "pointer"
            , classList
                [ ( "nav-link", True )
                , ( "active", String.toLower menuItem.path == url.path )
                ]
            ]
            [ i [ class "material-icons mx-3" ] [ text menuItem.iconName ]
            , text menuItem.text
            ]
        ]
