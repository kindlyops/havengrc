module Visualization exposing (compliance, havenSpecs)

import Data.Survey
import Vega
import VegaLite exposing (..)


getData : Data.Survey.Model -> List Data.Survey.IpsativeSingleResponse
getData model =
    let
        allResponses =
            case model.currentSurvey of
                Data.Survey.Ipsative survey ->
                    Data.Survey.getAllResponsesFromIpsativeSurvey survey

                Data.Survey.Likert survey ->
                    []
    in
    allResponses


compliance : Spec
compliance =
    let
        responses =
            -- Do something here with some data eventually!
            getData

        des =
            description "SCDS Assessment"

        data =
            dataFromColumns []
                << dataColumn "Compliance"
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
                << position Y [ pName "Compliance", pMType Ordinal ]

        specBar =
            asSpec [ bar [] ]

        specText =
            asSpec [ textMark [ maStyle [ "label" ] ], encoding (text [ tName "b", tMType Quantitative ] []) ]

        config =
            configure << configuration (coNamedStyle "label" [ maAlign haLeft, maBaseline vaMiddle, maDx 3 ])
    in
    toVegaLite [ des, data [], enc [], layer [ specBar, specText ], config [] ]


process : Spec
process =
    let
        responses =
            -- Do something here with some data eventually!
            getData

        des =
            description "SCDS Assessment"

        data =
            dataFromColumns []
                << dataColumn "Process"
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
                << dataColumn "d" (nums [ 1, 1, 1 ])

        enc =
            encoding
                << position X [ pName "d", pMType Quantitative ]
                << position Y [ pName "Process", pMType Ordinal ]

        specBar =
            asSpec [ bar [] ]

        specText =
            asSpec [ textMark [ maStyle [ "label" ] ], encoding (text [ tName "d", tMType Quantitative ] []) ]

        config =
            configure << configuration (coNamedStyle "label" [ maAlign haLeft, maBaseline vaMiddle, maDx 3 ])
    in
    toVegaLite [ des, data [], enc [], layer [ specBar, specText ], config [] ]


havenSpecs : List Spec
havenSpecs =
    [ compliance, process ]
