module Page.Comments exposing (Model, Msg, init, update, view)

import Authentication
import Data.Comment exposing (Comment, emptyNewComment)
import Html exposing (Html, button, div, input, label, li, text, ul)
import Html.Attributes exposing (attribute, class, id)
import Html.Events exposing (onClick, onInput)
import Http
import Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)
import Ports
import Process
import Request.Comments
import Task
import Utils exposing (getHTTPErrorMessage)


type alias Model =
    { comments : List Comment
    , newComment : Comment
    , errorModel : ErrorData
    }


type Msg
    = GetComments
    | AddComment Authentication.Model Comment
    | GotComments (Result Http.Error (List Comment))
    | NewComment (Result Http.Error (List Comment))
    | SetCommentMessageInput String
    | HideError


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    ( { comments = []
      , newComment = emptyNewComment
      , errorModel = errorInit
      }
    , Cmd.batch (initialCommands authModel)
    )


initialCommands : Authentication.Model -> List (Cmd Msg)
initialCommands authModel =
    if Authentication.isLoggedIn authModel then
        [ Http.send GotComments (Request.Comments.get authModel) ]

    else
        []


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        GetComments ->
            ( model
            , Http.send GotComments (Request.Comments.get authModel)
            )

        AddComment aM comment ->
            ( model
            , Http.send NewComment (Request.Comments.post aM comment)
            )

        HideError ->
            ( { model | errorModel = errorInit }, Cmd.none )

        GotComments (Ok comments) ->
            ( { model | comments = comments }
            , Cmd.none
            )

        GotComments (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        NewComment (Ok comment) ->
            let
                updatedComments =
                    model.comments ++ comment
            in
            ( { model | newComment = emptyNewComment, comments = updatedComments }
            , Cmd.none
            )

        NewComment (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        SetCommentMessageInput string ->
            let
                oldComment =
                    model.newComment

                updatedComment =
                    { oldComment | message = string }
            in
            ( { model | newComment = updatedComment }
            , Cmd.none
            )


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    div []
        [ text "This is the comments view"
        , ul []
            (List.map (\l -> li [] [ text (l.message ++ " - " ++ l.user_email ++ "(" ++ l.user_id ++ ")" ++ " posted at " ++ l.created_at) ]) model.comments)
        , commentsForm authModel model.newComment
        , div [ class "row" ]
            [ button [ class "btn btn-secondary", onClick GetComments ] [ text "get comments" ]
            ]
        , viewError model.errorModel
        ]


commentsForm : Authentication.Model -> Comment -> Html Msg
commentsForm authModel newComment =
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
                    , Html.Attributes.value newComment.message
                    ]
                    []
                , label [ class "mdc-textfield__label" ] [ text "Comment" ]
                ]
            ]
        , button
            [ class "btn btn-secondary"
            , onClick (AddComment authModel newComment)
            ]
            [ text "Add" ]
        , showDebugData newComment
        ]


commentToString : Comment -> String
commentToString comment =
    "{ "
        ++ comment.uuid
        ++ ", "
        ++ comment.created_at
        ++ ", "
        ++ comment.user_email
        ++ ", "
        ++ comment.user_id
        ++ ", "
        ++ comment.message
        ++ " }"


showDebugData : Comment -> Html Msg
showDebugData comment =
    div [ class "debug" ]
        [ text ("DEBUG: " ++ commentToString comment) ]
