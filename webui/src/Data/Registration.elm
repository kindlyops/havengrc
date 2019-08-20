module Data.Registration exposing (Registration, encode)

import Data.Survey
import Http
import Json.Encode as Encode exposing (Value)


type alias Registration =
    { email : String
    , survey_results : Http.Body
    , survey_id : String
    }


encode : Registration -> Data.Survey.IpsativeSurvey -> Value
encode record survey =
    let
        allResponses =
            Data.Survey.getAllResponsesFromIpsativeSurvey survey

        results =
            Encode.list
                (\x ->
                    Data.Survey.ipsativeSingleResponseEncoder x
                )
                allResponses

        surveyID =
            Data.Survey.metaDataResponseEncoder survey
    in
    Encode.object
        [ ( "email", Encode.string <| record.email )
        , ( "survey_results", results )
        , ( "survey_id", surveyID )
        ]
