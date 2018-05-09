module Request.Survey exposing (..)

import Http
import Json.Decode as Decode
import Authentication
import Data.Survey


ipsativeUrl : String
ipsativeUrl =
    "/api/ipsative_surveys"


get : Authentication.Model -> Http.Request (List Data.Survey.IpsativeServerMetaData)
get authModel =
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
