port module Ports exposing
    ( keycloakAuthResult
    , keycloakLogin
    , keycloakLogout
    , radarChart
    , renderAnimation
    , renderVega
    , saveSurveyState
    , setTitle
    , showError
    )

import Data.RadarChart exposing (RadarChartConfig)
import Json.Encode exposing (Value)
import Keycloak exposing (Options, RawAuthenticationResult)
import VegaLite exposing (Spec)


port keycloakAuthResult : (RawAuthenticationResult -> msg) -> Sub msg


port keycloakLogin : Options -> Cmd msg


port keycloakLogout : () -> Cmd msg


port setTitle : String -> Cmd msg


port showError : String -> Cmd msg


port radarChart : RadarChartConfig -> Cmd msg


port saveSurveyState : Maybe Value -> Cmd msg


port renderVega : Spec -> Cmd msg


port renderAnimation : () -> Cmd msg
