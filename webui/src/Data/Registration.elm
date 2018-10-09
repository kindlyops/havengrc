module Data.Registration exposing (Registration, encode)

import Data.Survey
import Json.Encode as Encode exposing (Value)
import Http

type alias Registration =
    { email : String
    , survey_results : Http.Body
    }



encode : Registration -> Data.Survey.IpsativeSurvey -> Value
encode record survey =
    let
        allResponses =
            Data.Survey.getAllResponsesFromIpsativeSurvey survey
        results = Encode.list
            (List.map
                (\x ->
                    Data.Survey.ipsativeSingleResponseEncoder x
                )
                allResponses
            )
    in
    Encode.object
        [ ( "email", Encode.string <| record.email )
         ,( "survey_results", results )
        ]

