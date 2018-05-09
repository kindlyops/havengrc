module Request.Comments exposing (get)

import Json.Decode as Decode
import Authentication
import Http
import Data.Comment exposing (decode)


commentsUrl : String
commentsUrl =
    "/api/comments"



--get : Authentication.Model -> Cmd Msg
--get : Authentication.Model -> C


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



--get : Authentication.Model -> Cmd Msg
--get authModel =
--    let
--        request =
--            Http.request
--                { method = "GET"
--                , headers = Authentication.tryGetAuthHeader authModel
--                , url = commentsUrl
--                , body = Http.emptyBody
--                , expect = Http.expectJson (Decode.list Data.Comment.decode)
--                , timeout = Nothing
--                , withCredentials = True
--                }
--    in
--        Http.send NewComments request
--post : Authentication.Model -> Comment -> Cmd Msg
--post authModel newComment =
--    let
--        body =
--            encodeComment newComment
--                |> Http.jsonBody
--        headers =
--            (Authentication.tryGetAuthHeader authModel) ++ Authentication.getReturnHeaders
--        _ =
--            Debug.log "postComment called with " newComment.message
--        request =
--            Http.request
--                { method = "POST"
--                , headers = headers
--                , url = commentsUrl
--                , body = body
--                , expect = Http.expectJson (Decode.list Data.Comment.decode)
--                , timeout = Nothing
--                , withCredentials = True
--                }
--    in
--        Http.send NewComment request
