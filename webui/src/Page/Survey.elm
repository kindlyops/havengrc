module Page.Survey
    exposing
        ( Model
        , init
        , initWithSave
        , update
        , Msg(..)
        , view
        , SavedState
        , decodeSavedState
        , TestStructure
        , testDecoder
        )

import Data.Survey
    exposing
        ( Survey(..)
        , IpsativeSurvey
        , LikertSurvey
        , LikertQuestion
        , IpsativeQuestion
        , PointsLeft
        , PointsAssigned
        , IpsativeAnswer
        , LikertAnswer
        , SurveyMetaData
        , encodeSurvey
        , encodeSurveyData
        , encodeSurveyMetaData
        , InitialSurvey
        , upgradeSurvey
        , decodeSurveyMetaData
        , decodeInitialSurvey
        )
import Html exposing (Html, div, h1, text, p, button, hr, br, table, tbody, tr, td, i, thead, th, ul, li, h3, h4)
import Html.Attributes exposing (class, disabled, style, type_)
import Html.Events exposing (onClick)
import List.Zipper as Zipper
import Authentication
import Http
import Request.Survey
import Ports
import Views.SurveyCard
import Utils exposing (getHTTPErrorMessage)
import Json.Encode as Encode
import Json.Decode as Decode exposing (Decoder, decodeString, int, andThen, oneOf)
import Json.Decode.Pipeline exposing (decode, required)


type SurveyPage
    = Home
    | SurveyInstructions
    | Survey
    | IncompleteSurvey
    | Finished


type alias Model =
    { currentSurvey : Survey
    , currentPage : SurveyPage
    , availableIpsativeSurveys : List SurveyMetaData
    , availableLikertSurveys : List SurveyMetaData
    , selectedSurveyMetaData : SurveyMetaData
    , isSurveyReady : Bool
    , inBoundLikertData : Maybe (List Data.Survey.LikertServerData)
    }



--TODO: change currentSurvey to Maybe


type alias TestStructure =
    { storedSurvey : SavedState
    }


testDecoder : Decoder TestStructure
testDecoder =
    decode TestStructure
        |> required "storedSurvey" decodeSavedState


type alias SavedState =
    { currentPage : SurveyPage
    , surveyData : InitialSurvey
    , selectedSurveyMetaData : SurveyMetaData
    , isSurveyReady : Bool
    , currentQuestionNumber : Int
    }


decodeSavedState : Decoder SavedState
decodeSavedState =
    decode SavedState
        |> required "currentPage" (decodeCurrentPage)
        |> required "surveyData" (decodeInitialSurvey)
        |> required "selectedSurveyMetaData" (decodeSurveyMetaData)
        |> required "isSurveyReady" Decode.bool
        |> required "currentQuestionNumber" Decode.int


decodeCurrentPage : Decoder SurveyPage
decodeCurrentPage =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "Home" ->
                        Decode.succeed Home

                    "SurveyInstructions" ->
                        Decode.succeed SurveyInstructions

                    "Survey" ->
                        Decode.succeed Survey

                    "IncompleteSurvey" ->
                        Decode.succeed IncompleteSurvey

                    "Finished" ->
                        Decode.succeed Finished

                    somethingElse ->
                        Decode.fail <| "Unknown theme: " ++ somethingElse
            )


init : Authentication.Model -> ( Model, Cmd Msg )
init authModel =
    initialModel
        ! initialCommands authModel


initWithSave : Authentication.Model -> TestStructure -> ( Model, Cmd Msg )
initWithSave authModel testStructure =
    let
        savedState =
            testStructure.storedSurvey

        upgradedSurvey =
            upgradeSurvey savedState.surveyData savedState.selectedSurveyMetaData savedState.currentQuestionNumber

        upgradedModel =
            case upgradedSurvey of
                Ipsative survey ->
                    { initialModel
                        | currentSurvey = upgradedSurvey
                        , currentPage = savedState.currentPage
                        , selectedSurveyMetaData = savedState.selectedSurveyMetaData
                        , isSurveyReady = savedState.isSurveyReady
                    }

                Likert survey ->
                    { initialModel
                        | currentSurvey = upgradedSurvey
                        , currentPage = savedState.currentPage
                        , selectedSurveyMetaData = savedState.selectedSurveyMetaData
                        , isSurveyReady = savedState.isSurveyReady
                    }
    in
        upgradedModel
            ! initialCommands authModel


initialModel : Model
initialModel =
    { currentSurvey = Ipsative Data.Survey.emptyIpsativeServerSurvey
    , currentPage = Home
    , availableIpsativeSurveys = []
    , availableLikertSurveys = []
    , selectedSurveyMetaData = Data.Survey.emptyIpsativeServerMetaData
    , isSurveyReady = False
    , inBoundLikertData = Nothing
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

        SurveyInstructions ->
            "SurveyInstructions"

        Survey ->
            "Survey"

        IncompleteSurvey ->
            "IncompleteSurvey"

        Finished ->
            "Finished"


initialCommands : Authentication.Model -> List (Cmd Msg)
initialCommands authModel =
    if Authentication.isLoggedIn authModel then
        surveyRequests authModel
    else
        []


surveyRequests : Authentication.Model -> List (Cmd Msg)
surveyRequests authModel =
    [ Http.send GotServerIpsativeSurveys (Request.Survey.getIpsativeSurveys authModel)
    , Http.send GotServerLikertSurveys (Request.Survey.getLikertSurveys authModel)
    ]


type Msg
    = BeginLikertSurvey
    | BeginIpsativeSurvey
    | StartLikertSurvey SurveyMetaData
    | StartIpsativeSurvey SurveyMetaData
    | IncrementAnswer IpsativeAnswer Int
    | DecrementAnswer IpsativeAnswer Int
    | NextQuestion
    | PreviousQuestion
    | GoToHome
    | FinishSurvey
    | SelectLikertAnswer String String
    | GotoQuestion Int
    | GetIpsativeSurveys
    | GetLikertSurveys
    | GotServerIpsativeSurveys (Result Http.Error (List Data.Survey.SurveyMetaData))
    | GotIpsativeServerData (Result Http.Error (List Data.Survey.IpsativeServerData))
    | GotServerLikertSurveys (Result Http.Error (List Data.Survey.SurveyMetaData))
    | GotLikertServerData (Result Http.Error (List Data.Survey.LikertServerData))
    | GotLikertChoices (Result Http.Error (List Data.Survey.LikertServerChoice))
    | SaveCurrentSurvey
    | IpsativeSurveySaved (Result Http.Error (List Data.Survey.IpsativeResponse))
    | LikertSurveySaved (Result Http.Error (List Data.Survey.LikertResponse))


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        SaveCurrentSurvey ->
            case model.currentSurvey of
                Ipsative survey ->
                    model ! [ Http.send IpsativeSurveySaved (Request.Survey.postIpsativeResponse authModel survey) ]

                Likert survey ->
                    model ! [ Http.send LikertSurveySaved (Request.Survey.postLikertResponses authModel survey) ]

        IpsativeSurveySaved (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        IpsativeSurveySaved (Ok responses) ->
            let
                _ =
                    Debug.log "saved response" responses
            in
                initialModel ! []

        LikertSurveySaved (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        LikertSurveySaved (Ok responses) ->
            let
                _ =
                    Debug.log "saved response" responses
            in
                initialModel ! []

        GetIpsativeSurveys ->
            model ! [ Http.send GotServerIpsativeSurveys (Request.Survey.getIpsativeSurveys authModel) ]

        GetLikertSurveys ->
            model ! [ Http.send GotServerLikertSurveys (Request.Survey.getLikertSurveys authModel) ]

        GotServerIpsativeSurveys (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        GotServerIpsativeSurveys (Ok surveys) ->
            { model | availableIpsativeSurveys = surveys } ! []

        GotServerLikertSurveys (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        GotServerLikertSurveys (Ok surveys) ->
            { model | availableLikertSurveys = surveys } ! []

        GotIpsativeServerData (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        GotIpsativeServerData (Ok data) ->
            let
                questions =
                    Data.Survey.groupIpsativeSurveyData data

                survey =
                    Data.Survey.createIpsativeSurvey 10 2 model.selectedSurveyMetaData questions
            in
                { model | currentSurvey = survey, isSurveyReady = True } ! []

        GotLikertServerData (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        GotLikertServerData (Ok data) ->
            { model | inBoundLikertData = Just data }
                ! [ Http.send GotLikertChoices (Request.Survey.getLikertChoices authModel model.selectedSurveyMetaData.uuid)
                  ]

        GotLikertChoices (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        GotLikertChoices (Ok serverChoices) ->
            let
                questions =
                    case model.inBoundLikertData of
                        Just x ->
                            Data.Survey.groupLikertSurveyData x

                        Nothing ->
                            []

                survey =
                    Data.Survey.createLikertSurvey model.selectedSurveyMetaData questions serverChoices

                isSurveyReady =
                    True
            in
                { model | currentSurvey = survey, isSurveyReady = isSurveyReady }
                    ! []

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
                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

        GoToHome ->
            let
                newModel =
                    { model | currentPage = Home }
            in
                newModel ! ((storeSurvey newModel (getQuestionNumber newModel)) :: (surveyRequests authModel))

        FinishSurvey ->
            let
                newModel =
                    if validateSurvey model.currentSurvey then
                        { model | currentPage = Finished }
                    else
                        { model | currentPage = IncompleteSurvey }
            in
                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

        BeginLikertSurvey ->
            let
                newModel =
                    { model | currentPage = Survey }
            in
                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

        BeginIpsativeSurvey ->
            let
                newModel =
                    { model | currentPage = Survey }
            in
                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

        StartLikertSurvey metaData ->
            { model | currentPage = SurveyInstructions, selectedSurveyMetaData = metaData } ! [ Http.send GotLikertServerData (Request.Survey.getLikertSurvey authModel metaData.uuid) ]

        StartIpsativeSurvey metaData ->
            { model | currentPage = SurveyInstructions, selectedSurveyMetaData = metaData } ! [ Http.send GotIpsativeServerData (Request.Survey.getIpsativeSurvey authModel metaData.uuid) ]

        NextQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Ipsative { survey | questions = x } }
                            in
                                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

                        _ ->
                            model ! []

                Likert survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Likert { survey | questions = x } }
                            in
                                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

                        _ ->
                            model ! []

        PreviousQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.previous survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Ipsative { survey | questions = x } }
                            in
                                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

                        _ ->
                            model ! []

                Likert survey ->
                    case Zipper.previous survey.questions of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Likert { survey | questions = x } }
                            in
                                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

                        _ ->
                            model ! []

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
                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

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
                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

        GotoQuestion questionNumber ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.find (\x -> x.orderNumber == questionNumber) (Zipper.first survey.questions) of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Ipsative { survey | questions = x }, currentPage = Survey }
                            in
                                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

                        _ ->
                            model ! []

                Likert survey ->
                    case Zipper.find (\x -> x.orderNumber == questionNumber) (Zipper.first survey.questions) of
                        Just x ->
                            let
                                newModel =
                                    { model | currentSurvey = Likert { survey | questions = x }, currentPage = Survey }
                            in
                                newModel ! [ (storeSurvey newModel (getQuestionNumber newModel)) ]

                        _ ->
                            model ! []


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
        Ipsative survey ->
            --Survey question is good if all the points for all the groups for all the answers is zero
            List.foldr
                (\question incompleteQuestions ->
                    if validateIpsativeQuestion question then
                        incompleteQuestions
                    else
                        question.orderNumber :: incompleteQuestions
                )
                []
                (Zipper.toList survey.questions)

        Likert survey ->
            --Survey question is good if all the answers have a selectedChoice
            List.foldr
                (\question incompleteQuestions ->
                    if validateLikertQuestion question then
                        incompleteQuestions
                    else
                        question.orderNumber :: incompleteQuestions
                )
                []
                (Zipper.toList survey.questions)


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
    case model.currentPage of
        Home ->
            viewHero model

        SurveyInstructions ->
            viewSurveyInstructions model.currentSurvey model.isSurveyReady

        Survey ->
            viewSurvey model.currentSurvey

        IncompleteSurvey ->
            viewIncomplete model.currentSurvey

        Finished ->
            viewFinished model


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
            div [ class "my-2" ] [ button [ class "btn btn-primary", onClick (GotoQuestion questionNumber) ] [ text ("Click to go back to question " ++ toString questionNumber) ] ]
        )
        questionNumbers


viewSurveyInstructions : Survey -> Bool -> Html Msg
viewSurveyInstructions survey isSurveyReady =
    case survey of
        Ipsative survey ->
            viewIpsativeSurveyInstructions survey isSurveyReady

        Likert survey ->
            viewLikertSurveyInstructions survey isSurveyReady


viewIpsativeSurveyInstructions : IpsativeSurvey -> Bool -> Html Msg
viewIpsativeSurveyInstructions survey isSurveyReady =
    div [ class "pt-3" ]
        [ div [ class "row" ]
            [ div
                [ class "col" ]
                [ h1 [ class "display-4" ] [ text survey.metaData.name ]
                , p [ class "lead" ] [ text survey.metaData.instructions ]
                , hr [ class "my-4" ] []
                , button [ class "btn btn-primary", disabled (not isSurveyReady), onClick BeginIpsativeSurvey ] [ text "Begin" ]
                ]
            ]
        ]


viewLikertSurveyInstructions : LikertSurvey -> Bool -> Html Msg
viewLikertSurveyInstructions survey isSurveyReady =
    div [ class "pt-3" ]
        [ div [ class "row" ]
            [ div
                [ class "col" ]
                [ h1 [ class "display-4" ] [ text survey.metaData.name ]
                , p [ class "lead" ] [ text survey.metaData.instructions ]
                , hr [ class "my-4" ] []
                , button [ class "btn btn-primary", disabled (not isSurveyReady), onClick BeginLikertSurvey ] [ text "Begin" ]
                ]
            ]
        ]


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
    div [ class "" ]
        [ h1 [ class "display-4" ] [ text "KindlyOps Haven Survey" ]
        , p [ class "lead" ] [ text "Welcome to the Elm Haven Survey. " ]
        , button [ class "btn btn-secondary", onClick GetIpsativeSurveys ] [ text "get ipsative surveys (debug)" ]
        , button [ class "btn btn-secondary", onClick GetLikertSurveys ] [ text "get likert surveys (debug)" ]
        , hr [ class "my-4" ] []
        , p [ class "" ] [ text ("There are currently " ++ toString (getTotalAvailableSurveys model) ++ " surveys to choose from.") ]
        , div [ class "row" ]
            (List.map
                (\availableSurvey ->
                    div [ class "col-6 mb-4" ]
                        [ Views.SurveyCard.view availableSurvey "Ipsative" (StartIpsativeSurvey availableSurvey)
                        ]
                )
                model.availableIpsativeSurveys
            )
        , div [ class "row" ]
            (List.map
                (\availableSurvey ->
                    div [ class "col-6 mb-4" ]
                        [ Views.SurveyCard.view availableSurvey "Likert" (StartLikertSurvey availableSurvey)
                        ]
                )
                model.availableLikertSurveys
            )
        ]


viewFinished : Model -> Html Msg
viewFinished model =
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div [ class "jumbotron" ]
                [ h1 [ class "display-4" ] [ text "You finished the survey!" ]
                , button [ class "btn btn-primary", onClick SaveCurrentSurvey ] [ text "Click to save results to the server." ]
                ]
            ]
        ]


viewSurvey : Survey -> Html Msg
viewSurvey survey =
    case survey of
        Ipsative survey ->
            viewIpsativeSurvey survey

        Likert survey ->
            viewLikertSurvey survey


viewLikertSurvey : LikertSurvey -> Html Msg
viewLikertSurvey survey =
    --div [ class "container-fluid" ]
    div [ class "" ]
        [ viewLikertSurveyTitle survey
        , br [] []
        , viewLikertSurveyTable (Zipper.current survey.questions)
        , br [] []
        , viewSurveyFooter
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
    div [ class "" ]
        [ viewIpsativeSurveyTitle survey
        , br [] []
        , viewIpsativeSurveyBoxes (Zipper.current survey.questions)
        , br [] []
        , viewSurveyFooter
        ]


viewLikertSurveyTitle : LikertSurvey -> Html Msg
viewLikertSurveyTitle survey =
    let
        currentQuestion =
            Zipper.current survey.questions

        questionNumber =
            toString currentQuestion.orderNumber

        totalQuestions =
            List.length (Zipper.toList survey.questions)

        questionTitle =
            currentQuestion.title
    in
        div [ class "row" ]
            [ div [ class "col-lg ", style [ ( "text-align", "center" ) ] ]
                [ h3 [ class "" ] [ text ("Question " ++ questionNumber ++ " of " ++ toString totalQuestions) ]
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
        div [ class "row" ]
            [ div [ class "col-lg ", style [ ( "text-align", "center" ) ] ]
                [ h3 [ class "" ] [ text ("Question " ++ toString questionNumber ++ " of " ++ toString totalQuestions) ]
                , h4 [] [ text questionTitle ]
                , div [ class "row" ] (viewPointsLeft currentQuestion.pointsLeft survey.pointsPerQuestion)
                ]
            ]


viewPointsLeft : List PointsLeft -> Int -> List (Html Msg)
viewPointsLeft pointsLeft pointsPerQuestion =
    List.map
        (\x ->
            div [ class "col-md" ]
                [ p [] [ text ("Group " ++ toString x.group ++ ": " ++ toString x.pointsLeft ++ "/" ++ toString pointsPerQuestion) ]
                , div [ class "progress" ]
                    [ div [ class "progress-bar bg-primary", style [ calculateProgressBarPercent x.pointsLeft pointsPerQuestion ] ] []
                    ]
                ]
        )
        pointsLeft


calculateProgressBarPercent : Int -> Int -> ( String, String )
calculateProgressBarPercent current max =
    let
        percent =
            100 * (toFloat current / toFloat max)

        percentString =
            toString percent ++ "%"
    in
        ( "width", percentString )


viewIpsativeSurveyBoxes : IpsativeQuestion -> Html Msg
viewIpsativeSurveyBoxes surveyQuestion =
    div [ class "row" ]
        (List.map
            (\answer ->
                viewSurveyBox answer
            )
            surveyQuestion.answers
        )


viewSurveyBox : IpsativeAnswer -> Html Msg
viewSurveyBox answer =
    div [ class "col-md-6" ]
        [ div [ class "card mb-4 box-shadow" ]
            [ div [ class "card-body" ]
                [ p [ class "card-text h5 mb-4" ] [ text answer.answer ]
                , ul [ class "list-group list-group-flush" ]
                    (List.map
                        (\group -> viewSurveyPointsGroup answer group)
                        answer.pointsAssigned
                    )
                ]
            ]
        ]


viewSurveyPointsGroup : IpsativeAnswer -> PointsAssigned -> Html Msg
viewSurveyPointsGroup answer group =
    li [ class "list-group-item" ]
        [ div [ class "d-flex justify-content-between" ]
            [ div [ class "align-self-center" ] [ p [ class "card-text" ] [ text ("Group " ++ toString group.group ++ ":") ] ]
            , div [ class "" ]
                [ button
                    [ type_ "button"
                    , class "btn btn-outline-primary"
                    , onClick (DecrementAnswer answer group.group)
                    ]
                    [ i [ class "material-icons" ] [ text "remove" ] ]
                ]
            , div [ class "align-self-center" ] [ p [ class "card-text   " ] [ text (toString group.points) ] ]
            , div [ class "" ]
                [ button
                    [ type_ "button"
                    , class "btn btn-outline-primary"
                    , onClick (IncrementAnswer answer group.group)
                    ]
                    [ i [ class "material-icons" ] [ text "add" ] ]
                ]
            ]
        ]


viewSurveyFooter : Html Msg
viewSurveyFooter =
    div [ class "row mb-4 pb-4 " ]
        [ div [ class "col-3" ] [ button [ class "btn btn-primary btn-lg mx-1", onClick GoToHome ] [ text "Back" ] ]
        , div [ class "col-3" ] [ button [ class "btn btn-default btn-lg mx-1", onClick PreviousQuestion ] [ text "<" ] ]
        , div [ class "col-3" ] [ button [ class "btn btn-default btn-lg mx-1", onClick NextQuestion ] [ text ">" ] ]
        , div [ class "col-3" ] [ button [ class "btn btn-primary btn-lg mx-1", onClick FinishSurvey ] [ text "Finish" ] ]
        ]
