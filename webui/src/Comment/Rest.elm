module Comment.Rest exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode
import Keycloak
import Comment.Types exposing (..)
import Page.Comments
import Authentication


commentDecoder : Decoder Comment
commentDecoder =
    Decode.map5 Comment
        (field "uuid" Decode.string)
        (field "created_at" Decode.string)
        (field "user_email" Decode.string)
        (field "user_id" Decode.string)
        (field "message" Decode.string)


encodeComment : Comment -> Encode.Value
encodeComment comment =
    Encode.object
        [ ( "message", Encode.string comment.message ) ]


commentsUrl : String
commentsUrl =
    "/api/comments"


getComments : Page.Comments.Model -> Cmd Page.Comments.Msg
getComments model =
    let
        request =
            Http.request
                { method = "GET"
                , headers = tryGetAuthHeader model
                , url = commentsUrl
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list commentDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send Page.Comments.NewComments request


tryGetAuthHeader : Authentication.Model -> List Http.Header
tryGetAuthHeader model =
    case model.authModel.state of
        Keycloak.LoggedIn user ->
            [ (Http.header "Authorization" ("Bearer " ++ user.token)) ]

        Keycloak.LoggedOut ->
            let
                _ =
                    Debug.log "didn't get a user token" ""
            in
                []


getReturnHeaders : List Http.Header
getReturnHeaders =
    [ (Http.header "Prefer" "return=representation") ]


postComment : Page.Comments.Model -> Cmd Page.Comments.Msg
postComment model =
    let
        body =
            encodeComment model.newComment
                |> Http.jsonBody

        headers =
            (tryGetAuthHeader model) ++ getReturnHeaders

        _ =
            Debug.log "postComment called with " model.newComment.message

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = commentsUrl
                , body = body
                , expect = Http.expectJson (Decode.list commentDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send Page.Comments.NewComment request
