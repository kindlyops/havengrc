module Comment.Rest exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode
import Keycloak
import Comment.Types exposing (..)
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


getComments : Keycloak.UserProfile -> Cmd Comment.Types.Msg
getComments user =
    let
        request =
            Http.request
                { method = "GET"
                , headers = tryGetAuthHeader user
                , url = commentsUrl
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list commentDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send Comment.Types.NewComments request


tryGetAuthHeader : Keycloak.UserProfile -> List Http.Header
tryGetAuthHeader user =
    [ (Http.header "Authorization" ("Bearer " ++ user.token)) ]


getReturnHeaders : List Http.Header
getReturnHeaders =
    [ (Http.header "Prefer" "return=representation") ]


postComment : Keycloak.UserProfile -> Comment.Types.Model -> Cmd Comment.Types.Msg
postComment user model =
    let
        body =
            encodeComment model.newComment
                |> Http.jsonBody

        headers =
            (tryGetAuthHeader user) ++ getReturnHeaders

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
        Http.send Comment.Types.NewComment request
