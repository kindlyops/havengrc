module Authentication exposing
    ( LoggedInUser
    , Model
    , Msg(..)
    , getReturnHeaders
    , init
    , isLoggedIn
    , tryGetUserProfile
    , update
    )

import Browser.Navigation as Nav
import Data.UserProfile exposing (UserProfile, decode)
import Http
import Json.Decode as Decode exposing (Decoder, bool, field, int, map2, map5, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Ports as Ports exposing (saveSurveyState)


type AuthenticationState
    = LoggedOut
    | LoggedIn LoggedInUser


type alias Options =
    {}


type alias LoggedInUser =
    { profile : UserProfile
    }


type alias Model =
    { state : AuthenticationState
    , lastError : Maybe Http.Error
    }


type Msg
    = HandleProfileResult (Result Http.Error UserProfile)
    | LogOut
    | LoginMsg


init : ( Model, Cmd Msg )
init =
    ( { state = LoggedOut
      , lastError = Nothing
      }
    , Cmd.batch initialCommands
    )


initialCommands : List (Cmd Msg)
initialCommands =
    -- fire the HTTP request to load the user profile if logged in
    [ getProfile ]


profileUrl : String
profileUrl =
    "/oauth/token"


getProfile : Cmd Msg
getProfile =
    Http.get
        { url = profileUrl
        , expect = Http.expectJson HandleProfileResult Data.UserProfile.decode
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleProfileResult result ->
            -- we loaded the user profile info from
            -- /realms/{realm-name}/protocol/openid-connect/userinfo
            let
                ( newState, error ) =
                    case result of
                        Ok profile ->
                            ( LoggedIn { profile = profile }, Nothing )

                        Err err ->
                            ( LoggedOut, Just err )
            in
            ( { model | state = newState, lastError = error }, Cmd.none )

        LoginMsg ->
            -- Force full page reload of dashboard using Nav.load, which will trigger
            -- gatekeeper to initiate the OIDC redirect for login at Keycloak
            ( model, Nav.load "http://dev.havengrc.com/dashboard/" )

        LogOut ->
            ( { model | state = LoggedOut }, Ports.saveSurveyState Nothing )


tryGetUserProfile : Model -> Maybe UserProfile
tryGetUserProfile model =
    case model.state of
        LoggedIn user ->
            Just user.profile

        LoggedOut ->
            Nothing


isLoggedIn : Model -> Bool
isLoggedIn model =
    case model.state of
        LoggedIn _ ->
            True

        LoggedOut ->
            False


getReturnHeaders : List Http.Header
getReturnHeaders =
    [ Http.header "Prefer" "return=representation" ]
