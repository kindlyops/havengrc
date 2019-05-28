module Authentication exposing
    ( LoggedInUser
    , Model
    , Msg(..)
    , UserProfile
    , getReturnHeaders
    , init
    , isLoggedIn
    , loggedInUserDecoder
    , tryGetUserProfile
    , update
    )

import Browser.Navigation as Nav
import Http
import Json.Decode as Decode exposing (Decoder, bool, field, int, map2, map5, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Ports as Ports exposing (saveSurveyState)


type AuthenticationState
    = LoggedOut
    | LoggedIn LoggedInUser


type alias Options =
    {}


type alias UserProfile =
    { username : String
    , emailVerified : Bool
    , firstName : String
    , lastName : String
    , email : String
    }


type alias LoggedInUser =
    { profile : UserProfile
    , token : Token
    }


type alias Token =
    String


type alias AuthenticationError =
    { name : Maybe String
    , code : Maybe String
    , description : String
    , statusCode : Maybe Int
    }


type alias AuthenticationResult =
    Result AuthenticationError LoggedInUser


type alias RawAuthenticationResult =
    { err : Maybe AuthenticationError
    , ok : Maybe LoggedInUser
    }


type alias Model =
    { state : AuthenticationState
    , lastError : Maybe AuthenticationError
    }


type Msg
    = HandleProfileResult (Result Http.Error String)
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
    -- fire the HTTP request to load the user profile if logged int
    [ getProfile ]


profileUrl : String
profileUrl =
    "/realms/havendev/protocol/openid-connect/userinfo"


getProfile : Cmd Msg
getProfile =
    Http.get
        { url = profileUrl
        , expect = Http.expectString HandleProfileResult
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleProfileResult profile ->
            -- TODO: load the user profile info from
            -- /realms/{realm-name}/protocol/openid-connect/userinfo
            let
                _ =
                    Debug.todo "profile results"
            in
            ( model, Cmd.none )

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


loggedInUserDecoder : Decoder LoggedInUser
loggedInUserDecoder =
    map2 LoggedInUser
        (field "profile" userProfileDecoder)
        (field "token" string)


userProfileDecoder : Decoder UserProfile
userProfileDecoder =
    map5 UserProfile
        (field "username" string)
        (field "emailVerified" bool)
        (field "firstName" string)
        (field "lastName" string)
        (field "email" string)
