-- module Page.Comments exposing (Model, Msg, init, update, view)


module Page.Comments exposing (Model, Msg(..), view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onWithOptions, on)
import Http
import Misc exposing (showDebugData)
import Comment.Types
import Authentication


-- TODO define Comments.Model, init and update


type alias Model =
    { comments : List Comment.Types.Comment
    , newComment : Comment.Types.Comment
    }


type Msg
    = SetCommentMessageInput String
    | AddComment Authentication.Model Model
    | GetComments Authentication.Model Model
    | NewComments (Result Http.Error (List Comment.Types.Comment))
    | NewComment (Result Http.Error (List Comment.Types.Comment))


type ExternalMsg
    = NoOp
    | ShowError String


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    div []
        [ text "This is the comments view"
        , ul []
            (List.map (\l -> li [] [ text (l.message ++ " - " ++ l.user_email ++ " posted at " ++ l.created_at) ]) model.comments)
        , commentsForm authModel model
        ]


commentsForm : Authentication.Model -> Model -> Html Msg
commentsForm authModel model =
    div
        [ id "Comments" ]
        [ div []
            [ div
                [ class "mdc-textfield"
                , attribute "data-mdc-auto-init" "MDCTextfield"
                ]
                [ input
                    [ class "mdc-textfield__input"
                    , onInput SetCommentMessageInput
                    , value model.newComment.message
                    ]
                    []
                , label [ class "mdc-textfield__label" ] [ text "Comment" ]
                ]
            ]
        , button
            [ class "mdc-button mdc-button--raised mdc-button--accent"
            , attribute "data-mdc-auto-init" "MDCRipple"
            , onClick (AddComment authModel model)
            ]
            [ text "Add" ]
        , showDebugData model.newComment
        ]
