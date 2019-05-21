module Data.Report exposing (Report, decode)

import Json.Decode as Decode exposing (Decoder, field, map4, string)


type alias Report =
    { uuid : String
    , created_at : String
    , user_id : String
    , name : String
    }


decode : Decoder Report
decode =
    map4 Report
        (field "uuid" string)
        (field "created_at" string)
        (field "user_id" string)
        (field "name" string)
