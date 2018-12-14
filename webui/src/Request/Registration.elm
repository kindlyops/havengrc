module Request.Registration exposing (post)

import Authentication
import Data.Registration as Registration exposing (Registration)
import Data.Survey exposing (Model)
import Http


registrationUrl : String
registrationUrl =
    "/api/registration_funnel"


post : Data.Survey.IpsativeSurvey -> String -> Authentication.Model -> Http.Request String
post surveyModel emailAddress authModel =
    let
        responses =
            Data.Survey.ipsativeResponseEncoder surveyModel
                |> Http.jsonBody

        registration =
            Registration emailAddress responses

        body =
            Registration.encode registration surveyModel
                |> Http.jsonBody

        _ =
            Debug.log "post new registration called with " emailAddress

        headers =
            Authentication.tryGetAuthHeader authModel ++ Authentication.getReturnHeaders

        request =
            Http.request
                { method = "POST"
                , url = registrationUrl
                , headers = headers
                , body = body
                , timeout = Nothing
                , expect = Http.expectString
                , withCredentials = False
                }
    in
    request
