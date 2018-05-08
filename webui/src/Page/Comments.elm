-- module Page.Comments exposing (Model, Msg, init, update, view)


module Page.Comments exposing (view, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onWithOptions, on)
import Http
import Misc exposing (showDebugData, getHTTPErrorMessage)
import Keycloak
import Comment.Types exposing (..)
import Comment.Rest
import Ports


type ExternalMsg
    = NoOp
    | ShowError String


update : Msg -> Keycloak.UserProfile -> Comment.Types.Model -> ( Comment.Types.Model, Cmd Msg )
update msg user model =
    case msg of
        SetCommentMessageInput value ->
            let
                oldComment =
                    model.newComment

                updatedComment =
                    { oldComment | message = value }
            in
                ( { model | newComment = updatedComment }, Cmd.none )

        AddComment model ->
            model ! [ Comment.Rest.postComment user model ]

        GetComments model ->
            model ! [ Comment.Rest.getComments user ]

        NewComment (Ok comment) ->
            let
                morecomments =
                    model.comments ++ comment
            in
                -- TODO we need a more sophisticated way to deal with loading
                -- paginated data and not re-fetching data we already have
                { model | newComment = Comment.Types.emptyNewComment, comments = morecomments } ! []

        NewComment (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        NewComments (Ok comments) ->
            { model | comments = comments } ! []

        NewComments (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]


renderComment : Comment.Types.Comment -> Html msg
renderComment c =
    let
        m = 
            c.message ++ " - " ++ c.user_email ++ " posted at " ++ c.created_at
    in
        li [] [ text m ]


view : Comment.Types.Model -> Keycloak.UserProfile -> Html Msg
view model user =
    div []
        [ text "This is the comments view"
        , ul []
            (List.map renderComment model.comments)
        , commentsForm model user
        ]


commentsForm : Comment.Types.Model -> Keycloak.UserProfile -> Html Msg
commentsForm model user =
    div
        [ id "Comments" ]
        [ div []
            [ div
                [ class "mdc-textfield"
                , attribute "data-mdc-auto-init" "MDCTextfield"
                ]
                [ input
                    [ class "mdc-textfield__input"
                    , onInput Comment.Types.SetCommentMessageInput
                    , value model.newComment.message
                    ]
                    []
                , label [ class "mdc-textfield__label" ] [ text "Comment" ]
                ]
            ]
        , button
            [ class "mdc-button mdc-button--raised mdc-button--accent"
            , attribute "data-mdc-auto-init" "MDCRipple"
            , onClick (Comment.Types.AddComment model)
            ]
            [ text "Add" ]
        , showDebugData model.newComment
        ]
