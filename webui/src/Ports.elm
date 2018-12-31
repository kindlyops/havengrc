port module Ports exposing
    ( keycloakAuthResult
    , keycloakLogin
    , keycloakLogout
    , radarChart
    , renderVega
    , saveSurveyState
    )

import Data.RadarChart exposing (RadarChartConfig)
import Json.Encode exposing (Value)
import Keycloak exposing (Options, RawAuthenticationResult)
import VegaLite exposing (Spec)


port keycloakAuthResult : (RawAuthenticationResult -> msg) -> Sub msg


port keycloakLogin : Options -> Cmd msg


port keycloakLogout : () -> Cmd msg


port radarChart : RadarChartConfig -> Cmd msg


port saveSurveyState : Maybe Value -> Cmd msg


port renderVega : Spec -> Cmd msg
