-- Auth0.elm


module Auth0
    exposing
        ( AuthenticationState(..)
        , AuthenticationError
        , AuthenticationResult
        , RawAuthenticationResult
        , Options
        , defaultOpts
        , LoggedInUser
        , UserProfile
        , Token
        , mapResult
        )


type alias LoggedInUser =
    { profile : UserProfile
    , token : Token
    }


type AuthenticationState
    = LoggedOut
    | LoggedIn LoggedInUser


type alias Options =
    {}


type alias UserProfile =
    { email : String
    , email_verified : Bool
    , name : String
    , nickname : String
    , picture : String
    , user_id : String
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
