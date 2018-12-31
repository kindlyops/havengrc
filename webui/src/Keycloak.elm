module Keycloak exposing
    ( AuthenticationError
    , AuthenticationResult
    , AuthenticationState(..)
    , LoggedInUser
    , Options
    , RawAuthenticationResult
    , Token
    , UserProfile
    , defaultOpts
    , loggedInUserDecoder
    , mapResult
    )

import Json.Decode as Decode exposing (Decoder, bool, field, int, map2, map5, oneOf, string, succeed)
import Json.Decode.Pipeline exposing (required)


type alias LoggedInUser =
    { profile : UserProfile
    , token : Token
    }


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


mapResult : RawAuthenticationResult -> AuthenticationResult
mapResult result =
    case ( result.err, result.ok ) of
        ( Just msg, _ ) ->
            Err msg

        ( Nothing, Nothing ) ->
            Err { name = Nothing, code = Nothing, statusCode = Nothing, description = "No information was received from the authentication provider" }

        ( Nothing, Just user ) ->
            Ok user


defaultOpts : Options
defaultOpts =
    {}
