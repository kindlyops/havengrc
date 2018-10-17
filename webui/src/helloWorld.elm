port module HelloWorld exposing (elmToJS)

import Platform
import VegaLite exposing (..)


myVis : Spec
myVis =
    let
        des =
            description "SCDS Assessment"

        data =
            dataFromColumns []
                << dataColumn "a" (strs [ "A", "B", "C" ])
                << dataColumn "b" (nums [ 28, 55, 43 ])
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
