port module Ports exposing (..)

import Keycloak exposing (Options, RawAuthenticationResult)
import Data.RadarChart exposing (RadarChartConfig)


port keycloakAuthResult : (RawAuthenticationResult -> msg) -> Sub msg


port keycloakLogin : Options -> Cmd msg


port keycloakLogout : () -> Cmd msg


port setTitle : String -> Cmd msg


port showError : String -> Cmd msg


port radarChart : RadarChartConfig -> Cmd msg
