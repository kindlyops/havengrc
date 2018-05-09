module Views.SurveyCard exposing (view)


view : LikertSurvey -> Html Msg
view survey =
    div [ class "card" ]
        [ div [ class "card-header" ] [ text "Likert" ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text survey.metaData.name
                ]
            , p [ class "card-text" ] [ text survey.metaData.description ]
            ]
        , ul [ class "list-group list-group-flush" ]
            [ li [ class "list-group-item" ] [ text ("Last Updated: " ++ survey.metaData.lastUpdated) ]
            , li [ class "list-group-item" ] [ text ("Created By: " ++ survey.metaData.createdBy) ]
            , li [ class "list-group-item" ] [ button [ class "btn btn-primary", onClick BeginLikertSurvey ] [ text "Click to start survey" ] ]
            ]
        ]
