module Comment.Rest exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode
import Keycloak
import Comment.Types exposing (..)
import Types exposing (..)


commentDecoder : Decoder Comment
commentDecoder =
    Decode.map4 Comment
        (field "uuid" Decode.string)
        (field "created_at" Decode.string)
        (field "user_email" Decode.string)
        (field "message" Decode.string)


encodeComment : Comment -> Encode.Value
encodeComment comment =
    Encode.object
        [ ( "message", Encode.string comment.message ) ]


commentsUrl : String
commentsUrl =
    "http://localhost:3001/comment"


getComments : Model -> Cmd Msg
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
        Http.send NewComments request


tryGetAuthHeader : Model -> List Http.Header
tryGetAuthHeader model =
    case model.authModel.state of
        Keycloak.LoggedIn user ->
            let
                _ =
                    Debug.log "user token is: " user.token
            in
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


postComment : Model -> Cmd Msg
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
        Http.send NewComment request
