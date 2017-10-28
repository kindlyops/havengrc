module Misc exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Types exposing (Model, Msg)


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


showDebugData : record -> Html Msg
showDebugData record =
    div [ class "debug" ] [ text ("DEBUG: " ++ toString record) ]
