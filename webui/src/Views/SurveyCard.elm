module Views.SurveyCard exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Data.Survey exposing (IpsativeServerMetaData)


view : IpsativeServerMetaData -> msg -> Html msg
view metaData msg =
    div [ class "card" ]
        [ div [ class "card-header" ] [ text "Likert" ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text metaData.name
                ]
            , p [ class "card-text" ] [ text metaData.description ]
            ]
        , ul [ class "list-group list-group-flush" ]
            [ li [ class "list-group-item" ] [ text ("Last Updated: " ++ metaData.updated_at) ]
            , li [ class "list-group-item" ] [ text ("Created By: " ++ metaData.author) ]
            , li [ class "list-group-item" ] [ button [ class "btn btn-primary", onClick msg ] [ text "Click to start survey" ] ]
            ]
        ]
