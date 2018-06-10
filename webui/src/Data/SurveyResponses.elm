module Data.SurveyResponses exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


--TODO: rename this to server ipsative response


type alias GroupedIpsativeResponse =
    { survey_id : String
    , name : String
    , group_number : Int
    , category : String
    , sum : Int
    }


groupedIpsativeResponseDecoder : Decoder GroupedIpsativeResponse
groupedIpsativeResponseDecoder =
    decode GroupedIpsativeResponse
        |> required "survey_id" Decode.string
        |> required "name" Decode.string
        |> required "group_number" Decode.int
        |> required "category" Decode.string
        |> required "sum" Decode.int


type alias AvailableResponse =
    { name : String
    , data : List AvailableResponseDatum
    }


type alias AvailableResponseDatum =
    { group : Int
    , category : String
    , points : Int
    }


emptyAvailableResponse : AvailableResponse
emptyAvailableResponse =
    { name = "SCDS"
    , data =
        [ { group = 1
          , category = "Process"
          , points = 10
          }
        ]
    }
