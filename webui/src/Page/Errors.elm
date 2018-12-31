module Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)

import Html exposing (Html, div, text)
import Html.Attributes exposing (classList, id)


type alias ErrorData =
    { errorVisible : Bool
    , errorMessage : String
    }


errorInit : ErrorData
errorInit =
    { errorVisible = False
    , errorMessage = ""
    }


setErrorMessage : ErrorData -> String -> ErrorData
setErrorMessage model errMsg =
    { model | errorVisible = True, errorMessage = errMsg }


viewError : ErrorData -> Html msg
viewError model =
    div
        [ id "snackbar"
        , classList
            [ ( "snackbar", True )
            , ( "show", model.errorVisible )
            ]
        ]
        [ div
            [ id "snackbar-body"
            , classList
                [ ( "snackbar-body", True )
                , ( "show", model.errorVisible )
                ]
            ]
            [ text model.errorMessage ]
        ]
