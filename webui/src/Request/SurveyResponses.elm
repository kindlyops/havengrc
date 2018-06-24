module Request.SurveyResponses exposing (..)

import Http
import Json.Decode as Decode
import Authentication
import Data.SurveyResponses exposing (..)


getIpsativeResponses : Authentication.Model -> Http.Request (List GroupedIpsativeResponse)
getIpsativeResponses authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_responses_grouped"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list groupedIpsativeResponseDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request
