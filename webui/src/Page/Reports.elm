module Page.Reports exposing (Model, Msg, init, update, view)

import Authentication
import Bytes
import Data.Report exposing (Report)
import File.Download as Download
import Html exposing (Html, a, button, div, input, label, li, text, ul)
import Html.Attributes exposing (attribute, class, href, id)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)
import Ports
import Process
import Task
import Utils exposing (getHTTPErrorMessage)


type alias Model =
    { reports : List Report
    , errorModel : ErrorData
    }


type Msg
    = GetReports
    | DownloadReport Report
    | GotReports (Result Http.Error (List Report))
    | GotDownload (Result Http.Error (List Report))
    | HideError


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    ( { reports = []
      , errorModel = errorInit
      }
    , Cmd.batch (initialCommands authModel)
    )


reportsUrl : String
reportsUrl =
    "/api/files"


getReports : Authentication.Model -> Cmd Msg
getReports authModel =
    Http.request
        { method = "GET"
        , headers = Authentication.tryGetAuthHeader authModel
        , url = reportsUrl
        , body = Http.emptyBody
        , expect = Http.expectJson GotReports (Decode.list Data.Report.decode)
        , timeout = Nothing
        , tracker = Nothing
        }


downloadReport : Authentication.Model -> Data.Report.Report -> Cmd Msg
downloadReport authModel report =
    let
        headers =
            Authentication.tryGetAuthHeader authModel
                ++ [ Http.header "Accept" "application/octet-stream" ]
    in
    Http.request
        { body = Http.emptyBody
        , expect = Http.expectJson GotDownload (Decode.list Data.Report.decode)
        , headers = headers
        , method = "GET"
        , url = "/api/files?select=file&uuid=eq." ++ report.uuid
        , timeout = Nothing
        , tracker = Nothing
        }


downloadReportBytes : Data.Report.Report -> Cmd msg
downloadReportBytes report =
    Download.url ("/api/files?select=file&uuid=eq." ++ report.uuid)


initialCommands : Authentication.Model -> List (Cmd Msg)
initialCommands authModel =
    if Authentication.isLoggedIn authModel then
        [ getReports authModel ]

    else
        []


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        GetReports ->
            ( model
            , getReports authModel
            )

        DownloadReport report ->
            ( model
            , downloadReport authModel report
            )

        HideError ->
            ( { model | errorModel = errorInit }, Cmd.none )

        GotReports (Ok reports) ->
            ( { model | reports = reports }
            , Cmd.none
            )

        GotReports (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        GotDownload (Ok reports) ->
            ( { model | reports = reports }
            , Cmd.none
            )

        GotDownload (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    div []
        [ text "This is the reports view"
        , ul []
            (List.map
                (\l ->
                    li []
                        [ text (l.name ++ "(" ++ l.user_id ++ ")" ++ " created at " ++ l.created_at)
                        , button [ class "btn btn-secondary", onClick (DownloadReport l) ] [ text "Download" ]
                        ]
                )
                model.reports
            )
        , div [ class "row" ]
            [ button [ class "btn btn-secondary", onClick GetReports ] [ text "get reports" ]
            ]
        , viewError model.errorModel
        ]


reportToString : Report -> String
reportToString report =
    "{ "
        ++ report.uuid
        ++ ", "
        ++ report.created_at
        ++ ", "
        ++ report.user_id
        ++ ", "
        ++ report.name
        ++ " }"


showDebugData : Report -> Html Msg
showDebugData report =
    div [ class "debug" ]
        [ text ("DEBUG: " ++ reportToString report) ]
