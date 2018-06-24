module Views.SurveyCard exposing (view)

import Html exposing (Html, div, h5, p, text, ul, button, li)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Data.Survey exposing (SurveyMetaData)


view : SurveyMetaData -> String -> msg -> Html msg
view metaData title msg =
    div [ class "card" ]
        [ div [ class "card-header" ] [ text title ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text metaData.name
                ]
            , p [ class "card-text" ] [ text metaData.description ]
            ]
        , ul [ class "list-group list-group-flush" ]
            [ li [ class "list-group-item" ] [ text ("Created: " ++ metaData.created_at) ]
            , li [ class "list-group-item" ] [ text ("Created By: " ++ metaData.author) ]
            , li [ class "list-group-item" ] [ button [ class "btn btn-primary", onClick msg ] [ text "Click to start survey" ] ]
            ]
        ]
