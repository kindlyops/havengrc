port module HelloWorld exposing (elmToJS)

import Platform
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
        _=
            Debug.log("Test Get Data")
            Debug.log(toString allResponses)

    in
    allResponses


myVis : Spec
myVis =
    let
        _=
            -- Do something here with some data eventually!
            getData
        des =
            description "SCDS Assessment"

        data =
            dataFromColumns []
                << dataColumn "a" (strs [ "Org Values"
                , "Org Behaves"
                , "Definition"
                , "Information"
                , "Operations"
                , "Technology"
                , "People"
                , "Risk"
                , "Accountability"
                , "Performance"
                ])
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




{- The code below is boilerplate for creating a headless Elm module that opens
   an outgoing port to JavaScript and sends the Vega-Lite spec (myVis) to it.
-}


main : Program Never Spec msg
main =
    Platform.program
        { init = ( myVis, elmToJS myVis )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


port elmToJS : Spec -> Cmd msg
