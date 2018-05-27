module Request.Survey exposing (..)

import Http
import Json.Decode as Decode
import Authentication
import Data.Survey


ipsativeUrl : String
ipsativeUrl =
    "/api/ipsative_surveys"


getIpsativeSurveys : Authentication.Model -> Http.Request (List Data.Survey.SurveyMetaData)
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
        request


getIpsativeSurvey : Authentication.Model -> String -> Http.Request (List Data.Survey.IpsativeServerData)
getIpsativeSurvey authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_data?survey_id=eq." ++ id
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.ipsativeSurveyDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


postIpsativeResponse : Authentication.Model -> Data.Survey.IpsativeSurvey -> Http.Request (List Data.Survey.IpsativeResponse)
postIpsativeResponse authModel ipsativeSurvey =
    let
        body =
            Data.Survey.ipsativeResponseEncoder ipsativeSurvey
                |> Http.jsonBody

        headers =
            (Authentication.tryGetAuthHeader authModel) ++ Authentication.getReturnHeaders

        --_ =
        --Debug.log "Ipsative Response: " newComment.message
        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = "api/ipsative_responses"
                , body = body
                , expect = Http.expectJson (Decode.list Data.Survey.ipsativeResponseDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getLikertSurveys : Authentication.Model -> Http.Request (List Data.Survey.SurveyMetaData)
getLikertSurveys authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/likert_surveys"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.likertMetaDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getLikertSurvey : Authentication.Model -> String -> Http.Request (List Data.Survey.LikertServerData)
getLikertSurvey authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/likert_data?survey_id=eq." ++ id
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.likertSurveyDataDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request


getLikertChoices : Authentication.Model -> String -> Http.Request (List Data.Survey.LikertServerChoice)
getLikertChoices authModel id =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/likert_distinct_choice_groups?survey_id=eq." ++ id
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.likertSurveyChoicesDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        request



--postLikertResponse : Authentication.Model -> Data.Survey.LikertSurvey -> Http.Request (List Data.Survey.LikertResponse)
--postLikertResponse authModel likertSurvey =
--    let
--        body =
--            Data.Survey.likertResponseEncoder likertSurvey
--                |> Http.jsonBody
--        headers =
--            (Authentication.tryGetAuthHeader authModel) ++ Authentication.getReturnHeaders
--        --_ =
--        --Debug.log "Likert Response: " newComment.message
--        request =
--            Http.request
--                { method = "POST"
--                , headers = headers
--                , url = "api/likert_responses"
--                , body = body
--                , expect = Http.expectJson (Decode.list Data.Survey.likertResponseDecoder)
--                , timeout = Nothing
--                , withCredentials = True
--                }
--    in
--        request
