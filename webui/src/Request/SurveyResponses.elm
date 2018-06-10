module Request.SurveyResponses exposing (..)

import Http
import Json.Decode as Decode
import Authentication
import Data.SurveyResponses exposing (..)


ipsativeUrl : String
ipsativeUrl =
    ""


getIpsativeResponses : Authentication.Model -> Http.Request (List GroupedIpsativeResponse)
getIpsativeResponses authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = ipsativeUrl
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list groupedIpsativeResponseDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request
