module Visualization exposing (myVis)

import VegaLite exposing (..)
import Data.Survey


getData : Data.Survey.Model -> List Data.Survey.IpsativeSingleResponse
getData model =
    let
        allResponses =
            case model.currentSurvey of
                Data.Survey.Ipsative survey ->
                    Data.Survey.getAllResponsesFromIpsativeSurvey survey

                Data.Survey.Likert survey ->
                    []

        _ =
            Debug.log ("Test Get Data")
                Debug.log
                (toString allResponses)
    in
        allResponses


myVis : Spec
myVis =
    let
        _ =
            -- Do something here with some data eventually!
            getData

        des =
            description "SCDS Assessment"

        data =
            dataFromColumns []
                << dataColumn "a"
                    (strs
                        [ "Org Values"
                        , "Org Behaves"
                        , "Definition"
                        , "Information"
                        , "Operations"
                        , "Technology"
                        , "People"
                        , "Risk"
                        , "Accountability"
                        , "Performance"
                        ]
                    )
                << dataColumn "b" (nums [ 5, 4, 8 ])

        enc =
            encoding
                << position X [ pName "b", pMType Quantitative ]
                << position Y [ pName "a", pMType Ordinal ]

        specBar =
            asSpec [ bar [] ]

        specText =
            asSpec [ textMark [ maStyle [ "label" ] ], encoding (text [ tName "b", tMType Quantitative ] []) ]

        config =
            configure << configuration (coNamedStyle "label" [ maAlign AlignLeft, maBaseline AlignMiddle, maDx 3 ])
    in
        toVegaLite [ des, data [], enc [], layer [ specBar, specText ], config [] ]
