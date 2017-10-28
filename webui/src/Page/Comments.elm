-- module Page.Comments exposing (Model, Msg, init, update, view)


module Page.Comments exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onWithOptions, on)
import Misc exposing (showDebugData)
import Types exposing (Model, Msg)


view : Model -> Html Msg
view model =
    div []
        [ text "This is the comments view"
        , ul []
            (List.map (\l -> li [] [ text (l.message ++ " - " ++ l.user_email ++ " posted at " ++ l.created_at) ]) model.comments)
        , commentsForm model
        ]


commentsForm : Model -> Html Msg
commentsForm model =
    div
        [ id "Comments" ]
        [ div []
            [ div
                [ class "mdc-textfield"
                , attribute "data-mdc-auto-init" "MDCTextfield"
                ]
                [ input
                    [ class "mdc-textfield__input"
                    , onInput Types.SetCommentMessageInput
                    , value model.newComment.message
                    ]
                    []
                , label [ class "mdc-textfield__label" ] [ text "Comment" ]
                ]
            ]
        , button
            [ class "mdc-button mdc-button--raised mdc-button--accent"
            , attribute "data-mdc-auto-init" "MDCRipple"
            , onClick (Types.AddComment model)
            ]
            [ text "Add" ]
        , showDebugData model.newComment
        ]
