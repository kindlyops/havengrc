module Request.Reports exposing (download, downloadBytes, get)

import Authentication
import Bytes exposing (Bytes)
import Data.Report
import File.Download as Download
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
    let
        headers =
            Authentication.tryGetAuthHeader authModel
                ++ [ Http.header "Accept" "application/octet-stream" ]
    in
    Http.request
        { body = Http.emptyBody
        , expect = Http.expectJson (Decode.list Data.Report.decode)
        , headers = headers
        , method = "GET"
        , timeout = Nothing
        , url = "/api/files?select=file&uuid=eq." ++ report.uuid
        , withCredentials = True
        }


downloadBytes : Data.Report.Report -> Cmd msg
downloadBytes report =
    Download.url ("/api/files?select=file&uuid=eq." ++ report.uuid)
