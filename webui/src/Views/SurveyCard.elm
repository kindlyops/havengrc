module Views.SurveyCard exposing (view)

import Data.Survey exposing (SurveyMetaData)
import Html exposing (Html, button, div, h5, li, p, text, ul)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)


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
