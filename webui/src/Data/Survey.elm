module Data.Survey exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import List.Zipper as Zipper exposing (..)
import List.Extra


type Survey
    = Ipsative IpsativeSurvey
    | Likert LikertSurvey


type alias IpsativeSurvey =
    { metaData : SurveyMetaData
    , pointsPerQuestion : Int
    , numGroups : Int
    , questions : Zipper IpsativeQuestion
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
    []


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


ipsativeMetaDataDecoder : Decoder SurveyMetaData
ipsativeMetaDataDecoder =
    decode SurveyMetaData
        |> required "uuid" Decode.string
        |> required "created_at" Decode.string
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


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
    , questions : Zipper LikertQuestion
    }


likertMetaDataDecoder : Decoder SurveyMetaData
likertMetaDataDecoder =
    decode SurveyMetaData
        |> required "uuid" Decode.string
        |> required "created_at" Decode.string
        |> required "name" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


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
