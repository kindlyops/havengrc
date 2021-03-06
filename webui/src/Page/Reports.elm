module Page.Reports exposing (Model, Msg(..), dashboardView, getReports, init, update, view)

import Authentication
import Browser.Navigation as Nav
import Bytes exposing (Bytes)
import Data.OnBoarding as OnBoarding
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
import Utils exposing (formatPrettyDate, getHTTPErrorMessage)


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
    | UpdatedOnboardingStatus OnBoarding.Msg
    | HideError
    | LogOut


init : Authentication.Model -> String -> ( Model, Cmd Msg )
init authModel location =
    ( { reports = []
      , errorModel = errorInit
      }
    , Cmd.batch (initialCommands authModel location)
    )


reportsUrl : String
reportsUrl =
    "/api/files"


getReports : Authentication.Model -> Cmd Msg
getReports authModel =
    Http.get
        { url = reportsUrl
        , expect = Http.expectJson GotReports (Decode.list Data.Report.decode)
        }


initReports : Authentication.Model -> Cmd Msg
initReports authModel =
    Cmd.none


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
        , url = "/api/reports?file_id=" ++ report.id
        , timeout = Nothing
        , tracker = Nothing
        }


downloadReportBytes : String -> Bytes -> Cmd msg
downloadReportBytes name content =
    Download.bytes name "application/octet-stream" content


initialCommands : Authentication.Model -> String -> List (Cmd Msg)
initialCommands authModel location =
    let
        initialCmd =
            if String.contains "/dashboard" location then
                getReports

            else
                initReports
    in
    [ initialCmd authModel ]


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
            let
                ( errorModel, errorCmd ) =
                    case error of
                        Http.BadStatus statusCode ->
                            if statusCode == 401 then
                                ( model, logOut )

                            else
                                ( model, Cmd.none )

                        _ ->
                            ( model, Cmd.none )
            in
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Cmd.batch
                [ errorCmd
                , Process.sleep 3000 |> Task.perform (always HideError)
                ]
            )

        GotDownload (Ok response) ->
            ( model
            , Cmd.batch
                [ downloadReportBytes response.report.name response.body
                , Cmd.map UpdatedOnboardingStatus (OnBoarding.set "new" True)
                ]
            )

        GotDownload (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        UpdatedOnboardingStatus _ ->
            ( model, Cmd.none )

        LogOut ->
            -- NO-OP, we intercept this message in the parent update and
            -- dispatch a logout message to the Authentication module.
            ( model, Cmd.none )


logOut : Cmd Msg
logOut =
    Task.succeed LogOut |> Task.perform identity


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    div []
        [ text "This is the reports view"
        , ul []
            (List.map
                (\l ->
                    li []
                        [ text (l.name ++ "(" ++ l.user_id ++ ")" ++ " created " ++ l.created_at)
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
    div []
        [ ul [ class "list-group" ]
            (List.map
                (\l ->
                    li [ class "list-group-item" ]
                        [ p [] [ text ("This report created " ++ formatPrettyDate authModel.now l.created_at) ]
                        , button [ class "btn btn-secondary", onClick (DownloadReport l) ] [ text l.name, i [ class "material-icons pl-2" ] [ text "cloud_download" ] ]
                        ]
                )
                model.reports
            )
        , viewError model.errorModel
        ]


reportToString : Report -> String
reportToString report =
    "{ "
        ++ report.id
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
