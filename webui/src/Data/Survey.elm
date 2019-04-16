module Data.Survey exposing
    ( InitialSurvey
    , IpsativeAnswer
    , IpsativeQuestion
    , IpsativeResponse
    , IpsativeServerData
    , IpsativeSingleResponse
    , IpsativeSurvey
    , LikertAnswer
    , LikertQuestion
    , LikertResponse
    , LikertServerChoice
    , LikertServerData
    , LikertSurvey
    , Model
    , PointsAssigned
    , PointsLeft
    , Survey(..)
    , SurveyMetaData
    , SurveyPage(..)
    , createIpsativeSurvey
    , createLikertSurvey
    , decodeInitialSurvey
    , decodeSurveyMetaData
    , emptyIpsativeServerMetaData
    , emptyIpsativeServerSurvey
    , encodeSurvey
    , encodeSurveyData
    , encodeSurveyMetaData
    , getAllResponsesFromIpsativeSurvey
    , groupIpsativeSurveyData
    , groupLikertSurveyData
    , ipsativeResponseDecoder
    , ipsativeResponseEncoder
    , ipsativeSingleResponseEncoder
    , ipsativeSurveyDataDecoder
    , likertResponseDecoder
    , likertResponseEncoder
    , likertSurveyChoicesDecoder
    , likertSurveyDataDecoder
    , upgradeSurvey
    )

import Json.Decode as Decode exposing (Decoder, andThen, field, int, map2, map3, map4, map5, map6, map7, map8, oneOf, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode
import List.Extra
import List.Zipper as Zipper
import Page.Errors exposing (ErrorData)
import Utils exposing (smashList)


type SurveyPage
    = Home
    | Survey
    | IncompleteSurvey
    | Finished
    | Registered


type alias Model =
    { currentSurvey : Survey
    , currentPage : SurveyPage
    , availableIpsativeSurveys : List SurveyMetaData
    , availableLikertSurveys : List SurveyMetaData
    , selectedSurveyMetaData : SurveyMetaData
    , isSurveyReady : Bool
    , inBoundLikertData : Maybe (List LikertServerData)
    , emailAddress : String
    , errorModel : ErrorData
    }


type Survey
    = Ipsative IpsativeSurvey
    | Likert LikertSurvey


type InitialSurvey
    = IpsativeWithoutZipper IpsativeSurveyWithoutZipper
    | LikertWithoutZipper LikertSurveyWithoutZipper


decodeInitialSurvey : Decoder InitialSurvey
decodeInitialSurvey =
    Decode.oneOf
        [ Decode.map IpsativeWithoutZipper <| decodeIpsativeSurveyWithoutZipper
        , Decode.map LikertWithoutZipper <| decodeLikertSurveyWithoutZipper
        ]


type alias IpsativeSurvey =
    { metaData : SurveyMetaData
    , pointsPerQuestion : Int
    , numGroups : Int
    , questions : Zipper.Zipper IpsativeQuestion
    }


type alias IpsativeSurveyWithoutZipper =
    { metaData : SurveyMetaData
    , pointsPerQuestion : Int
    , numGroups : Int
    , questions : List IpsativeQuestion
    }


type alias IpsativeResponse =
    { uuid : String
    , created_at : String
    , user_email : String
    , user_id : String
    , answer_id : String
    , group_number : Int
    , points_assigned : Int
    }


encodeSurvey : Survey -> Encode.Value
encodeSurvey survey =
    Encode.object
        [ ( "type", Encode.string (encodeSurveyType survey) )
        , ( "data", encodeSurveyData survey )
        ]


encodeSurveyType : Survey -> String
encodeSurveyType survey =
    case survey of
        Ipsative s ->
            "Ipsative"

        Likert s ->
            "Likert"


encodeSurveyData : Survey -> Encode.Value
encodeSurveyData survey =
    case survey of
        Ipsative s ->
            let
                ipsativeSurveyWithoutZipper =
                    downgradeIpsativeSurvey s
            in
            encodeipsativeSurveyWithoutZipper ipsativeSurveyWithoutZipper

        Likert s ->
            let
                likertSurveyWithoutZipper =
                    downgradeLikertSurvey s
            in
            encodeLikertSurveyWithoutZipper likertSurveyWithoutZipper


upgradeSurvey : InitialSurvey -> SurveyMetaData -> Int -> Survey
upgradeSurvey initialSurvey metaData currentQuestionNumber =
    case initialSurvey of
        IpsativeWithoutZipper survey ->
            upgradeIpsativeSurvey survey metaData currentQuestionNumber

        LikertWithoutZipper survey ->
            upgradeLikertSurvey survey metaData currentQuestionNumber


upgradeIpsativeSurvey : IpsativeSurveyWithoutZipper -> SurveyMetaData -> Int -> Survey
upgradeIpsativeSurvey survey metaData currentQuestionNumber =
    let
        initialQuestions =
            Zipper.fromList survey.questions |> Zipper.withDefault emptyIpsativeQuestion

        focusedQuestions =
            case Zipper.find (\x -> x.orderNumber == currentQuestionNumber) (Zipper.first initialQuestions) of
                Just x ->
                    x

                _ ->
                    Zipper.singleton emptyIpsativeQuestion
    in
    Ipsative
        { metaData = metaData
        , pointsPerQuestion = survey.pointsPerQuestion
        , numGroups = survey.numGroups
        , questions = focusedQuestions
        }


upgradeLikertSurvey : LikertSurveyWithoutZipper -> SurveyMetaData -> Int -> Survey
upgradeLikertSurvey survey metaData currentQuestionNumber =
    let
        initialQuestions =
            Zipper.fromList survey.questions |> Zipper.withDefault emptyLikertQuestion

        focusedQuestions =
            case Zipper.find (\x -> x.orderNumber == currentQuestionNumber) (Zipper.first initialQuestions) of
                Just x ->
                    x

                _ ->
                    Zipper.singleton emptyLikertQuestion
    in
    Likert
        { metaData = metaData
        , questions = focusedQuestions
        }


downgradeIpsativeSurvey : IpsativeSurvey -> IpsativeSurveyWithoutZipper
downgradeIpsativeSurvey survey =
    let
        downgraded =
            { metaData = survey.metaData
            , pointsPerQuestion = survey.pointsPerQuestion
            , numGroups = survey.numGroups
            , questions = Zipper.toList survey.questions
            }
    in
    downgraded


downgradeLikertSurvey : LikertSurvey -> LikertSurveyWithoutZipper
downgradeLikertSurvey survey =
    let
        downgraded =
            { metaData = survey.metaData
            , questions = Zipper.toList survey.questions
            }
    in
    downgraded


encodeipsativeSurveyWithoutZipper : IpsativeSurveyWithoutZipper -> Encode.Value
encodeipsativeSurveyWithoutZipper surveyWithoutZipper =
    Encode.object
        [ ( "metaData", encodeSurveyMetaData <| surveyWithoutZipper.metaData )
        , ( "pointsPerQuestion", Encode.int <| surveyWithoutZipper.pointsPerQuestion )
        , ( "numGroups", Encode.int <| surveyWithoutZipper.numGroups )
        , ( "questions", surveyWithoutZipper.questions |> Encode.list encodeIpsativeQuestion )
        ]


encodeLikertSurveyWithoutZipper : LikertSurveyWithoutZipper -> Encode.Value
encodeLikertSurveyWithoutZipper surveyWithoutZipper =
    Encode.object
        [ ( "metaData", surveyWithoutZipper.metaData |> encodeSurveyMetaData )
        , ( "questions", surveyWithoutZipper.questions |> Encode.list encodeLikertQuestion )
        ]


encodeSurveyMetaData : SurveyMetaData -> Encode.Value
encodeSurveyMetaData surveyMetaData =
    Encode.object
        [ ( "uuid", Encode.string <| surveyMetaData.uuid )
        , ( "created_at", Encode.string <| surveyMetaData.created_at )
        , ( "name", Encode.string <| surveyMetaData.name )
        , ( "description", Encode.string <| surveyMetaData.description )
        , ( "instructions", Encode.string <| surveyMetaData.instructions )
        , ( "author", Encode.string <| surveyMetaData.author )
        ]


encodeIpsativeQuestion : IpsativeQuestion -> Encode.Value
encodeIpsativeQuestion ipsativeQuestion =
    Encode.object
        [ ( "id", Encode.string <| ipsativeQuestion.id )
        , ( "title", Encode.string <| ipsativeQuestion.title )
        , ( "orderNumber", Encode.int <| ipsativeQuestion.orderNumber )
        , ( "pointsLeft", ipsativeQuestion.pointsLeft |> Encode.list encodePointsLeft )
        , ( "answers", ipsativeQuestion.answers |> Encode.list encodeIpsativeAnswer )
        ]


encodeLikertQuestion : LikertQuestion -> Encode.Value
encodeLikertQuestion likertQuestion =
    Encode.object
        [ ( "id", Encode.string <| likertQuestion.id )
        , ( "title", Encode.string <| likertQuestion.title )
        , ( "orderNumber", Encode.int <| likertQuestion.orderNumber )
        , ( "choices", likertQuestion.choices |> Encode.list Encode.string )
        , ( "answers", likertQuestion.answers |> Encode.list encodeLikertAnswer )
        ]


encodePointsLeft : PointsLeft -> Encode.Value
encodePointsLeft pointsLeft =
    Encode.object
        [ ( "group", Encode.int <| pointsLeft.group )
        , ( "pointsLeft", Encode.int <| pointsLeft.pointsLeft )
        ]


encodeIpsativeAnswer : IpsativeAnswer -> Encode.Value
encodeIpsativeAnswer ipsativeAnswer =
    Encode.object
        [ ( "id", Encode.string <| ipsativeAnswer.id )
        , ( "answer", Encode.string <| ipsativeAnswer.answer )
        , ( "category", Encode.string <| ipsativeAnswer.category )
        , ( "orderNumber", Encode.int <| ipsativeAnswer.orderNumber )
        , ( "pointsAssigned", ipsativeAnswer.pointsAssigned |> Encode.list encodePointsAssigned )
        ]


encodeLikertAnswer : LikertAnswer -> Encode.Value
encodeLikertAnswer likertAnswer =
    Encode.object
        [ ( "id", Encode.string <| likertAnswer.id )
        , ( "answer", Encode.string <| likertAnswer.answer )
        , ( "selectedChoice", Encode.string <| Maybe.withDefault "" <| likertAnswer.selectedChoice )
        ]


encodePointsAssigned : PointsAssigned -> Encode.Value
encodePointsAssigned pointsAssigned =
    Encode.object
        [ ( "group", Encode.int <| pointsAssigned.group )
        , ( "points", Encode.int <| pointsAssigned.points )
        ]


decodeIpsativeSurveyWithoutZipper : Decoder IpsativeSurveyWithoutZipper
decodeIpsativeSurveyWithoutZipper =
    map4 IpsativeSurveyWithoutZipper
        (field "metadata" decodeSurveyMetaData)
        (field "pointsPerQuestion" int)
        (field "numGroups" int)
        (field "questions" (Decode.list decodeIpsativeQuestion))


decodeLikertSurveyWithoutZipper : Decoder LikertSurveyWithoutZipper
decodeLikertSurveyWithoutZipper =
    map2 LikertSurveyWithoutZipper
        (field "metaData" decodeSurveyMetaData)
        (field "questions" (Decode.list decodeLikertQuestion))


testZipperCreation : List IpsativeQuestion -> Zipper.Zipper IpsativeQuestion
testZipperCreation test =
    Zipper.fromList [ emptyIpsativeQuestion ] |> Zipper.withDefault emptyIpsativeQuestion


decodeIpsativeQuestion : Decoder IpsativeQuestion
decodeIpsativeQuestion =
    map5 IpsativeQuestion
        (field "id" string)
        (field "title" string)
        (field "orderNumber" int)
        (field "pointsLeft" (Decode.list decodePointsLeft))
        (field "answers" (Decode.list decodeIpsativeAnswer))


decodePointsLeft : Decoder PointsLeft
decodePointsLeft =
    map2 PointsLeft
        (field "group" int)
        (field "pointsLeft" int)


decodeIpsativeAnswer : Decoder IpsativeAnswer
decodeIpsativeAnswer =
    map5 IpsativeAnswer
        (field "id" string)
        (field "answer" string)
        (field "category" string)
        (field "orderNumber" int)
        (field "pointsAssigned" (Decode.list decodePointsAssigned))


decodePointsAssigned : Decoder PointsAssigned
decodePointsAssigned =
    map2 PointsAssigned
        (field "group" int)
        (field "points" int)


decodeLikertQuestion : Decoder LikertQuestion
decodeLikertQuestion =
    map5 LikertQuestion
        (field "id" string)
        (field "title" string)
        (field "orderNumber" int)
        (field "choices" (Decode.list Decode.string))
        (field "answers" (Decode.list decodeLikertAnswer))


decodeLikertAnswer : Decoder LikertAnswer
decodeLikertAnswer =
    map3 LikertAnswer
        (field "id" string)
        (field "answer" string)
        (field "selectedChoice" decodeSelectedChoice)


decodeSelectedChoice : Decoder (Maybe String)
decodeSelectedChoice =
    Decode.map
        (\selectedChoice ->
            if selectedChoice == "" then
                Nothing

            else
                Just selectedChoice
        )
        Decode.string


decodeSurveyMetaData : Decoder SurveyMetaData
decodeSurveyMetaData =
    map6 SurveyMetaData
        (field "uuid" string)
        (field "created_at" string)
        (field "name" string)
        (field "description" string)
        (field "instructions" string)
        (field "author" string)


ipsativeResponseDecoder : Decoder IpsativeResponse
ipsativeResponseDecoder =
    map7 IpsativeResponse
        (field "uuid" string)
        (field "created_at" string)
        (field "user_email" string)
        (field "user_id" string)
        (field "answer_id" string)
        (field "group_number" int)
        (field "points_assigned" int)


ipsativeResponseEncoder : IpsativeSurvey -> Encode.Value
ipsativeResponseEncoder survey =
    let
        allResponses =
            getAllResponsesFromIpsativeSurvey survey
    in
    Encode.list
        ipsativeSingleResponseEncoder
        allResponses


getAllResponsesFromIpsativeSurvey : IpsativeSurvey -> List IpsativeSingleResponse
getAllResponsesFromIpsativeSurvey survey =
    survey.questions
        |> Zipper.toList
        |> List.concatMap .answers
        |> List.concatMap ipsativeAnswerToResponse


ipsativeAnswerToResponse : IpsativeAnswer -> List IpsativeSingleResponse
ipsativeAnswerToResponse answer =
    List.map
        (\group ->
            { answer_id = answer.id
            , group_number = group.group
            , points_assigned = group.points
            }
        )
        answer.pointsAssigned


type alias IpsativeSingleResponse =
    { answer_id : String
    , group_number : Int
    , points_assigned : Int
    }


ipsativeSingleResponseEncoder : IpsativeSingleResponse -> Encode.Value
ipsativeSingleResponseEncoder singleResponse =
    Encode.object
        [ ( "answer_id", Encode.string <| singleResponse.answer_id )
        , ( "group_number", Encode.int <| singleResponse.group_number )
        , ( "points_assigned", Encode.int <| singleResponse.points_assigned )
        ]


type alias LikertResponse =
    { uuid : String
    , created_at : String
    , user_email : String
    , user_id : String
    , answer_id : String
    , choice : String
    }


likertResponseDecoder : Decoder LikertResponse
likertResponseDecoder =
    map6 LikertResponse
        (field "uuid" string)
        (field "created_at" string)
        (field "user_email" string)
        (field "user_id" string)
        (field "answer_id" string)
        (field "choice" string)


likertResponseEncoder : LikertSurvey -> Encode.Value
likertResponseEncoder survey =
    let
        allResponses =
            getAllResponsesFromLikertSurvey survey
    in
    Encode.list
        likertSingleResponseEncoder
        allResponses


getAllResponsesFromLikertSurvey : LikertSurvey -> List LikertSingleResponse
getAllResponsesFromLikertSurvey survey =
    survey.questions
        |> Zipper.toList
        |> List.concatMap .answers
        |> List.map likertAnswerToResponse


likertAnswerToResponse : LikertAnswer -> LikertSingleResponse
likertAnswerToResponse answer =
    { answer_id = answer.id
    , choice =
        case answer.selectedChoice of
            Nothing ->
                ""

            Just x ->
                x
    }


type alias LikertSingleResponse =
    { answer_id : String
    , choice : String
    }


likertSingleResponseEncoder : LikertSingleResponse -> Encode.Value
likertSingleResponseEncoder singleResponse =
    Encode.object
        [ ( "answer_id", Encode.string <| singleResponse.answer_id )
        , ( "choice", Encode.string <| singleResponse.choice )
        ]


type alias SurveyMetaData =
    { uuid : String
    , created_at : String
    , name : String
    , description : String
    , instructions : String
    , author : String
    }


type alias IpsativeServerData =
    { question_id : String
    , question_title : String
    , question_order_number : Int
    , answer_id : String
    , answer : String
    , category : String
    , answer_order_number : Int
    }


ipsativeSurveyDataDecoder : Decoder IpsativeServerData
ipsativeSurveyDataDecoder =
    map7 IpsativeServerData
        (field "question_id" string)
        (field "question_title" string)
        (field "question_order_number" int)
        (field "answer_id" string)
        (field "answer" string)
        (field "category" string)
        (field "answer_order_number" int)


type alias LikertServerData =
    { survey_id : String
    , question_id : String
    , question_order_number : Int
    , question_title : String
    , question_choice_group : String
    , answer_id : String
    , answer_order_number : Int
    , answer : String
    , category : String
    }


likertSurveyDataDecoder : Decoder LikertServerData
likertSurveyDataDecoder =
    Decode.succeed LikertServerData
        |> required "survey_id" string
        |> required "question_id" string
        |> required "question_order_number" int
        |> required "question_title" string
        |> required "question_choice_group" string
        |> required "answer_id" string
        |> required "answer_order_number" int
        |> required "answer" string
        |> required "category" string


type alias LikertServerChoice =
    { survey_id : String
    , choice_group_id : String
    , choice : String
    , order_number : Int
    }


likertSurveyChoicesDecoder : Decoder LikertServerChoice
likertSurveyChoicesDecoder =
    map4 LikertServerChoice
        (field "survey_id" string)
        (field "choice_group_id" string)
        (field "choice" string)
        (field "order_number" int)


groupIpsativeSurveyData : List IpsativeServerData -> List IpsativeServerQuestion
groupIpsativeSurveyData data =
    let
        grouped =
            smashList
                (List.Extra.groupWhile
                    (\x y ->
                        x.question_id == y.question_id
                    )
                    data
                )

        mapped =
            List.map
                (\group ->
                    let
                        firstAnswer =
                            case List.head group of
                                Just x ->
                                    x

                                _ ->
                                    { question_order_number = 0
                                    , question_id = "Error Question UUID"
                                    , question_title = "Error Question"
                                    , answer_id = "Error Answer UUID"
                                    , answer_order_number = 0
                                    , answer = "Error Answer"
                                    , category = "Error Category"
                                    }
                    in
                    { uuid = firstAnswer.question_id
                    , title = firstAnswer.question_title
                    , orderNumber = firstAnswer.question_order_number
                    , answers =
                        List.map
                            (\answer ->
                                { uuid = answer.answer_id
                                , answer = answer.answer
                                , category = answer.category
                                , orderNumber = answer.answer_order_number
                                }
                            )
                            group
                    }
                )
                grouped
    in
    mapped


groupLikertSurveyData : List LikertServerData -> List LikertServerQuestion
groupLikertSurveyData data =
    let
        grouped =
            smashList
                (List.Extra.groupWhile
                    (\x y ->
                        x.question_id == y.question_id
                    )
                    data
                )

        mapped =
            List.map
                (\group ->
                    let
                        firstAnswer =
                            case List.head group of
                                Just x ->
                                    x

                                _ ->
                                    { survey_id = "UNKNOWN"
                                    , question_id = "UNKNOWN"
                                    , question_title = "Error Question"
                                    , question_order_number = 0
                                    , question_choice_group = "UNKNOWN"
                                    , answer_id = "UNKNOWN"
                                    , answer_order_number = 0
                                    , answer = "Error Answer"
                                    , category = "Error Category"
                                    }
                    in
                    { uuid = firstAnswer.question_id
                    , title = firstAnswer.question_title
                    , choiceGroupId = firstAnswer.question_choice_group
                    , orderNumber = firstAnswer.question_order_number
                    , answers =
                        List.map
                            (\answer ->
                                { uuid = answer.answer_id
                                , answer = answer.answer
                                , category = answer.category
                                }
                            )
                            group
                    }
                )
                grouped
    in
    mapped


type alias IpsativeQuestion =
    { id : String
    , title : String
    , orderNumber : Int
    , pointsLeft : List PointsLeft
    , answers : List IpsativeAnswer
    }


type alias IpsativeAnswer =
    { id : String
    , answer : String
    , category : String
    , orderNumber : Int
    , pointsAssigned : List PointsAssigned
    }


type alias IpsativeServerQuestion =
    { uuid : String
    , title : String
    , orderNumber : Int
    , answers : List IpsativeServerAnswer
    }


type alias IpsativeServerAnswer =
    { uuid : String
    , answer : String
    , category : String
    , orderNumber : Int
    }


type alias PointsLeft =
    { group : Int
    , pointsLeft : Int
    }


type alias PointsAssigned =
    { group : Int
    , points : Int
    }


emptyIpsativeServerMetaData : SurveyMetaData
emptyIpsativeServerMetaData =
    { uuid = "test"
    , created_at = "test"
    , name = "test"
    , description = "test"
    , instructions = "test"
    , author = "test"
    }


emptyIpsativeServerSurvey : IpsativeSurvey
emptyIpsativeServerSurvey =
    { metaData = emptyIpsativeServerMetaData
    , pointsPerQuestion = 5
    , numGroups = 2
    , questions = Zipper.singleton emptyIpsativeQuestion
    }


type alias LikertSurvey =
    { metaData : SurveyMetaData
    , questions : Zipper.Zipper LikertQuestion
    }


type alias LikertSurveyWithoutZipper =
    { metaData : SurveyMetaData
    , questions : List LikertQuestion
    }


type alias LikertQuestion =
    { id : String
    , title : String
    , orderNumber : Int
    , choices : List String
    , answers : List LikertAnswer
    }


type alias LikertServerQuestion =
    { title : String
    , uuid : String
    , choiceGroupId : String
    , orderNumber : Int
    , answers : List LikertServerAnswer
    }


type alias LikertAnswer =
    { id : String
    , answer : String
    , selectedChoice : Maybe String
    }


type alias LikertServerAnswer =
    { uuid : String
    , answer : String
    , category : String
    }


emptyLikertQuestion : LikertQuestion
emptyLikertQuestion =
    { id = "UNKNOWN"
    , title = "UNKNOWN"
    , orderNumber = 0
    , choices =
        [ "Strongly Disagree"
        , "Disagree"
        , "Neutral"
        , "Agree"
        , "Strongly Agree"
        ]
    , answers = [ emptyLikertAnswer ]
    }


emptyLikertAnswer : LikertAnswer
emptyLikertAnswer =
    { id = ""
    , answer = ""
    , selectedChoice = Nothing
    }


emptyIpsativeQuestion : IpsativeQuestion
emptyIpsativeQuestion =
    { id = "UNKNOWN"
    , title = "UNKNOWN"
    , orderNumber = 0
    , pointsLeft = [ emptyPointsLeft ]
    , answers =
        [ emptyAnswer
        ]
    }


emptyAnswer : IpsativeAnswer
emptyAnswer =
    { id = "UNKNOWN"
    , answer = "EMPTY QUESTION"
    , category = "EMPTY CATEGORY"
    , orderNumber = 0
    , pointsAssigned = [ emptyPointsAssigned ]
    }


emptyPointsLeft : PointsLeft
emptyPointsLeft =
    { group = 1
    , pointsLeft = 10
    }


emptyPointsAssigned : PointsAssigned
emptyPointsAssigned =
    { group = 1
    , points = 1
    }


createIpsativeSurvey : Int -> Int -> SurveyMetaData -> List IpsativeServerQuestion -> Survey
createIpsativeSurvey pointsPerQuestion numGroups metaData questions =
    Ipsative
        { metaData = metaData
        , pointsPerQuestion = pointsPerQuestion
        , numGroups = numGroups
        , questions =
            Zipper.fromList (ipsativeQuestionsMapped questions numGroups pointsPerQuestion)
                |> Zipper.withDefault emptyIpsativeQuestion
        }


createLikertSurvey : SurveyMetaData -> List LikertServerQuestion -> List LikertServerChoice -> Survey
createLikertSurvey metaData serverQuestions choices =
    Likert
        { metaData = metaData
        , questions = Zipper.fromList (likertQuestionsMapped serverQuestions choices) |> Zipper.withDefault emptyLikertQuestion
        }


likertQuestionsMapped : List LikertServerQuestion -> List LikertServerChoice -> List LikertQuestion
likertQuestionsMapped serverQuestions choices =
    List.map
        (\serverQuestion ->
            likertQuestionMapped serverQuestion choices
        )
        serverQuestions


likertQuestionMapped : LikertServerQuestion -> List LikertServerChoice -> LikertQuestion
likertQuestionMapped serverQuestion choices =
    let
        choicesForThisGroup =
            choices
                |> List.filter (choiceGroupIdPredicate serverQuestion)
                |> List.sortBy .order_number
                |> List.map .choice
    in
    { id = serverQuestion.uuid
    , title = serverQuestion.title
    , orderNumber = serverQuestion.orderNumber
    , answers = likertAnswersMapped serverQuestion.answers
    , choices = choicesForThisGroup
    }


choiceGroupIdPredicate : LikertServerQuestion -> LikertServerChoice -> Bool
choiceGroupIdPredicate serverQuestion choice =
    serverQuestion.choiceGroupId == choice.choice_group_id


likertAnswersMapped : List LikertServerAnswer -> List LikertAnswer
likertAnswersMapped answers =
    List.map
        (\answer ->
            { id = answer.uuid
            , answer = answer.answer
            , selectedChoice = Nothing
            }
        )
        answers


ipsativeQuestionsMapped : List IpsativeServerQuestion -> Int -> Int -> List IpsativeQuestion
ipsativeQuestionsMapped serverQuestions numGroups numPointsPerQuestion =
    List.map
        (\x ->
            { id = x.uuid
            , title = x.title
            , orderNumber = x.orderNumber
            , pointsLeft = createPointsLeft numGroups numPointsPerQuestion
            , answers = createAnswers x.answers numGroups
            }
        )
        serverQuestions


createPointsLeft : Int -> Int -> List PointsLeft
createPointsLeft numGroups numPointsPerQuestion =
    List.map
        (\x ->
            { group = x
            , pointsLeft = numPointsPerQuestion
            }
        )
        (List.range 1 numGroups)


createAnswers : List IpsativeServerAnswer -> Int -> List IpsativeAnswer
createAnswers serverAnswers numGroups =
    List.map
        (\x ->
            { id = x.uuid
            , answer = x.answer
            , category = x.category
            , orderNumber = x.orderNumber
            , pointsAssigned = createPointsAssigned numGroups
            }
        )
        serverAnswers


createPointsAssigned : Int -> List PointsAssigned
createPointsAssigned numGroups =
    List.map
        (\x ->
            { group = x
            , points = 0
            }
        )
        (List.range 1 numGroups)
