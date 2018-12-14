module Request.SurveyResponses exposing (getIpsativeResponses)

import Authentication
import Data.SurveyResponses exposing (GroupedIpsativeResponse, groupedIpsativeResponseDecoder)
import Http
import Json.Decode as Decode


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
