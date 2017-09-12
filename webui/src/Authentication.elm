module Authentication
    exposing
        ( Msg(..)
        , Model
        , init
        , update
        , handleAuthResult
        , tryGetUserProfile
        , isLoggedIn
        )

import Keycloak


type alias Model =
    { state : Keycloak.AuthenticationState
    , lastError : Maybe Keycloak.AuthenticationError
    , showLock : Keycloak.Options -> Cmd Msg
    , logOut : () -> Cmd Msg
    }


init : (Keycloak.Options -> Cmd Msg) -> (() -> Cmd Msg) -> Maybe Keycloak.LoggedInUser -> Model
init showLock logOut initialData =
    { state =
        case initialData of
            Just user ->
                Keycloak.LoggedIn user

            Nothing ->
                Keycloak.LoggedOut
    , lastError = Nothing
    , showLock = showLock
    , logOut = logOut
    }


type Msg
    = AuthenticationResult Keycloak.AuthenticationResult
    | ShowLogIn
    | LogOut


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthenticationResult result ->
            let
                ( newState, error ) =
                    case result of
                        Ok user ->
                            ( Keycloak.LoggedIn user, Nothing )

                        Err err ->
                            ( Keycloak.LoggedOut, Just err )
            in
                ( { model | state = newState, lastError = error }, Cmd.none )

        ShowLogIn ->
            ( model, model.showLock Keycloak.defaultOpts )

        LogOut ->
            ( { model | state = Keycloak.LoggedOut }, model.logOut () )


handleAuthResult : Keycloak.RawAuthenticationResult -> Msg
handleAuthResult =
    Keycloak.mapResult >> AuthenticationResult


tryGetUserProfile : Model -> Maybe Keycloak.UserProfile
tryGetUserProfile model =
    case model.state of
        Keycloak.LoggedIn user ->
            Just user.profile

        Keycloak.LoggedOut ->
            Nothing


isLoggedIn : Model -> Bool
isLoggedIn model =
    case model.state of
        Keycloak.LoggedIn _ ->
            True

        Keycloak.LoggedOut ->
            False
