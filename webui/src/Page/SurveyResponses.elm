module Page.SurveyResponses exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    )

import Authentication
import Data.RadarChart
import Data.SurveyResponses exposing (AvailableResponse, AvailableResponseDatum, GroupedIpsativeResponse)
import Html exposing (Html, button, canvas, div, h1, h2, h5, hr, p, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Http
import List.Extra exposing (groupWhile)
import Ports
import Request.SurveyResponses
import Utils exposing (getHTTPErrorMessage, smashList)


type ResponsePage
    = Home
    | IpsativeResponse


type alias Model =
    { currentPage : ResponsePage
    , availableResponses : List AvailableResponse
    , groupedIpsativeResponses : List GroupedIpsativeResponse
    , selectedResponse : Maybe AvailableResponse
    }


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    ( initialModel
    , Cmd.batch (initialCommands authModel)
    )


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
        [ Http.send GotServerIpsativeResponses (Request.SurveyResponses.getIpsativeResponses authModel) ]

    else
        []


type Msg
    = GetResponses
    | GotServerIpsativeResponses (Result Http.Error (List GroupedIpsativeResponse))
    | StartVisualization AvailableResponse
    | GoToHome
    | GenerateChart


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        GetResponses ->
            ( model
            , Http.send GotServerIpsativeResponses (Request.SurveyResponses.getIpsativeResponses authModel)
            )

        StartVisualization availableResponse ->
            ( { model
                | currentPage = IpsativeResponse
                , selectedResponse = Just availableResponse
              }
            , Cmd.none
            )

        GotServerIpsativeResponses (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        GotServerIpsativeResponses (Ok groupedResponses) ->
            let
                availableResponses =
                    createAvailableResponses groupedResponses
            in
            ( { model | groupedIpsativeResponses = groupedResponses, availableResponses = availableResponses }
            , Cmd.none
            )

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
            ( { model | currentPage = Home }
            , Cmd.none
            )


createAvailableResponses : List GroupedIpsativeResponse -> List AvailableResponse
createAvailableResponses groupedResponses =
    let
        sorted =
            List.sortBy .survey_id groupedResponses

        groupedBySurvey =
            smashList
                (groupWhile
                    (\x y ->
                        x.survey_id == y.survey_id
                    )
                    sorted
                )

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
            , Html.th [] [ text "Points" ]
            ]
         ]
            ++ List.map
                (\d ->
                    Html.tr []
                        [ Html.td [] [ text d.category ]
                        , Html.td [] [ text (String.fromInt d.points) ]
                        ]
                )
                datum
        )


viewHome : Model -> Html Msg
viewHome model =
    div [ class "" ]
        [ h1 [ class "display-4" ] [ text "Survey Responses" ]
        , p [ class "lead" ] [ text "Select a response group to get started." ]
        , hr [ class "my-4" ] []
        , div [ class "row" ]
            [ button [ class "btn btn-secondary", onClick GetResponses ] [ text "get Ipsative Responses" ] ]
        , p [ class "" ] [ text ("There are currently " ++ String.fromInt (List.length model.availableResponses) ++ " responses to choose from.") ]
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
