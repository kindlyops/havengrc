module Request.Comments exposing (get, post)

import Authentication
import Data.Comment
import Http
import Json.Decode as Decode


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
            Authentication.tryGetAuthHeader authModel ++ Authentication.getReturnHeaders

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
