port module Ports exposing (..)

import Keycloak exposing (Options, RawAuthenticationResult)


port keycloakShowLock : Options -> Cmd msg


port keycloakAuthResult : (RawAuthenticationResult -> msg) -> Sub msg


port keycloakLogout : () -> Cmd msg


port setTitle : String -> Cmd msg
