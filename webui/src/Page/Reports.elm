module Page.Reports exposing (Model, Msg(..), dashboardView, getReports, init, update, view)

import Authentication
import Bytes exposing (Bytes)
import Data.Report exposing (Report)
import File.Download as Download
import Html exposing (Html, a, button, div, i, input, label, li, p, text, ul)
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


type alias FileDownload =
    { body : Bytes
    , report : Report
    }


type Msg
    = GetReports
    | DownloadReport Report
    | GotReports (Result Http.Error (List Report))
    | GotDownload (Result Http.Error FileDownload)
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
    "/api/files?select=uuid,created_at,user_id,name"


getReports : Authentication.Model -> Cmd Msg
getReports authModel =
    Http.get
        { url = reportsUrl
        , expect = Http.expectJson GotReports (Decode.list Data.Report.decode)
        }


expectBytes : Report -> (Result Http.Error FileDownload -> msg) -> Http.Expect msg
expectBytes report toMsg =
    Http.expectBytesResponse toMsg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (Http.BadUrl url)

                Http.Timeout_ ->
                    Err Http.Timeout

                Http.NetworkError_ ->
                    Err Http.NetworkError

                Http.BadStatus_ metadata body ->
                    Err (Http.BadStatus metadata.statusCode)

                Http.GoodStatus_ metadata body ->
                    Ok { body = body, report = report }


downloadReport : Data.Report.Report -> Cmd Msg
downloadReport report =
    let
        headers =
            [ Http.header "Accept" "application/octet-stream" ]
    in
    Http.request
        { body = Http.emptyBody
        , expect = expectBytes report GotDownload
        , headers = headers
        , method = "GET"
        , url = "/rpc/download_file?fileid=" ++ report.uuid
        , timeout = Nothing
        , tracker = Nothing
        }


downloadReportBytes : String -> Bytes -> Cmd msg
downloadReportBytes name content =
    Download.bytes name "application/octet-stream" content


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
            ( model, downloadReport report )

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

        GotDownload (Ok response) ->
            ( model, downloadReportBytes response.report.name response.body )

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


dashboardView : Authentication.Model -> Model -> Html Msg
dashboardView authModel model =
    div [ class "card" ]
        [ div
            [ class "card-body" ]
            [ div [ class "card-title" ] [ text "Latest Report:" ]
            , ul [ class "list-group" ]
                (List.map
                    (\l ->
                        li [ class "list-group-item" ]
                            [ p [] [ text ("Report created on " ++ l.created_at) ]
                            , button [ class "btn btn-secondary", onClick (DownloadReport l) ] [ text l.name, i [ class "material-icons pl-2" ] [ text "cloud_download" ] ]
                            ]
                    )
                    model.reports
                )
            , viewError model.errorModel
            ]
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
