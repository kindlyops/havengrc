module Request.Comments exposing (get, post)

import Json.Decode as Decode
import Authentication
import Http
import Data.Comment exposing (decode, encode)


commentsUrl : String
commentsUrl =
    "/api/comments"


get : Authentication.Model -> Http.Request (List Data.Comment.Comment)
get authModel =
    Http.request
        { method = "GET"
        , headers = Authentication.tryGetAuthHeader authModel
        , url = commentsUrl
        , body = Http.emptyBody
        , expect = Http.expectJson (Decode.list Data.Comment.decode)
        , timeout = Nothing
        , withCredentials = True
        }


post : Authentication.Model -> Data.Comment.Comment -> Http.Request (List Data.Comment.Comment)
post authModel newComment =
    let
        body =
            Data.Comment.encode newComment
                |> Http.jsonBody

        headers =
            (Authentication.tryGetAuthHeader authModel) ++ Authentication.getReturnHeaders

        _ =
            Debug.log "postComment called with " newComment.message

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = commentsUrl
                , body = body
                , expect = Http.expectJson (Decode.list Data.Comment.decode)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request
