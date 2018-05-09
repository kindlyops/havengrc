module Page.Comments exposing (Model, Msg, init, update, view)

import Data.Comment exposing (Comment, emptyNewComment)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Authentication exposing (..)
import Http
import Request.Comments exposing (get)


type alias Model =
    { comments : List Comment
    , newComment : Comment
    }


type Msg
    = GetComments Model
    | AddComment Authentication.Model Comment
    | NewComments (Result Http.Error (List Comment))
    | NewComment (Result Http.Error (List Comment))
    | SetCommentMessageInput String


init : Model
init =
    { comments = []
    , newComment = emptyNewComment
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetComments model ->
            model ! []

        AddComment authModel comment ->
            model ! []

        NewComments (Ok comment) ->
            model ! []

        NewComments (Err error) ->
            model ! []

        NewComment (Ok comment) ->
            model ! []

        NewComment (Err error) ->
            model ! []

        SetCommentMessageInput string ->
            model ! []


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    div []
        [ text "This is the comments view"
        , ul []
            (List.map (\l -> li [] [ text (l.message ++ " - " ++ l.user_email ++ "(" ++ l.user_id ++ ")" ++ " posted at " ++ l.created_at) ]) model.comments)
        , commentsForm authModel model.newComment
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
            [ class "btn btn-primary"
            , onClick (AddComment authModel newComment)
            ]
            [ text "Add" ]
        , showDebugData newComment
        ]


showDebugData : record -> Html Msg
showDebugData record =
    div [ class "debug" ] [ text ("DEBUG: " ++ toString record) ]
