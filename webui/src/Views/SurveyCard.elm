module Views.SurveyCard exposing (view)

import Data.Survey exposing (SurveyMetaData)
import Html exposing (Html, button, div, h5, li, p, text, ul, h1, text, span)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)


view : SurveyMetaData -> String -> msg -> Html msg
view metaData title msg =
    div [ class "col-12 text-center mt-5" ]
        [ h1 [ class "survey-heading" ]
            [ text "An organizational "
            , span [class "text-secondary"] [ text "security" ]
            , text " profile in five minutes"
            ]
        , div [ class "px-5 py-3" ]
            [ p [ class "" ] [ text ("This brief " ++ metaData.description ++ " " ++ metaData.instructions) ]
            ]
        , button [ class "btn btn-primary login-btn btn-block mx-auto", onClick msg ] [ text "I'm Ready" ]
        ]
