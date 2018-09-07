module Request.Survey
    exposing
        ( getIpsativeSurveys
        , getLikertSurveys
        , postIpsativeResponse
        , postLikertResponses
        , getLikertChoices
        , getLikertSurvey
        , getIpsativeSurvey
        )

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Authentication
import Ports
import Data.Survey as Survey exposing (Survey)


getIpsativeSurveys : Authentication.Model -> Http.Request (List Survey.SurveyMetaData)
getIpsativeSurveys authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_surveys"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Survey.decodeSurveyMetaData)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getIpsativeSurvey : Authentication.Model -> String -> Http.Request (List Survey.IpsativeServerData)
getIpsativeSurvey authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_data?survey_id=eq." ++ id
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Survey.ipsativeSurveyDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


postIpsativeResponse : Authentication.Model -> Survey.IpsativeSurvey -> Http.Request (List Survey.IpsativeResponse)
postIpsativeResponse authModel ipsativeSurvey =
    let
        body =
            Survey.ipsativeResponseEncoder ipsativeSurvey
                |> Http.jsonBody

        headers =
            Authentication.tryGetAuthHeader authModel ++ Authentication.getReturnHeaders

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = "api/ipsative_responses"
                , body = body
                , expect = Http.expectJson (Decode.list Survey.ipsativeResponseDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getLikertSurveys : Authentication.Model -> Http.Request (List Survey.SurveyMetaData)
getLikertSurveys authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/likert_surveys"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Survey.decodeSurveyMetaData)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getLikertSurvey : Authentication.Model -> String -> Http.Request (List Survey.LikertServerData)
getLikertSurvey authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/likert_data?survey_id=eq." ++ id
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Survey.likertSurveyDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getLikertChoices : Authentication.Model -> String -> Http.Request (List Survey.LikertServerChoice)
getLikertChoices authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/likert_distinct_choice_groups?survey_id=eq." ++ id
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Survey.likertSurveyChoicesDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


postLikertResponses : Authentication.Model -> Survey.LikertSurvey -> Http.Request (List Survey.LikertResponse)
postLikertResponses authModel likertSurvey =
    let
        body =
            Survey.likertResponseEncoder likertSurvey
                |> Http.jsonBody

        headers =
            Authentication.tryGetAuthHeader authModel ++ Authentication.getReturnHeaders

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = "api/likert_responses"
                , body = body
                , expect = Http.expectJson (Decode.list Survey.likertResponseDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request
