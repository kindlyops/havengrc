module Data.SurveyResponses exposing
    ( AvailableResponse
    , AvailableResponseDatum
    , GroupedIpsativeResponse
    , groupedIpsativeResponseDecoder
    )

import Json.Decode as Decode exposing (Decoder, field, int, map5, string)



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
    map5 GroupedIpsativeResponse
        (field "survey_id" string)
        (field "name" string)
        (field "group_number" int)
        (field "category" string)
        (field "sum" int)


type alias AvailableResponse =
    { name : String
    , data : List AvailableResponseDatum
    }


type alias AvailableResponseDatum =
    { group : Int
    , category : String
    , points : Int
    }
