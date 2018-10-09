module Data.Registration exposing (Registration, decode, encode)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Json.Decode.Pipeline exposing (decode, required)


type alias Registration =
    { email : String
    , survey_results : String
    }



decode : Decoder Registration
decode =
    Json.Decode.Pipeline.decode Registration
        |> required "email" Decode.string
        |> required "survey_results" Decode.string


encode : Registration -> Value
encode record =
    Encode.object
        [ ( "email", Encode.string <| record.email )
         ,( "survey_results", Encode.string <| record.survey_results )
        ]
