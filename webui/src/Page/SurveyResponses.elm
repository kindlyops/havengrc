module Page.SurveyResponses exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Extra exposing (..)
import Authentication
import Http
import Request.SurveyResponses
import Ports
import Utils exposing (getHTTPErrorMessage)
import Data.RadarChart
import Data.SurveyResponses exposing (GroupedIpsativeResponse, AvailableResponse, AvailableResponseDatum)


type ResponsePage
    = Home
    | IpsativeResponse
    | LikertResponse


type alias Model =
    { currentPage : ResponsePage
    , availableResponses : List AvailableResponse
    , groupedIpsativeResponses : List GroupedIpsativeResponse
    , selectedResponse : Maybe AvailableResponse
    }


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    initialModel
        ! initialCommands authModel


initialModel : Model
initialModel =
    { currentPage = Home
    , availableResponses = []
    , groupedIpsativeResponses = []
    , selectedResponse = Nothing
    }


initialCommands : Authentication.Model -> List (Cmd Msg)
initialCommands authModel =
    if Authentication.isLoggedIn authModel then
        [ Http.send GotServerIpsativeResponses (Request.SurveyResponses.getIpsativeResponses authModel)
        ]
    else
        []


type Msg
    = NoOp
    | GenerateChart
    | GotServerIpsativeResponses (Result Http.Error (List GroupedIpsativeResponse))
    | StartVisualization AvailableResponse
    | GoToHome


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        NoOp ->
            model ! []

        StartVisualization availableResponse ->
            { model
                | currentPage = IpsativeResponse
                , selectedResponse = Just availableResponse
            }
                ! []

        GotServerIpsativeResponses (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        GotServerIpsativeResponses (Ok groupedResponses) ->
            let
                availableResponses =
                    createAvailableResponses groupedResponses
            in
                { model | groupedIpsativeResponses = groupedResponses, availableResponses = availableResponses } ! []

        GenerateChart ->
            case model.selectedResponse of
                Nothing ->
                    ( model, Cmd.none )

                Just availableResponse ->
                    ( model
                    , Ports.radarChart
                        (Data.RadarChart.generateIpsativeChart availableResponse)
                    )

        GoToHome ->
            { model | currentPage = Home } ! []


createAvailableResponses : List GroupedIpsativeResponse -> List AvailableResponse
createAvailableResponses groupedResponses =
    let
        sorted =
            List.sortBy .survey_id groupedResponses

        groupedBySurvey =
            groupWhile
                (\x y ->
                    x.survey_id == y.survey_id
                )
                sorted

        availableResponses =
            List.map
                (\surveyGroup ->
                    let
                        name =
                            case List.head surveyGroup of
                                Just y ->
                                    y.name

                                _ ->
                                    "Grouping error"
                    in
                        { name = name, data = createAvailableResponseDatum surveyGroup }
                )
                groupedBySurvey
    in
        availableResponses


createAvailableResponseDatum : List GroupedIpsativeResponse -> List AvailableResponseDatum
createAvailableResponseDatum surveyGroup =
    List.map
        (\x ->
            { group = x.group_number
            , category = x.category
            , points = x.sum
            }
        )
        surveyGroup


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    case model.currentPage of
        Home ->
            viewHome model

        IpsativeResponse ->
            case model.selectedResponse of
                Nothing ->
                    div [] [ text "there isn't a selected response" ]

                Just x ->
                    viewIpsativeResponse x

        LikertResponse ->
            div [] [ text "not done" ]


viewIpsativeResponse : AvailableResponse -> Html Msg
viewIpsativeResponse response =
    div []
        [ h2 [] [ text ("Name: " ++ response.name) ]
        , viewResponseTable response.data
        , button [ class "btn btn-primary", onClick GenerateChart ] [ text "Click to generate radar chart of results." ]
        , button [ class "btn btn-primary", onClick GoToHome ] [ text "Go Back" ]
        , canvas [ id "chart" ] []
        ]


viewResponseTable : List AvailableResponseDatum -> Html Msg
viewResponseTable datum =
    Html.table []
        ([ Html.tr []
            [ Html.th [] [ text "Category" ]
            , Html.th [] [ text "Group" ]
            , Html.th [] [ text "Points" ]
            ]
         ]
            ++ (List.map
                    (\datum ->
                        Html.tr []
                            [ Html.td [] [ text datum.category ]
                            , Html.td [] [ text (toString datum.group) ]
                            , Html.td [] [ text (toString datum.points) ]
                            ]
                    )
                    datum
               )
        )


viewHome : Model -> Html Msg
viewHome model =
    div [ class "" ]
        [ h1 [ class "display-4" ] [ text "Survey Responses" ]
        , p [ class "lead" ] [ text "Select a response group to get started." ]
        , hr [ class "my-4" ] []
        , p [ class "" ] [ text ("There are currently " ++ (toString (List.length model.availableResponses)) ++ " responses to choose from.") ]
        , div [ class "row" ]
            (List.map
                (\availableResponse ->
                    div [ class "col-6 mb-4" ]
                        (viewAvailableResponseCard availableResponse)
                )
                model.availableResponses
            )
        ]


viewAvailableResponseCard : AvailableResponse -> List (Html Msg)
viewAvailableResponseCard availableResponse =
    [ div
        [ class "card" ]
        [ div [ class "card-header" ] [ text "Ipsative" ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text availableResponse.name
                ]
            , div []
                [ button
                    [ class "btn btn-primary"
                    , onClick (StartVisualization availableResponse)
                    ]
                    [ text "Click to view response" ]
                ]
            ]
        ]
    ]
