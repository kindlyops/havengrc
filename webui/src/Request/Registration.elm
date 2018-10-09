module Request.Registration exposing (post)

import Json.Decode as Decode
import Data.Registration as Registration exposing (Registration)
import Authentication
import Http


registrationUrl : String
registrationUrl =
    "/api/registration_funnel"


post : Authentication.Model -> Http.Request (List Registration.Registration)
post authModel newRegistration =
    let
        body =
            Registration.encode newRegistration
                |> Http.jsonBody
        headers =
            Authentication.tryGetAuthHeader authModel ++ Authentication.getReturnHeaders

        _ =
            Debug.log "post new registration called with " newRegistration.email

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = registrationUrl
                , body = body
                , timeout = Nothing
                , expect = Http.expectJson (Decode.list Registration.decode )
                , withCredentials = False
                }
    in
        request
