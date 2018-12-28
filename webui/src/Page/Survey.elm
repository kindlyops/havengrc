module Page.Survey exposing
    ( Msg(..)
    , SavedState
    , TestStructure
    , decodeSavedState
    , init
    , initWithSave
    , testDecoder
    , update
    , view
    )

import Authentication
import Data.Survey
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
import Html exposing (Html, br, button, div, h1, h3, h4, hr, i, input, li, p, table, tbody, td, text, th, thead, tr, ul)
import Html.Attributes exposing (class, disabled, id, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder, andThen, decodeString, field, int, map, map5, oneOf)
import Json.Encode as Encode
import List.Zipper as Zipper
import Ports
import Request.Registration
import Request.Survey
import Utils exposing (getHTTPErrorMessage)
import Views.SurveyCard
import Visualization exposing (myVis)



--TODO: change currentSurvey to Maybe


totalGroups : number
totalGroups =
    1


type alias TestStructure =
    { storedSurvey : SavedState
    }


testDecoder : Decoder TestStructure
testDecoder =
    map TestStructure
        (field "storedSurvey" decodeSavedState)


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
    ( upgradedModel
    , Cmd.batch (initialCommands authModel)
    )


initialModel : Model
initialModel =
    { currentSurvey = Ipsative Data.Survey.emptyIpsativeServerSurvey
    , currentPage = Home
    , availableIpsativeSurveys = []
    , availableLikertSurveys = []
    , selectedSurveyMetaData = Data.Survey.emptyIpsativeServerMetaData
    , isSurveyReady = False
    , inBoundLikertData = Nothing
    , emailAddress = ""
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
    [ Http.send GotServerIpsativeSurveys (Request.Survey.getIpsativeSurveys authModel)
    , Http.send GotServerLikertSurveys (Request.Survey.getLikertSurveys authModel)
    ]


type Msg
    = StartLikertSurvey SurveyMetaData
    | StartIpsativeSurvey SurveyMetaData
    | IncrementAnswer IpsativeAnswer Int
    | DecrementAnswer IpsativeAnswer Int
    | NextQuestion
    | PreviousQuestion
    | GoToHome
    | SelectLikertAnswer String String
    | GotoQuestion Int
    | GetIpsativeSurveys
    | GetLikertSurveys
    | GotServerIpsativeSurveys (Result Http.Error (List Data.Survey.SurveyMetaData))
    | GotIpsativeServerData (Result Http.Error (List Data.Survey.IpsativeServerData))
    | GotServerLikertSurveys (Result Http.Error (List Data.Survey.SurveyMetaData))
    | GotLikertServerData (Result Http.Error (List Data.Survey.LikertServerData))
    | GotLikertChoices (Result Http.Error (List Data.Survey.LikertServerChoice))
    | UpdateEmail String
    | RegisterNewUser
    | NewUserRegistered (Result Http.Error String)
    | SaveCurrentSurvey
    | IpsativeSurveySaved (Result Http.Error (List Data.Survey.IpsativeResponse))
    | LikertSurveySaved (Result Http.Error (List Data.Survey.LikertResponse))


update : Msg -> Model -> Authentication.Model -> ( Model, Cmd Msg )
update msg model authModel =
    case msg of
        UpdateEmail newEmail ->
            ( { model | emailAddress = newEmail }
            , Cmd.none
            )

        RegisterNewUser ->
            case model.currentSurvey of
                Ipsative survey ->
                    ( model
                    , Http.send NewUserRegistered (Request.Registration.post survey model.emailAddress authModel)
                    )

                Likert survey ->
                    ( initialModel
                    , Cmd.none
                    )

        SaveCurrentSurvey ->
            case model.currentSurvey of
                Ipsative survey ->
                    ( model
                    , Http.send IpsativeSurveySaved (Request.Survey.postIpsativeResponse authModel survey)
                    )

                Likert survey ->
                    ( model
                    , Http.send LikertSurveySaved (Request.Survey.postLikertResponses authModel survey)
                    )

        NewUserRegistered (Err error) ->
            -- TODO: figure out how to handle "New User error" error
            ( initialModel
            , Cmd.none
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
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        IpsativeSurveySaved (Ok responses) ->
            ( initialModel
            , Cmd.none
            )

        LikertSurveySaved (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        LikertSurveySaved (Ok responses) ->
            ( initialModel
            , Cmd.none
            )

        GetIpsativeSurveys ->
            ( model
            , Http.send GotServerIpsativeSurveys (Request.Survey.getIpsativeSurveys authModel)
            )

        GetLikertSurveys ->
            ( model
            , Http.send GotServerLikertSurveys (Request.Survey.getLikertSurveys authModel)
            )

        GotServerIpsativeSurveys (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        GotServerIpsativeSurveys (Ok surveys) ->
            ( { model | availableIpsativeSurveys = surveys }
            , Cmd.none
            )

        GotServerLikertSurveys (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        GotServerLikertSurveys (Ok surveys) ->
            ( { model | availableLikertSurveys = surveys }
            , Cmd.none
            )

        GotIpsativeServerData (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        GotIpsativeServerData (Ok data) ->
            let
                questions =
                    Data.Survey.groupIpsativeSurveyData data

                survey =
                    Data.Survey.createIpsativeSurvey 10 totalGroups model.selectedSurveyMetaData questions
            in
            ( { model | currentSurvey = survey, isSurveyReady = True }
            , Cmd.none
            )

        GotLikertServerData (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

        GotLikertServerData (Ok data) ->
            ( { model | inBoundLikertData = Just data }
            , Http.send GotLikertChoices (Request.Survey.getLikertChoices authModel model.selectedSurveyMetaData.uuid)
            )

        GotLikertChoices (Err error) ->
            ( model
            , Cmd.none
              -- TODO refactor Ports.showError (getHTTPErrorMessage error)
            )

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
            , Http.send GotLikertServerData (Request.Survey.getLikertSurvey authModel metaData.uuid)
            )

        StartIpsativeSurvey metaData ->
            ( { model | currentPage = Survey, selectedSurveyMetaData = metaData }
            , Http.send GotIpsativeServerData (Request.Survey.getIpsativeSurvey authModel metaData.uuid)
            )

        NextQuestion ->
            --   let
            --         ( newModel, cmd ) =
            --             if validateSurvey model.currentSurvey then
            --                 ( { model | currentPage = Finished }, Ports.renderVega myVis )
            --             else
            --                 ( { model | currentPage = IncompleteSurvey }, Cmd.none )
            --     in
            --     newModel ! [ storeSurvey newModel (getQuestionNumber newModel), cmd ]
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
                            let
                                newModel =
                                    { model | currentPage = Finished }

                                cmd =
                                    Ports.renderVega myVis
                            in
                            ( newModel
                            , Cmd.batch [ storeSurvey newModel (getQuestionNumber newModel), cmd ]
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
                                    Ports.renderVega myVis
                            in
                            ( newModel
                            , Cmd.batch [ storeSurvey newModel (getQuestionNumber newModel), cmd ]
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
    div [ class "" ]
        [ h1 [ class "display-4" ] [ text "KindlyOps Haven Survey" ]
        , p [ class "lead" ] [ text "Welcome to the Elm Haven Survey. " ]
        , hr [ class "my-4" ] []
        , p [ class "" ] [ text "Lets get started! " ]
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
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div [ class "jumbotron" ]
                [ h1 [ class "display-4" ] [ text "You finished the survey!" ]
                , button [ class "btn btn-primary", onClick SaveCurrentSurvey ] [ text "Click to save results to the server." ]
                ]
            ]
        ]


viewRegistration : Model -> Html Msg
viewRegistration model =
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div [ class "jumbotron" ]
                [ h1 [ class "display-4" ] [ text "You finished the survey! Please enter your email address to save the survey." ]
                , input [ placeholder "Email Address", value model.emailAddress, onInput UpdateEmail ] []
                , br [] []
                , br [] []
                , div [ class "vis", id "vis" ] []
                , br [] []
                , br [] []
                , button [ class "btn btn-primary", onClick RegisterNewUser ] [ text "Click to save results to the server." ]
                ]
            ]
        ]


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
    div [ class "" ]
        [ viewIpsativeSurveyTitle survey
        , br [] []
        , viewIpsativeSurveyBoxes (Zipper.current survey.questions)
        , br [] []
        , viewInlineSurveyInstructions survey.metaData.instructions
        , viewSurveyFooter ready
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
    div [ class "row" ]
        [ div [ class "col-lg ", style "text-align" "center" ]
            [ h3 [ class "" ] [ text ("Question " ++ String.fromInt questionNumber ++ " of " ++ String.fromInt totalQuestions) ]
            , h4 [] [ text questionTitle ]
            , div [ class "row" ] (viewPointsLeft currentQuestion.pointsLeft survey.pointsPerQuestion)
            ]
        ]


viewPointsLeft : List PointsLeft -> Int -> List (Html Msg)
viewPointsLeft pointsLeft pointsPerQuestion =
    List.map
        (\x ->
            div [ class "col-md" ]
                [ p [] [ text ("Group " ++ String.fromInt x.group ++ ": " ++ String.fromInt x.pointsLeft ++ "/" ++ String.fromInt pointsPerQuestion) ]
                , div [ class "progress" ]
                    [ div [ class "progress-bar bg-primary", (\( a, b ) -> style a b) (calculateProgressBarPercent x.pointsLeft pointsPerQuestion) ] []
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
            String.fromFloat percent ++ "%"
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
                [ div [ class "card-padder", style "height" "120px" ]
                    [ p [ class "card-text h5 mb-4" ] [ text answer.answer ] ]
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
            [ div [ class "align-self-center" ] []
            , div [ class "" ]
                [ button
                    [ type_ "button"
                    , class "btn btn-outline-primary"
                    , onClick (DecrementAnswer answer group.group)
                    ]
                    [ i [ class "material-icons" ] [ text "remove" ] ]
                ]
            , div [ class "align-self-center" ] [ p [ class "card-text   " ] [ text (String.fromInt group.points) ] ]
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


viewSurveyFooter : Bool -> Html Msg
viewSurveyFooter ready =
    div [ class "row mb-4 pb-4 px-3 d-flex justify-content-between" ]
        [ button [ class "btn btn-default btn-lg mx-1", onClick GoToHome ] [ text "Quit Survey" ]
        , button [ class "btn btn-primary btn-lg mx-1", onClick NextQuestion, disabled (not ready) ] [ text "Next" ]
        ]
