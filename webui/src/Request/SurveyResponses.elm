module Request.SurveyResponses exposing (getIpsativeResponses)

import Http
import Json.Decode as Decode
import Authentication
import Data.SurveyResponses exposing (GroupedIpsativeResponse, groupedIpsativeResponseDecoder)


getIpsativeResponses : Authentication.Model -> Http.Request (List GroupedIpsativeResponse)
getIpsativeResponses authModel =
    Http.request
        { method = "GET"
        , headers = Authentication.tryGetAuthHeader authModel
        , url = "/api/ipsative_responses_grouped"
        , body = Http.emptyBody
        , expect = Http.expectJson (Decode.list groupedIpsativeResponseDecoder)
        , timeout = Nothing
        , withCredentials = True
        }
