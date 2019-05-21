module Request.Reports exposing (download, get)

import Authentication
import Data.Report
import Http
import Json.Decode as Decode


type Msg
    = Downloaded (Result Http.Error ())


reportsUrl : String
reportsUrl =
    "/api/files"


get : Authentication.Model -> Http.Request (List Data.Report.Report)
get authModel =
    Http.request
        { method = "GET"
        , headers = Authentication.tryGetAuthHeader authModel
        , url = reportsUrl
        , body = Http.emptyBody
        , expect = Http.expectJson (Decode.list Data.Report.decode)
        , timeout = Nothing
        , withCredentials = True
        }


download : Authentication.Model -> Data.Report.Report -> Http.Request (List Data.Report.Report)
download authModel report =
    Http.request
        { body = Http.emptyBody
        , expect = Http.expectJson (Decode.list Data.Report.decode)
        , headers = Authentication.tryGetAuthHeader authModel
        , method = "GET"
        , timeout = Nothing
        , url = "/api/files?select=file&uuid=eq." ++ report.uuid
        , withCredentials = True
        }
