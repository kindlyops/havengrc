module Regulation.Rest exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Regulation.Types exposing (..)
import Types exposing (..)


regulationDecoder : Decoder Regulation
regulationDecoder =
    Decode.map4 Regulation
        (field "id" Decode.int)
        (field "identifier" Decode.string)
        (field "uri" Decode.string)
        (field "description" Decode.string)


regulationsUrl : String
regulationsUrl =
    "http://localhost:3001/regulation"


getRegulations : Cmd Msg
getRegulations =
    let
        _ =
            Debug.log "getRegulations called"
    in
        (Decode.list regulationDecoder)
            |> Http.get regulationsUrl
            |> Http.send NewRegulations
