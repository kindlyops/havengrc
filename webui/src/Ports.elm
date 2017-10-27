port module Ports exposing (..)

import Keycloak exposing (Options, RawAuthenticationResult)


port keycloakAuthResult : (RawAuthenticationResult -> msg) -> Sub msg


port keycloakLogin : Options -> Cmd msg


port keycloakLogout : () -> Cmd msg


port setTitle : String -> Cmd msg


port showError : String -> Cmd msg
