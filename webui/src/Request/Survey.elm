module Request.Survey exposing (..)

import Http
import Json.Decode as Decode
import Authentication
import Data.Survey


ipsativeUrl : String
ipsativeUrl =
    "/api/ipsative_surveys"


get : Authentication.Model -> Cmd Msg
get authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_surveys"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.field Data.Survey.decoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send GotIpsative request
