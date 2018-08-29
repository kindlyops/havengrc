module Data.Survey
    exposing
        ( createIpsativeSurvey
        , createLikertSurvey
        , emptyIpsativeServerMetaData
        , emptyIpsativeServerSurvey
        , encodeSurvey
        , encodeSurveyData
        , groupIpsativeSurveyData
        , groupLikertSurveyData
        , IpsativeAnswer
        , decodeSurveyMetaData
        , InitialSurvey
        , IpsativeQuestion
        , IpsativeResponse
        , ipsativeResponseDecoder
        , ipsativeResponseEncoder
        , IpsativeServerData
        , IpsativeSurvey
        , ipsativeSurveyDataDecoder
        , LikertAnswer
        , LikertQuestion
        , LikertResponse
        , likertResponseDecoder
        , likertResponseEncoder
        , LikertServerChoice
        , LikertServerData
        , LikertSurvey
        , likertSurveyChoicesDecoder
        , likertSurveyDataDecoder
        , PointsAssigned
        , PointsLeft
        , Survey(..)
        , SurveyMetaData
        , encodeSurveyMetaData
        , upgradeSurvey
        , decodeInitialSurvey
        )

import Json.Decode as Decode exposing (Decoder, decodeString, int, andThen, oneOf)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import List.Zipper as Zipper
import List.Extra


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
        Ipsative survey ->
            "Ipsative"

        Likert survey ->
            "Likert"


encodeSurveyData : Survey -> Encode.Value
encodeSurveyData survey =
    case survey of
        Ipsative survey ->
            let
                ipsativeSurveyWithoutZipper =
                    downgradeIpsativeSurvey survey
            in
                encodeipsativeSurveyWithoutZipper ipsativeSurveyWithoutZipper

        Likert survey ->
            let
                likertSurveyWithoutZipper =
                    downgradeLikertSurvey survey
            in
                encodeLikertSurveyWithoutZipper likertSurveyWithoutZipper


upgradeSurvey : InitialSurvey -> SurveyMetaData -> Survey
upgradeSurvey initialSurvey metaData =
    case initialSurvey of
        IpsativeWithoutZipper survey ->
            upgradeIpsativeSurvey survey metaData 5

        LikertWithoutZipper survey ->
            upgradeLikertSurvey survey metaData 5


upgradeIpsativeSurvey : IpsativeSurveyWithoutZipper -> SurveyMetaData -> Int -> Survey
upgradeIpsativeSurvey survey metaData questionNumber =
    Ipsative
        { metaData = metaData
        , pointsPerQuestion = survey.pointsPerQuestion
        , numGroups = survey.numGroups
        , questions = Zipper.fromList survey.questions |> Zipper.withDefault emptyIpsativeQuestion
        }


upgradeLikertSurvey : LikertSurveyWithoutZipper -> SurveyMetaData -> Int -> Survey
upgradeLikertSurvey survey metaData questionNumber =
    Likert
        { metaData = metaData
        , questions = Zipper.fromList survey.questions |> Zipper.withDefault emptyLikertQuestion
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
        , ( "questions", Encode.list <| List.map encodeIpsativeQuestion <| surveyWithoutZipper.questions )
        ]


encodeLikertSurveyWithoutZipper : LikertSurveyWithoutZipper -> Encode.Value
encodeLikertSurveyWithoutZipper surveyWithoutZipper =
    Encode.object
        [ ( "metaData", encodeSurveyMetaData <| surveyWithoutZipper.metaData )
        , ( "questions", Encode.list <| List.map encodeLikertQuestion <| surveyWithoutZipper.questions )
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
        , ( "pointsLeft", Encode.list <| List.map encodePointsLeft <| ipsativeQuestion.pointsLeft )
        , ( "answers", Encode.list <| List.map encodeIpsativeAnswer <| ipsativeQuestion.answers )
        ]


encodeLikertQuestion : LikertQuestion -> Encode.Value
encodeLikertQuestion likertQuestion =
    Encode.object
        [ ( "id", Encode.string <| likertQuestion.id )
        , ( "title", Encode.string <| likertQuestion.title )
        , ( "orderNumber", Encode.int <| likertQuestion.orderNumber )
        , ( "choices", Encode.list <| List.map Encode.string <| likertQuestion.choices )
        , ( "answers", Encode.list <| List.map encodeLikertAnswer <| likertQuestion.answers )
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
        , ( "orderNumber", Encode.int <| ipsativeAnswer.orderNumber )
        , ( "pointsAssigned", Encode.list <| List.map encodePointsAssigned <| ipsativeAnswer.pointsAssigned )
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
    decode IpsativeSurveyWithoutZipper
        |> required "metaData" decodeSurveyMetaData
        |> required "pointsPerQuestion" int
        |> required "numGroups" int
        |> required "questions" (Decode.list decodeIpsativeQuestion)


decodeLikertSurveyWithoutZipper : Decoder LikertSurveyWithoutZipper
decodeLikertSurveyWithoutZipper =
    decode LikertSurveyWithoutZipper
        |> required "metaData" decodeSurveyMetaData
        |> required "questions" (Decode.list decodeLikertQuestion)


testZipperCreation : List IpsativeQuestion -> Zipper.Zipper IpsativeQuestion
testZipperCreation test =
    Zipper.fromList [ emptyIpsativeQuestion ] |> Zipper.withDefault emptyIpsativeQuestion


decodeIpsativeQuestion : Decoder IpsativeQuestion
decodeIpsativeQuestion =
    decode IpsativeQuestion
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> required "orderNumber" int
        |> required "pointsLeft" (Decode.list decodePointsLeft)
        |> required "answers" (Decode.list decodeIpsativeAnswer)


decodePointsLeft : Decoder PointsLeft
decodePointsLeft =
    decode PointsLeft
        |> required "group" Decode.int
        |> required "pointsLeft" Decode.int


decodeIpsativeAnswer : Decoder IpsativeAnswer
decodeIpsativeAnswer =
    decode IpsativeAnswer
        |> required "id" Decode.string
        |> required "answer" Decode.string
        |> required "orderNumber" Decode.int
        |> required "pointsAssigned" (Decode.list decodePointsAssigned)


decodePointsAssigned : Decoder PointsAssigned
decodePointsAssigned =
    decode PointsAssigned
        |> required "group" Decode.int
        |> required "points" Decode.int


decodeLikertQuestion : Decoder LikertQuestion
decodeLikertQuestion =
    decode LikertQuestion
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> required "orderNumber" int
        |> required "choices" (Decode.list Decode.string)
        |> required "answers" (Decode.list decodeLikertAnswer)


decodeLikertAnswer : Decoder LikertAnswer
decodeLikertAnswer =
    decode LikertAnswer
        |> required "id" Decode.string
        |> required "answer" Decode.string
        |> required "selectedChoice" decodeSelectedChoice


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
    decode SurveyMetaData
        |> required "uuid" Decode.string
        |> required "created_at" Decode.string
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


ipsativeResponseDecoder : Decoder IpsativeResponse
ipsativeResponseDecoder =
    decode IpsativeResponse
        |> required "uuid" Decode.string
        |> required "created_at" Decode.string
        |> required "user_email" Decode.string
        |> required "user_id" Decode.string
        |> required "answer_id" Decode.string
        |> required "group_number" Decode.int
        |> required "points_assigned" Decode.int


ipsativeResponseEncoder : IpsativeSurvey -> Encode.Value
ipsativeResponseEncoder survey =
    let
        allResponses =
            getAllResponsesFromIpsativeSurvey survey
    in
        Encode.list
            (List.map
                (\x ->
                    ipsativeSingleResponseEncoder x
                )
                allResponses
            )


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
    decode LikertResponse
        |> required "uuid" Decode.string
        |> required "created_at" Decode.string
        |> required "user_email" Decode.string
        |> required "user_id" Decode.string
        |> required "answer_id" Decode.string
        |> required "choice" Decode.string


likertResponseEncoder : LikertSurvey -> Encode.Value
likertResponseEncoder survey =
    let
        allResponses =
            getAllResponsesFromLikertSurvey survey
    in
        Encode.list
            (List.map
                (\x ->
                    likertSingleResponseEncoder x
                )
                allResponses
            )


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
    , answer_order_number : Int
    }


ipsativeSurveyDataDecoder : Decoder IpsativeServerData
ipsativeSurveyDataDecoder =
    decode IpsativeServerData
        |> required "question_id" Decode.string
        |> required "question_title" Decode.string
        |> required "question_order_number" Decode.int
        |> required "answer_id" Decode.string
        |> required "answer" Decode.string
        |> required "answer_order_number" Decode.int


type alias LikertServerData =
    { survey_id : String
    , question_id : String
    , question_order_number : Int
    , question_title : String
    , question_choice_group : String
    , answer_id : String
    , answer_order_number : Int
    , answer : String
    }


likertSurveyDataDecoder : Decoder LikertServerData
likertSurveyDataDecoder =
    decode LikertServerData
        |> required "survey_id" Decode.string
        |> required "question_id" Decode.string
        |> required "question_order_number" Decode.int
        |> required "question_title" Decode.string
        |> required "question_choice_group" Decode.string
        |> required "answer_id" Decode.string
        |> required "answer_order_number" Decode.int
        |> required "answer" Decode.string


type alias LikertServerChoice =
    { survey_id : String
    , choice_group_id : String
    , choice : String
    , order_number : Int
    }


likertSurveyChoicesDecoder : Decoder LikertServerChoice
likertSurveyChoicesDecoder =
    decode LikertServerChoice
        |> required "survey_id" Decode.string
        |> required "choice_group_id" Decode.string
        |> required "choice" Decode.string
        |> required "order_number" Decode.int


groupIpsativeSurveyData : List IpsativeServerData -> List IpsativeServerQuestion
groupIpsativeSurveyData data =
    let
        grouped =
            List.Extra.groupWhile
                (\x y ->
                    x.question_id == y.question_id
                )
                data

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
            List.Extra.groupWhile
                (\x y ->
                    x.question_id == y.question_id
                )
                data

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
