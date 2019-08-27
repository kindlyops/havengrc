module Page.Survey exposing
    ( Msg(..)
    , SavedState
    , TestStructure
    , decodeSavedState
    , init
    , initWithSave
    , subscriptions
    , testDecoder
    , update
    , view
    )

import Authentication
import Browser.Navigation as Nav
import Data.Registration as Registration exposing (Registration)
import Data.Survey as Survey
    exposing
        ( InitialSurvey
        , IpsativeAnswer
        , IpsativeQuestion
        , IpsativeSurvey
        , LikertAnswer
        , LikertQuestion
        , LikertSurvey
        , Model
        , PointsAssigned
        , PointsLeft
        , Survey(..)
        , SurveyMetaData
        , SurveyPage(..)
        , decodeInitialSurvey
        , decodeSurveyMetaData
        , encodeSurvey
        , encodeSurveyData
        , encodeSurveyMetaData
        , upgradeSurvey
        )
import Delay exposing (TimeUnit(..), after)
import Html exposing (Html, a, br, button, div, footer, form, h1, h3, h4, hr, i, img, input, li, p, span, table, tbody, td, text, th, thead, tr, ul)
import Html.Attributes exposing (action, alt, attribute, class, disabled, height, href, id, placeholder, rel, required, src, style, target, title, type_, value, width)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder, andThen, decodeString, field, int, map, map2, map5, nullable, oneOf, string)
import Json.Encode as Encode
import List.Zipper as Zipper
import Page.Errors exposing (ErrorData, errorInit, setErrorMessage, viewError)
import Ports
import Process
import Regex
import Task
import Transit exposing (Step(..))
import TransitStyle
import Utils exposing (getHTTPErrorMessage)
import Views.SurveyCard
import Visualization exposing (havenSpecs)



--TODO: change currentSurvey to Maybe


totalGroups : number
totalGroups =
    1


type alias TestStructure =
    { storedSurvey : Maybe SavedState
    , featureEnv : String
    }


testDecoder : Decoder TestStructure
testDecoder =
    map2 TestStructure
        (field "storedSurvey" (nullable decodeSavedState))
        (field "featureEnv" Decode.string)


type alias SavedState =
    { currentPage : SurveyPage
    , surveyData : InitialSurvey
    , selectedSurveyMetaData : SurveyMetaData
    , isSurveyReady : Bool
    , currentQuestionNumber : Int
    }


decodeSavedState : Decoder SavedState
decodeSavedState =
    map5 SavedState
        (field "currentPage" decodeCurrentPage)
        (field "surveyData" decodeInitialSurvey)
        (field "selectedSurveyMetaData" decodeSurveyMetaData)
        (field "isSurveyReady" Decode.bool)
        (field "currentQuestionNumber" Decode.int)


decodeCurrentPage : Decoder SurveyPage
decodeCurrentPage =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "Home" ->
                        Decode.succeed Home

                    "Survey" ->
                        Decode.succeed Survey

                    "IncompleteSurvey" ->
                        Decode.succeed IncompleteSurvey

                    "Finished" ->
                        Decode.succeed Finished

                    somethingElse ->
                        Decode.fail <| "Unknown theme: " ++ somethingElse
            )


getIpsativeSurveys : Authentication.Model -> Cmd Msg
getIpsativeSurveys authModel =
    Http.get
        { url = "/api/ipsative_surveys"
        , expect = Http.expectJson GotServerIpsativeSurveys (Decode.list Survey.decodeSurveyMetaData)
        }


getIpsativeSurvey : Authentication.Model -> String -> Cmd Msg
getIpsativeSurvey authModel id =
    Http.get
        { url = "/api/ipsative_data/" ++ id
        , expect = Http.expectJson GotIpsativeServerData (Decode.list Survey.ipsativeSurveyDataDecoder)
        }


postIpsativeResponse : Authentication.Model -> Survey.IpsativeSurvey -> Cmd Msg
postIpsativeResponse authModel ipsativeSurvey =
    let
        headers =
            Authentication.getReturnHeaders
    in
    Http.request
        { method = "POST"
        , headers = headers
        , url = "/api/surveys"
        , body = Http.jsonBody (postEncoder ipsativeSurvey)
        , expect = Http.expectJson IpsativeSurveySaved (Decode.list Survey.ipsativeResponseDecoder)
        , timeout = Nothing
        , tracker = Nothing
        }


postEncoder : IpsativeSurvey -> Encode.Value
postEncoder survey =
    Encode.object
        [ ( "survey_results", Survey.ipsativeResponseEncoder survey )
        , ( "survey_id", Survey.metaDataResponseEncoder survey )

        -- TODO add collectors ( "collector_id", survey.metaData.collector.id )
        ]


getLikertSurveys : Authentication.Model -> Cmd Msg
getLikertSurveys authModel =
    Http.get
        { url = "/api/likert_surveys"
        , expect = Http.expectJson GotServerLikertSurveys (Decode.list Survey.decodeSurveyMetaData)
        }


getLikertSurvey : Authentication.Model -> String -> Cmd Msg
getLikertSurvey authModel id =
    Http.get
        { url = "/api/likert_data?survey_id=eq." ++ id
        , expect = Http.expectJson GotLikertServerData (Decode.list Survey.likertSurveyDataDecoder)
        }


getLikertChoices : Authentication.Model -> String -> Cmd Msg
getLikertChoices authModel id =
    Http.get
        { url = "/api/likert_distinct_choice_groups?survey_id=eq." ++ id
        , expect = Http.expectJson GotLikertChoices (Decode.list Survey.likertSurveyChoicesDecoder)
        }


postLikertResponses : Authentication.Model -> Survey.LikertSurvey -> Cmd Msg
postLikertResponses authModel likertSurvey =
    let
        body =
            Survey.likertResponseEncoder likertSurvey
                |> Http.jsonBody

        headers =
            Authentication.getReturnHeaders
    in
    Http.request
        { method = "POST"
        , headers = headers
        , url = "api/likert_responses"
        , body = body
        , expect = Http.expectJson LikertSurveySaved (Decode.list Survey.likertResponseDecoder)
        , timeout = Nothing
        , tracker = Nothing
        }


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    ( initialModel
    , Cmd.batch (initialCommands authModel)
    )


initWithSave : Authentication.Model -> TestStructure -> ( Model, Cmd Msg )
initWithSave authModel testStructure =
    let
        savedState =
            testStructure.storedSurvey

        returnModel =
            case savedState of
                Just state ->
                    let
                        upgradedSurvey =
                            upgradeSurvey state.surveyData state.selectedSurveyMetaData state.currentQuestionNumber

                        upgradedModel =
                            case upgradedSurvey of
                                Ipsative survey ->
                                    { initialModel
                                        | currentSurvey = upgradedSurvey
                                        , currentPage = state.currentPage
                                        , selectedSurveyMetaData = state.selectedSurveyMetaData
                                        , isSurveyReady = state.isSurveyReady
                                    }

                                Likert survey ->
                                    { initialModel
                                        | currentSurvey = upgradedSurvey
                                        , currentPage = state.currentPage
                                        , selectedSurveyMetaData = state.selectedSurveyMetaData
                                        , isSurveyReady = state.isSurveyReady
                                    }
                    in
                    upgradedModel

                Nothing ->
                    initialModel
    in
    ( returnModel
    , Cmd.batch (initialCommands authModel)
    )


initialModel : Model
initialModel =
    { currentSurvey = Ipsative Survey.emptyIpsativeServerSurvey
    , currentPage = Home
    , availableIpsativeSurveys = []
    , availableLikertSurveys = []
    , selectedSurveyMetaData = Survey.emptyIpsativeServerMetaData
    , isSurveyReady = False
    , inBoundLikertData = Nothing
    , emailAddress = ""
    , errorModel = errorInit
    , transit = { page = Home, transition = Transit.empty }
    }


storeSurvey : Model -> Int -> Cmd msg
storeSurvey model currentQuestionNumber =
    encodeApplicationPage model currentQuestionNumber
        |> Just
        |> Ports.saveSurveyState


encodeApplicationPage : Model -> Int -> Encode.Value
encodeApplicationPage model currentQuestionNumber =
    Encode.object
        [ ( "currentPage", Encode.string (encodeSurveyPage model.currentPage) )
        , ( "surveyData", encodeSurveyData model.currentSurvey )
        , ( "selectedSurveyMetaData", encodeSurveyMetaData model.selectedSurveyMetaData )
        , ( "isSurveyReady", Encode.bool model.isSurveyReady )
        , ( "currentQuestionNumber", Encode.int currentQuestionNumber )
        ]


encodeSurveyPage : SurveyPage -> String
encodeSurveyPage surveyPage =
    case surveyPage of
        Home ->
            "Home"

        Survey ->
            "Survey"

        IncompleteSurvey ->
            "IncompleteSurvey"

        Finished ->
            "Finished"

        Registered ->
            "Registered"


initialCommands : Authentication.Model -> List (Cmd Msg)
initialCommands authModel =
    surveyRequests authModel


surveyRequests : Authentication.Model -> List (Cmd Msg)
surveyRequests authModel =
    [ getIpsativeSurveys authModel
    , getLikertSurveys authModel
    ]


type Msg
    = StartLikertSurvey SurveyMetaData
    | StartIpsativeSurvey SurveyMetaData
    | IncrementAnswer IpsativeAnswer Int
    | DecrementAnswer IpsativeAnswer Int
    | UpdateAnswer IpsativeAnswer Int String
    | NextQuestion
    | SetNextQuestion
    | PreviousQuestion
    | LoadReportDashboard
    | GoToHome
    | RestartSurvey SurveyMetaData
    | RenderVegaCharts
    | SelectLikertAnswer String String
    | GotoQuestion Int
    | GetIpsativeSurveys
    | GetLikertSurveys
    | GotServerIpsativeSurveys (Result Http.Error (List Survey.SurveyMetaData))
    | GotIpsativeServerData (Result Http.Error (List Survey.IpsativeServerData))
    | GotServerLikertSurveys (Result Http.Error (List Survey.SurveyMetaData))
    | GotLikertServerData (Result Http.Error (List Survey.LikertServerData))
    | GotLikertChoices (Result Http.Error (List Survey.LikertServerChoice))
    | UpdateEmail String
    | RegisterNewUser
    | NewUserRegistered (Result Http.Error String)
    | SaveCurrentSurvey
    | IpsativeSurveySaved (Result Http.Error (List Survey.IpsativeResponse))
    | LikertSurveySaved (Result Http.Error (List Survey.LikertResponse))
    | HideError
    | TransitMsg (Transit.Msg Msg)


registrationUrl : String
registrationUrl =
    "/api/registration_funnel"


postRegistration : Survey.IpsativeSurvey -> String -> Authentication.Model -> Cmd Msg
postRegistration surveyModel emailAddress authModel =
    let
        responses =
            Survey.ipsativeResponseEncoder surveyModel
                |> Http.jsonBody

        registration =
            Registration emailAddress responses surveyModel.metaData.id

        body =
            Registration.encode registration surveyModel
                |> Http.jsonBody

        headers =
            Authentication.getReturnHeaders
    in
    Http.request
        { method = "POST"
        , url = registrationUrl
        , headers = headers
        , body = body
        , timeout = Nothing
        , expect = Http.expectString NewUserRegistered
        , tracker = Nothing
        }


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        HideError ->
            ( { model | errorModel = errorInit }, Cmd.none )

        UpdateEmail newEmail ->
            ( { model | emailAddress = newEmail }
            , Cmd.none
            )

        RegisterNewUser ->
            case model.currentSurvey of
                Ipsative survey ->
                    ( model
                    , postRegistration survey model.emailAddress authModel
                    )

                Likert survey ->
                    ( initialModel
                    , Cmd.none
                    )

        SaveCurrentSurvey ->
            case model.currentSurvey of
                Ipsative survey ->
                    ( model
                    , postIpsativeResponse authModel survey
                    )

                Likert survey ->
                    ( model
                    , postLikertResponses authModel survey
                    )

        NewUserRegistered (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        NewUserRegistered (Ok responses) ->
            let
                newModel =
                    { model | currentPage = Registered }
            in
            ( newModel
            , Cmd.none
            )

        IpsativeSurveySaved (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        IpsativeSurveySaved (Ok responses) ->
            ( model
            , Cmd.none
            )

        LikertSurveySaved (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        LikertSurveySaved (Ok responses) ->
            ( initialModel
            , Cmd.none
            )

        GetIpsativeSurveys ->
            ( model
            , getIpsativeSurveys authModel
            )

        GetLikertSurveys ->
            ( model
            , getLikertSurveys authModel
            )

        GotServerIpsativeSurveys (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        GotServerIpsativeSurveys (Ok surveys) ->
            ( { model | availableIpsativeSurveys = surveys }
            , Cmd.none
            )

        GotServerLikertSurveys (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        GotServerLikertSurveys (Ok surveys) ->
            ( { model | availableLikertSurveys = surveys }
            , Cmd.none
            )

        GotIpsativeServerData (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        GotIpsativeServerData (Ok data) ->
            let
                questions =
                    Survey.groupIpsativeSurveyData data

                survey =
                    Survey.createIpsativeSurvey 10 totalGroups model.selectedSurveyMetaData questions
            in
            ( { model | currentSurvey = survey, isSurveyReady = True }
            , Cmd.none
            )

        GotLikertServerData (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        GotLikertServerData (Ok data) ->
            ( { model | inBoundLikertData = Just data }
            , getLikertChoices authModel model.selectedSurveyMetaData.id
            )

        GotLikertChoices (Err error) ->
            ( { model
                | errorModel = setErrorMessage model.errorModel (getHTTPErrorMessage error)
              }
            , Process.sleep 3000 |> Task.perform (always HideError)
            )

        GotLikertChoices (Ok serverChoices) ->
            let
                questions =
                    case model.inBoundLikertData of
                        Just x ->
                            Survey.groupLikertSurveyData x

                        Nothing ->
                            []

                survey =
                    Survey.createLikertSurvey model.selectedSurveyMetaData questions serverChoices

                isSurveyReady =
                    True
            in
            ( { model | currentSurvey = survey, isSurveyReady = isSurveyReady }
            , Cmd.none
            )

        SelectLikertAnswer answerNumber choice ->
            let
                newSurvey =
                    case model.currentSurvey of
                        Likert survey ->
                            Likert (selectLikertAnswer survey answerNumber choice)

                        _ ->
                            model.currentSurvey

                newModel =
                    { model | currentSurvey = newSurvey }
            in
            ( newModel
            , storeSurvey newModel (getQuestionNumber newModel)
            )

        GoToHome ->
            let
                newModel =
                    { model | currentPage = Home }
            in
            ( newModel
            , Cmd.batch (storeSurvey newModel (getQuestionNumber newModel) :: surveyRequests authModel)
            )

        StartLikertSurvey metaData ->
            ( { model | currentPage = Survey, selectedSurveyMetaData = metaData }
            , getLikertSurvey authModel metaData.id
            )

        StartIpsativeSurvey metaData ->
            ( { model | currentPage = Survey, selectedSurveyMetaData = metaData }
            , getIpsativeSurvey authModel metaData.id
            )

        SetNextQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Ipsative { survey | questions = x } }
                            in
                            ( newModel
                            , storeSurvey newModel (getQuestionNumber newModel)
                            )

                        _ ->
                            ( model, Cmd.none )

                Likert survey ->
                    ( model, Cmd.none )

        NextQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            let
                                ( newTransit, transitCmd ) =
                                    Transit.start TransitMsg SetNextQuestion ( 500, 500 ) model.transit
                            in
                            ( { model | transit = newTransit }, transitCmd )

                        _ ->
                            let
                                newModel =
                                    { model | currentPage = Finished }

                                -- TODO: render a spinner
                                cmd =
                                    Delay.after 1500 Millisecond RenderVegaCharts

                                -- Post right away if the user is logged in
                                extraCmds =
                                    if Authentication.isLoggedIn authModel then
                                        [ postIpsativeResponse authModel survey ]

                                    else
                                        []
                            in
                            ( newModel
                            , Cmd.batch
                                ([ storeSurvey newModel (getQuestionNumber newModel)
                                 , cmd
                                 ]
                                    ++ extraCmds
                                )
                            )

                Likert survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Likert { survey | questions = x } }
                            in
                            ( newModel
                            , storeSurvey newModel (getQuestionNumber newModel)
                            )

                        _ ->
                            let
                                newModel =
                                    { model | currentPage = Finished }

                                cmd =
                                    Cmd.none
                            in
                            ( newModel
                            , Cmd.batch [ storeSurvey newModel (getQuestionNumber newModel), cmd ]
                            )

        RestartSurvey metaData ->
            ( { model
                | currentSurvey = Ipsative Survey.emptyIpsativeServerSurvey
                , isSurveyReady = False
                , currentPage = Survey
                , selectedSurveyMetaData = metaData
              }
            , getIpsativeSurvey authModel metaData.id
            )

        RenderVegaCharts ->
            ( model, Ports.renderVega (havenSpecs model) )

        LoadReportDashboard ->
            ( { model | currentSurvey = Ipsative Survey.emptyIpsativeServerSurvey }
            , Nav.pushUrl authModel.key "/dashboard/"
            )

        PreviousQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.previous survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Ipsative { survey | questions = x } }
                            in
                            ( newModel
                            , storeSurvey newModel (getQuestionNumber newModel)
                            )

                        _ ->
                            ( model
                            , Cmd.none
                            )

                Likert survey ->
                    case Zipper.previous survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Likert { survey | questions = x } }
                            in
                            ( newModel
                            , storeSurvey newModel (getQuestionNumber newModel)
                            )

                        _ ->
                            ( model
                            , Cmd.none
                            )

        UpdateAnswer answer groupNumber newPointsValue ->
            let
                newPoints =
                    Maybe.withDefault 0 (String.toInt newPointsValue)

                newSurvey =
                    case model.currentSurvey of
                        Ipsative survey ->
                            Ipsative (updateAnswer survey answer groupNumber newPoints)

                        _ ->
                            model.currentSurvey

                newModel =
                    { model | currentSurvey = newSurvey }
            in
            ( newModel
            , storeSurvey newModel (getQuestionNumber newModel)
            )

        DecrementAnswer answer groupNumber ->
            --if points for this answer is > 0,
            --then decrement the point in this answer and
            --increment the points left for the group
            let
                newSurvey =
                    case model.currentSurvey of
                        Ipsative survey ->
                            Ipsative (decrementAnswer survey answer groupNumber)

                        _ ->
                            model.currentSurvey

                newModel =
                    { model | currentSurvey = newSurvey }
            in
            ( newModel
            , storeSurvey newModel (getQuestionNumber newModel)
            )

        IncrementAnswer answer groupNumber ->
            --    --if points left in group > 0,
            --then increment the point in the group for
            --this answer and decrement the points assigned for the group
            let
                newSurvey =
                    case model.currentSurvey of
                        Ipsative survey ->
                            Ipsative (incrementAnswer survey answer groupNumber)

                        _ ->
                            model.currentSurvey

                newModel =
                    { model | currentSurvey = newSurvey }
            in
            ( newModel
            , storeSurvey newModel (getQuestionNumber newModel)
            )

        GotoQuestion questionNumber ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.find (\x -> x.orderNumber == questionNumber) (Zipper.first survey.questions) of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Ipsative { survey | questions = x }, currentPage = Survey }
                            in
                            ( newModel
                            , storeSurvey newModel (getQuestionNumber newModel)
                            )

                        _ ->
                            ( model
                            , Cmd.none
                            )

                Likert survey ->
                    case Zipper.find (\x -> x.orderNumber == questionNumber) (Zipper.first survey.questions) of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Likert { survey | questions = x }, currentPage = Survey }
                            in
                            ( newModel
                            , storeSurvey newModel (getQuestionNumber newModel)
                            )

                        _ ->
                            ( model
                            , Cmd.none
                            )

        TransitMsg transitMsg ->
            let
                ( transit, c ) =
                    Transit.tick TransitMsg transitMsg model.transit
            in
            ( { model | transit = transit }, c )


getQuestionNumber : Model -> Int
getQuestionNumber model =
    case model.currentSurvey of
        Ipsative survey ->
            survey.questions |> Zipper.mapAfter (\x -> []) |> Zipper.toList |> List.length

        Likert survey ->
            survey.questions |> Zipper.mapAfter (\x -> []) |> Zipper.toList |> List.length


validateSurvey : Survey -> Bool
validateSurvey survey =
    if List.length (getIncompleteQuestions survey) == 0 then
        True

    else
        False


getIncompleteQuestions : Survey -> List Int
getIncompleteQuestions survey =
    case survey of
        Ipsative s ->
            --Survey question is good if all the points for all the groups for all the answers is zero
            List.foldr
                (\question incompleteQuestions ->
                    if validateIpsativeQuestion question then
                        incompleteQuestions

                    else
                        question.orderNumber :: incompleteQuestions
                )
                []
                (Zipper.toList s.questions)

        Likert s ->
            --Survey question is good if all the answers have a selectedChoice
            List.foldr
                (\question incompleteQuestions ->
                    if validateLikertQuestion question then
                        incompleteQuestions

                    else
                        question.orderNumber :: incompleteQuestions
                )
                []
                (Zipper.toList s.questions)


validateLikertQuestion : LikertQuestion -> Bool
validateLikertQuestion question =
    let
        checkedQuestions =
            List.filterMap
                (\answer ->
                    answer.selectedChoice
                )
                question.answers
    in
    if List.length checkedQuestions == List.length question.answers then
        True

    else
        False


validateIpsativeQuestion : IpsativeQuestion -> Bool
validateIpsativeQuestion question =
    let
        checkedQuestions =
            List.filterMap
                (\pointsLeft ->
                    validatePointsLeft pointsLeft
                )
                question.pointsLeft
    in
    if List.length checkedQuestions == 0 then
        True

    else
        False


validatePointsLeft : PointsLeft -> Maybe Bool
validatePointsLeft pointsLeft =
    if pointsLeft.pointsLeft == 0 then
        Nothing

    else
        Just False


selectLikertAnswer : LikertSurvey -> String -> String -> LikertSurvey
selectLikertAnswer survey answerNumber choice =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    { id = question.id
                    , title = question.title
                    , orderNumber = question.orderNumber
                    , choices = question.choices
                    , answers =
                        List.map
                            (\answer ->
                                if answer.id == answerNumber then
                                    { answer
                                        | selectedChoice = Just choice
                                    }

                                else
                                    answer
                            )
                            question.answers
                    }
                )
                survey.questions
    in
    { survey | questions = newQuestions }


updateAnswer : IpsativeSurvey -> IpsativeAnswer -> Int -> Int -> IpsativeSurvey
updateAnswer survey answer groupNumber newPoints =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    let
                        pointsRemaining =
                            calculatePointsRemaining question.answers

                        newAnswers =
                            List.map
                                (\x ->
                                    if x.id == answer.id then
                                        { x
                                            | pointsAssigned =
                                                List.map
                                                    (\y ->
                                                        if y.group == groupNumber then
                                                            if newPoints > y.points then
                                                                { y | points = y.points + min pointsRemaining (newPoints - y.points) }

                                                            else
                                                                { y | points = newPoints }

                                                        else
                                                            y
                                                    )
                                                    x.pointsAssigned
                                        }

                                    else
                                        x
                                )
                                question.answers

                        newPointsLeft =
                            calculatePointsLeft newAnswers
                    in
                    { id = question.id
                    , title = question.title
                    , orderNumber = question.orderNumber
                    , pointsLeft = newPointsLeft
                    , answers = newAnswers
                    }
                )
                survey.questions
    in
    { survey | questions = newQuestions }


incrementAnswer : IpsativeSurvey -> IpsativeAnswer -> Int -> IpsativeSurvey
incrementAnswer survey answer groupNumber =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    { id = question.id
                    , title = question.title
                    , orderNumber = question.orderNumber
                    , pointsLeft =
                        List.map
                            (\pointsLeftInGroup ->
                                if pointsLeftInGroup.group == groupNumber then
                                    if pointsLeftInGroup.pointsLeft > 0 then
                                        { group = groupNumber, pointsLeft = pointsLeftInGroup.pointsLeft - 1 }

                                    else
                                        pointsLeftInGroup

                                else
                                    pointsLeftInGroup
                            )
                            question.pointsLeft
                    , answers =
                        List.map
                            (\x ->
                                if x.id == answer.id then
                                    { x
                                        | pointsAssigned =
                                            List.map
                                                (\y ->
                                                    if y.group == groupNumber then
                                                        if isPointsInGroup question.pointsLeft groupNumber then
                                                            { y | points = y.points + 1 }

                                                        else
                                                            y

                                                    else
                                                        y
                                                )
                                                x.pointsAssigned
                                    }

                                else
                                    x
                            )
                            question.answers
                    }
                )
                survey.questions
    in
    { survey | questions = newQuestions }


decrementAnswer : IpsativeSurvey -> IpsativeAnswer -> Int -> IpsativeSurvey
decrementAnswer survey answer groupNumber =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    { id = question.id
                    , title = question.title
                    , orderNumber = question.orderNumber
                    , pointsLeft =
                        List.map
                            (\pointsLeftInGroup ->
                                if pointsLeftInGroup.group == groupNumber then
                                    if isAnswerGreaterThanZero answer groupNumber then
                                        { pointsLeftInGroup | pointsLeft = pointsLeftInGroup.pointsLeft + 1 }

                                    else
                                        pointsLeftInGroup

                                else
                                    pointsLeftInGroup
                            )
                            question.pointsLeft
                    , answers =
                        List.map
                            (\x ->
                                if x.id == answer.id then
                                    { x
                                        | pointsAssigned =
                                            List.map
                                                (\y ->
                                                    if y.group == groupNumber then
                                                        if y.points > 0 then
                                                            { y | points = y.points - 1 }

                                                        else
                                                            y

                                                    else
                                                        y
                                                )
                                                x.pointsAssigned
                                    }

                                else
                                    x
                            )
                            question.answers
                    }
                )
                survey.questions
    in
    { survey | questions = newQuestions }


isAnswerGreaterThanZero : IpsativeAnswer -> Int -> Bool
isAnswerGreaterThanZero answer group =
    let
        filtered =
            List.filter (\x -> x.group == group) answer.pointsAssigned

        first =
            List.head filtered
    in
    case first of
        Just x ->
            if x.points > 0 then
                True

            else
                False

        _ ->
            False


isPointsInGroup : List PointsLeft -> Int -> Bool
isPointsInGroup pointsLeft group =
    let
        filtered =
            List.filter (\x -> x.group == group) pointsLeft

        first =
            List.head filtered
    in
    case first of
        Just x ->
            if x.pointsLeft > 0 then
                True

            else
                False

        _ ->
            False


view : Authentication.Model -> Model -> Html Msg
view authModel model =
    div (TransitStyle.fadeSlide 50 model.transit.transition)
        [ case model.currentPage of
            Home ->
                viewHero model

            Survey ->
                viewSurvey model.currentSurvey

            IncompleteSurvey ->
                viewIncomplete model.currentSurvey

            Finished ->
                if Authentication.isLoggedIn authModel then
                    viewFinished model

                else
                    viewRegistration model

            Registered ->
                viewRegistered model
        , viewError model.errorModel
        ]


viewIncomplete : Survey -> Html Msg
viewIncomplete survey =
    div [ class "row justify-content-center pt-3" ]
        [ div [ class "col-lg-10 col-xl-8" ]
            [ div [ class "" ]
                ([ h1 [ class "display-4" ] [ text "Incomplete Survey" ]
                 , p [ class "lead" ] [ text "You haven't answered all of the survey questions fully." ]
                 ]
                    ++ viewIncompleteButtons survey (getIncompleteQuestions survey)
                )
            ]
        ]


viewIncompleteButtons : Survey -> List Int -> List (Html Msg)
viewIncompleteButtons survey questionNumbers =
    List.map
        (\questionNumber ->
            div [ class "my-2" ] [ button [ class "btn btn-primary", onClick (GotoQuestion questionNumber) ] [ text ("Click to go back to question " ++ String.fromInt questionNumber) ] ]
        )
        questionNumbers


getTotalAvailableSurveys : Model -> Int
getTotalAvailableSurveys model =
    let
        ipsativeLength =
            List.length model.availableIpsativeSurveys

        likertLength =
            List.length model.availableLikertSurveys
    in
    ipsativeLength + likertLength


viewHero : Model -> Html Msg
viewHero model =
    div [ class "d-flex flex-column" ]
        [ img [ class "img-fluid mt-3", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ] []
        , div [ class "row" ]
            (List.map
                (\availableSurvey ->
                    if availableSurvey.name == "SCDS_1" then
                        div []
                            [ Views.SurveyCard.view availableSurvey "Ipsative" (StartIpsativeSurvey availableSurvey)
                            ]

                    else
                        div [] []
                )
                model.availableIpsativeSurveys
            )
        ]


viewFinished : Model -> Html Msg
viewFinished model =
    div [ class "d-flex flex-column" ]
        [ img [ class "img-fluid mt-3", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ] []
        , div [ class "row" ]
            [ div [ class "col-md-12 text-center mt-5" ]
                [ h1 [ class "survey-heading" ] [ text "You finished the survey!" ]
                , div [ class "vis", id "vis" ] []
                , div [ class "col-md-8 mx-auto my-5" ]
                    [ p [] [ text "A custom powerpoint version of this report is being generated and will be available on your dashboard shortly." ]
                    , div [ class "col text-center mt-4" ]
                        (List.map
                            (\availableSurvey ->
                                if availableSurvey.name == "SCDS_1" then
                                    div [] [ button [ class "btn btn-primary next-question-btn", onClick (RestartSurvey availableSurvey) ] [ text "Restart Survey" ] ]

                                else
                                    div [] []
                            )
                            model.availableIpsativeSurveys
                        )
                    ]
                ]
            ]
        ]


viewRegistration : Model -> Html Msg
viewRegistration model =
    div [ class "d-flex flex-column" ]
        [ img [ class "img-fluid mt-3", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ] []
        , div [ class "row" ]
            [ div [ class "col-xs-12 text-center mt-5" ]
                [ h1 [ class "survey-heading mb-5" ] [ text "You finished the survey!" ]
                , div [ class "vis", id "vis" ] []
                , div [ class "col-md-8 mx-auto my-5" ]
                    [ p [] [ text "Do you want a shareable version of these results? Enter your email and we will generate a customized powerpoint presentation that includes these results so that you can incorporate them into your own presentation." ]
                    , p []
                        [ text "By submitting your email you agree to our "
                        , a [ href "/terms", target "_blank", rel "noopener noreferrer" ] [ text "Terms of Service" ]
                        , text " and "
                        , a [ href "/privacy", target "_blank", rel "noopener noreferrer" ] [ text "Privacy Policy" ]
                        , text "."
                        ]
                    , div [ class "col-md-7 mx-auto mt-5" ]
                        [ div [ class "input-group" ]
                            [ input [ type_ "email", required True, placeholder "Email Address", class "form-control", value model.emailAddress, onInput UpdateEmail ] []
                            , i [ class "material-icons", style "color" "rgba(0, 0, 0, 0.42)" ] [ text "chevron_right" ]
                            ]
                        ]
                    ]
                , button [ class "btn btn-primary", onClick RegisterNewUser, disabled <| isValidEmail model.emailAddress ] [ text "Click to save results to the server" ]
                ]
            ]
        ]



-- isValidEmail checks for simple universal email standards
-- Starts with \S+. At least one non whitespace char
-- Must contain an @ symbol
-- Must contain non whitespace after the @


isValidEmail : String -> Bool
isValidEmail email =
    let
        pattern =
            Maybe.withDefault Regex.never <|
                Regex.fromString "(\\S+@{1}\\S+)"

        result =
            if Regex.contains pattern email then
                False

            else
                True
    in
    result


viewRegistered : Model -> Html Msg
viewRegistered model =
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div [ class "jumbotron" ]
                [ h1 [ class "display-4" ] [ text "Thank you for signing up! Please check your email for login information." ]
                , br [] []
                , br [] []
                ]
            ]
        ]


viewSurvey : Survey -> Html Msg
viewSurvey survey =
    case survey of
        Ipsative s ->
            viewIpsativeSurvey s

        Likert s ->
            viewLikertSurvey s


viewLikertSurvey : LikertSurvey -> Html Msg
viewLikertSurvey survey =
    --div [ class "container-fluid" ]
    div [ class "" ]
        [ viewLikertSurveyTitle survey
        , br [] []
        , viewLikertSurveyTable (Zipper.current survey.questions)
        , br [] []
        , viewInlineSurveyInstructions survey.metaData.instructions
        , viewSurveyFooter True
        ]


viewInlineSurveyInstructions : String -> Html Msg
viewInlineSurveyInstructions instructions =
    div [ class "row" ]
        [ div
            [ class "col-lg h5", style "text-align" "center" ]
            [ text instructions ]
        ]


viewLikertSurveyTable : LikertQuestion -> Html Msg
viewLikertSurveyTable surveyQuestion =
    div [ class "row" ]
        [ div [ class "col-md" ]
            [ table [ class "table table-bordered table-hover table-sm" ]
                [ viewLikertSurveyTableHeader surveyQuestion
                , viewLikertSurveyTableRows surveyQuestion
                ]
            ]
        ]


viewLikertSurveyTableRows : LikertQuestion -> Html Msg
viewLikertSurveyTableRows question =
    tbody []
        (List.map
            (\answer ->
                tr [ class "" ]
                    (td [] [ text answer.answer ]
                        :: List.map
                            (\choice ->
                                if isLikertSelected answer choice then
                                    td [ class "bg-success text-white text-center align-middle", onClick (SelectLikertAnswer answer.id choice) ]
                                        [ i [ class "material-icons" ] [ text "check" ] ]

                                else
                                    td [ class "", onClick (SelectLikertAnswer answer.id choice) ]
                                        [ div [ class "" ] []
                                        ]
                            )
                            question.choices
                    )
            )
            question.answers
        )


isLikertSelected : LikertAnswer -> String -> Bool
isLikertSelected answer choice =
    case answer.selectedChoice of
        Just x ->
            if x == choice then
                True

            else
                False

        Nothing ->
            False


viewLikertSurveyTableHeader : LikertQuestion -> Html Msg
viewLikertSurveyTableHeader surveyQuestion =
    thead [ class "thead-light" ]
        [ tr [ class "" ]
            (th [ class " " ] [ text "Statement" ]
                :: List.map
                    (\choice ->
                        th [ class " " ] [ text choice ]
                    )
                    surveyQuestion.choices
            )
        ]


viewIpsativeSurvey : IpsativeSurvey -> Html Msg
viewIpsativeSurvey survey =
    let
        currentQuestion =
            Zipper.current survey.questions

        groupPointsLeft =
            List.head currentQuestion.pointsLeft

        pointsLeft =
            case groupPointsLeft of
                Just points ->
                    points.pointsLeft

                Nothing ->
                    0

        ready =
            pointsLeft == 0
    in
    div []
        [ div [ class "row" ]
            [ viewIpsativeSurveyTitle survey
            , br [] []
            , viewIpsativeSurveyBoxes (Zipper.current survey.questions)

            -- , br [] []
            -- , viewInlineSurveyInstructions survey.metaData.instructions
            ]
        , div [ class "row" ] [ viewSurveyFooter ready ]
        ]


viewLikertSurveyTitle : LikertSurvey -> Html Msg
viewLikertSurveyTitle survey =
    let
        currentQuestion =
            Zipper.current survey.questions

        questionNumber =
            String.fromInt currentQuestion.orderNumber

        totalQuestions =
            List.length (Zipper.toList survey.questions)

        questionTitle =
            currentQuestion.title
    in
    div [ class "row" ]
        [ div [ class "col-lg ", style "text-align" "center" ]
            [ h3 [ class "" ] [ text ("Question " ++ questionNumber ++ " of " ++ String.fromInt totalQuestions) ]
            , h4 [] [ text questionTitle ]
            ]
        ]


viewIpsativeSurveyTitle : IpsativeSurvey -> Html Msg
viewIpsativeSurveyTitle survey =
    let
        currentQuestion =
            Zipper.current survey.questions

        questionNumber =
            List.length (Zipper.before survey.questions) + 1

        totalQuestions =
            List.length (Zipper.toList survey.questions)

        questionTitle =
            currentQuestion.title
    in
    div [ class "col-md-4 d-flex flex-column sticky-top bg-white" ]
        [ img [ class "img-fluid mb-5 pt-3", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ] []
        , div []
            [ h3 [] [ text questionTitle ]
            , p [ class "", style "color" "#B1B1B1" ] [ text ("Q " ++ String.fromInt questionNumber ++ "/" ++ String.fromInt totalQuestions) ]
            , div [ class "row" ] (viewPointsLeft currentQuestion.pointsLeft survey.pointsPerQuestion)
            ]
        ]


viewPointsLeft : List PointsLeft -> Int -> List (Html Msg)
viewPointsLeft pointsLeft pointsPerQuestion =
    List.map
        (\x ->
            div [ class "col-md", style "padding-bottom" "10px" ]
                [ p [] [ text ("Points remaining: " ++ String.fromInt x.pointsLeft ++ " of " ++ String.fromInt pointsPerQuestion) ]
                , div [ class "progress" ]
                    [ div [ class "progress-bar bg-secondary", (\( a, b ) -> style a b) (calculateProgressBarPercent x.pointsLeft pointsPerQuestion) ] []
                    ]
                ]
        )
        pointsLeft


calculateProgressBarPercent : Int -> Int -> ( String, String )
calculateProgressBarPercent current max =
    let
        percent =
            100 * (toFloat current / toFloat max)

        newPercent =
            100 - percent

        percentString =
            String.fromFloat newPercent ++ "%"
    in
    ( "width", percentString )


viewIpsativeSurveyBoxes : IpsativeQuestion -> Html Msg
viewIpsativeSurveyBoxes surveyQuestion =
    div [ class "col-md-8 mt-3 mt-lg-5" ]
        [ div [ class "row" ]
            (List.map
                (\answer ->
                    viewSurveyBox answer
                )
                surveyQuestion.answers
            )
        ]


viewSurveyBox : IpsativeAnswer -> Html Msg
viewSurveyBox answer =
    div [ class "col-md-6 pt-5 no-top-padding" ]
        [ div [ class "question-container" ]
            [ p [ class "question-text" ] [ text answer.answer ]
            , div []
                (List.map
                    (\group -> viewSurveyPointsGroup answer group)
                    answer.pointsAssigned
                )
            ]
        ]


getPointsAssigned : Int -> IpsativeAnswer -> Int
getPointsAssigned group answer =
    let
        filtered =
            List.filter (\x -> x.group == group) answer.pointsAssigned

        first =
            List.head filtered
    in
    case first of
        Just x ->
            x.points

        _ ->
            0


calculatePointsRemaining : List IpsativeAnswer -> Int
calculatePointsRemaining answers =
    let
        group =
            1

        getPoints =
            getPointsAssigned group

        pointsAssignedList =
            List.map getPoints answers

        totalPointsAssigned =
            List.sum pointsAssignedList

        pointsRemaining =
            max 0 (10 - totalPointsAssigned)
    in
    pointsRemaining


calculatePointsLeft : List IpsativeAnswer -> List PointsLeft
calculatePointsLeft answers =
    let
        pointsRemaining =
            calculatePointsRemaining answers
    in
    [ { group = 1, pointsLeft = pointsRemaining } ]


viewSurveyPointsGroup : IpsativeAnswer -> PointsAssigned -> Html Msg
viewSurveyPointsGroup answer group =
    let
        newValue =
            String.fromInt (getPointsAssigned group.group answer)
    in
    div [ class "question-range-container" ]
        [ div [ class "question-slider" ]
            [ input
                [ type_ "range"
                , class "custom-range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "10"
                , value newValue
                , onInput (UpdateAnswer answer group.group)
                ]
                []
            , div [ class "question-list d-flex justify-content-between" ]
                [ ul []
                    [ li [] [ text "0" ]
                    , li [] [ text "1" ]
                    , li [] [ text "2" ]
                    , li [] [ text "3" ]
                    , li [] [ text "4" ]
                    , li [] [ text "5" ]
                    , li [] [ text "6" ]
                    , li [] [ text "7" ]
                    , li [] [ text "8" ]
                    , li [ style "margin-right" "-3px" ] [ text "9" ]
                    , li [] [ text "10" ]
                    ]
                ]
            ]
        ]


viewSurveyFooter : Bool -> Html Msg
viewSurveyFooter ready =
    div [ class "col text-center mt-4" ]
        [ button [ class "btn btn-primary next-question-btn", onClick NextQuestion, disabled (not ready) ] [ text "Next Question" ] ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Transit.subscriptions TransitMsg model.transit
