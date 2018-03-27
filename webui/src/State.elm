module State exposing (init, update, subscriptions)

import Authentication
import Http
import Keycloak
import Navigation
import Ports
import Page.Comments
import Comment.Rest exposing (getComments, postComment)
import Comment.Types exposing (Comment, emptyNewComment)
import Route
import Types exposing (..)


init : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
init initialUser location =
    let
        ( route, routeCmd ) =
            Route.init (Just location)

        model =
            { count = 0
            , authModel = (Authentication.init Ports.keycloakLogin Ports.keycloakLogout initialUser)
            , route = route
            , selectedTab = 0
            , pageState = (Loaded Blank)
            , session = { user = initialUser }
            }
    in
        ( model
        , routeCmd
        )


transitionTo : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
transitionTo maybeLocation model =
    case maybeLocation of
        Nothing ->
            model ! []

        Just location ->
            model
                ! [ Navigation.newUrl (Route.urlFor location)
                  , Ports.setTitle (Route.titleFor location)
                  ]


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
update page msg model =
    let
        session =
            model.authModel

        toPage toModel toMsg subUpdate subMsg subModel =
            let
                (newModel, newCmd ) = 
                    subUpdate subMsg subModel
            in
            ( { model | pageState = Loaded(toModel newModel) }, Cmd.map toMsg newCmd )
        
        errored =
            pageErrored model
    in
    case ( msg, page ) of
        ( Types.AuthenticationMsg authMsg, _ ) ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map Types.AuthenticationMsg cmd )

        ( NavigateTo maybeLocation, _ ) ->
            (transitionTo maybeLocation model)

        ( UrlChange location, _ ) ->
            let
                _ =
                    Debug.log "UrlChange: " location.hash
            in
                { model | route = Route.locFor (Just location) } ! []

        ( CommentsMsg user commentMsg,  ->
            case Authentication.tryGetUserProfile model.authModel of
                Nothing ->
                    -- this should never happen
                    ( model, Cmd.none )

                Just user ->
                    Page.Comments.update commentMsg user model

        ShowError value ->
            model ! [ Ports.showError value ]


subscriptions : a -> Sub Msg
subscriptions model =
    Ports.keycloakAuthResult (Authentication.handleAuthResult >> AuthenticationMsg)
