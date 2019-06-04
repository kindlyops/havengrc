port module Ports exposing
    ( radarChart
    , renderVega
    , saveSurveyState
    )

import Data.RadarChart exposing (RadarChartConfig)
import Json.Encode exposing (Value)
import VegaLite exposing (Spec)


port radarChart : RadarChartConfig -> Cmd msg


port saveSurveyState : Maybe Value -> Cmd msg


port renderVega : List Spec -> Cmd msg
