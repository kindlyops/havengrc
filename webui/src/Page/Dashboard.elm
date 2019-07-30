module Page.Dashboard exposing (Model, Msg(..), init, update, view)

import Authentication
import Browser.Navigation as Nav
import Html exposing (Html, br, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)
import Page.Reports
import Ports
import Process
import Task
import Url


type Msg
    = ShowError String
    | HideError
    | ReportsMsg Page.Reports.Msg


type alias Model =
    { data : List Float
    , errorModel : ErrorData
    , authModel : Authentication.Model
    , reportsModel : Page.Reports.Model
    }


init : Authentication.Model -> ( Model, Cmd Page.Reports.Msg )
init authModel =
    let
        ( reportsModel, reportsCmd ) =
            Page.Reports.init authModel "/dashboard"

        model =
            { data = []
            , reportsModel = reportsModel
            , authModel = authModel
            , errorModel = errorInit
            }
    in
    ( model
    , Cmd.batch (initialCommands authModel)
    )


initialCommands : Authentication.Model -> List (Cmd Page.Reports.Msg)
initialCommands authModel =
    if Authentication.isLoggedIn authModel then
        [ Page.Reports.getReports authModel ]

    else
        []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowError errMsg ->
            ( { model | errorModel = setErrorMessage model.errorModel errMsg }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        HideError ->
            ( { model | errorModel = errorInit }, Cmd.none )

        ReportsMsg reportMsg ->
            let
                ( reportsModel, cmd ) =
                    Page.Reports.update reportMsg model.reportsModel model.authModel
            in
            ( { model | reportsModel = reportsModel }, Cmd.map ReportsMsg cmd )


view : Authentication.Model -> Model -> Page.Reports.Model -> Html Msg
view authModel model reportsModel =
    div
        []
        [ div [] [ text "Welcome to your Haven GRC Dashboard!" ]
        , br [] []
        , div [] [ Page.Reports.dashboardView authModel reportsModel |> Html.map ReportsMsg ]
        ]
