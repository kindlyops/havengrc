module Page.Comments exposing (Model, Msg, init, update, view)

import Authentication
import Data.Comment exposing (Comment, emptyNewComment)
import Html exposing (Html, button, div, input, label, li, text, ul)
import Html.Attributes exposing (attribute, class, id)
import Html.Events exposing (onClick, onInput)
import Http
import Ports
import Request.Comments
import Utils exposing (getHTTPErrorMessage)


type alias Model =
    { comments : List Comment
    , newComment : Comment
    }


type Msg
    = GetComments
    | AddComment Authentication.Model Comment
    | GotComments (Result Http.Error (List Comment))
    | NewComment (Result Http.Error (List Comment))
    | SetCommentMessageInput String


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    ( { comments = []
      , newComment = emptyNewComment
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

        AddComment authModel comment ->
            ( model
            , Http.send NewComment (Request.Comments.post authModel comment)
            )

        GotComments (Ok comments) ->
            ( { model | comments = comments }
            , Cmd.none
            )

        GotComments (Err error) ->
            ( model
            , Ports.showError (getHTTPErrorMessage error)
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
            ( model
            , Ports.showError (getHTTPErrorMessage error)
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


showDebugData : record -> Html Msg
showDebugData record =
    div [ class "debug" ] [ text ("DEBUG: " ++ toString record) ]
