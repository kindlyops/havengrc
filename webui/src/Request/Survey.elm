module Request.Survey exposing (..)

import Http
import Json.Decode as Decode
import Authentication
import Data.Survey


ipsativeUrl : String
ipsativeUrl =
    "/api/ipsative_surveys"


getIpsativeSurveys : Authentication.Model -> Http.Request (List Data.Survey.IpsativeMetaData)
getIpsativeSurveys authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_surveys"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.ipsativeMetaDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        --Http.send GotIpsative request
        request


getIpsativeSurvey : Authentication.Model -> Int -> Http.Request (List Data.Survey.IpsativeServerData)
getIpsativeSurvey authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_data?survey_id=eq." ++ (toString id)
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.ipsativeSurveyDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        --Http.send GotIpsative request
        request
