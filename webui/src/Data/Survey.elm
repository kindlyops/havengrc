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


type alias IpsativeServerSurvey =
    { metaData : SurveyMetaData
    , questions : List IpsativeServerQuestion
    }


type alias IpsativeResponse =
    { uuid : String
    , created_at : String
    , user_email : String
    , user_id : String
    , survey_id : Int
    , response : IpsativeInnerResponse

    --, org : String
    }


type alias IpsativeInnerResponse =
    { category_one : Int
    }


ipsativeInnerResponseDecoder : Decoder IpsativeInnerResponse
ipsativeInnerResponseDecoder =
    decode IpsativeInnerResponse
        |> required "category_one" Decode.int


ipsativeResponseDecoder : Decoder IpsativeResponse
ipsativeResponseDecoder =
    decode IpsativeResponse
        |> required "uuid" Decode.string
        |> required "created_at" Decode.string
        |> required "user_email" Decode.string
        |> required "user_id" Decode.string
        |> required "survey_id" Decode.int
        |> required "response" ipsativeInnerResponseDecoder



--|> required "org" Decode.string


ipsativeResponseEncoder : IpsativeSurvey -> Encode.Value
ipsativeResponseEncoder survey =
    Encode.object
        [ ( "survey_id", Encode.int <| survey.metaData.id )
        , ( "response", Encode.object [ ( "category_one", Encode.int <| 3 ) ] )
        ]


ipsativeMetaDataDecoder : Decoder SurveyMetaData
ipsativeMetaDataDecoder =
    decode SurveyMetaData
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "updated_at" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


type alias SurveyMetaData =
    { id : Int
    , name : String
    , updated_at : String
    , description : String
    , instructions : String
    , author : String
    }


type alias IpsativeServerData =
    { survey_id : Int
    , question_id : Int
    , question_title : String
    , answer_id : Int
    , answer_category : String
    , answer_answer : String
    }


ipsativeSurveyDataDecoder : Decoder IpsativeServerData
ipsativeSurveyDataDecoder =
    decode IpsativeServerData
        |> required "survey_id" Decode.int
        |> required "question_id" Decode.int
        |> required "question_title" Decode.string
        |> required "answer_id" Decode.int
        |> required "answer_category" Decode.string
        |> required "answer_answer" Decode.string


type alias LikertServerData =
    { survey_id : Int
    , question_id : Int
    , question_title : String
    , answer_id : Int
    , answer_answer : String
    }


likertSurveyDataDecoder : Decoder LikertServerData
likertSurveyDataDecoder =
    decode LikertServerData
        |> required "survey_id" Decode.int
        |> required "question_id" Decode.int
        |> required "question_title" Decode.string
        |> required "answer_id" Decode.int
        |> required "answer_answer" Decode.string


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
                                    { survey_id = 0
                                    , question_id = 0
                                    , question_title = "Error Question"
                                    , answer_id = 0
                                    , answer_category = "Error Category"
                                    , answer_answer = "Error Answer"
                                    }
                    in
                        { id = firstAnswer.question_id
                        , title = firstAnswer.question_title
                        , answers =
                            List.map
                                (\answer ->
                                    { id = answer.answer_id
                                    , category = answer.answer_category
                                    , answer = answer.answer_answer
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
                                    { survey_id = 0
                                    , question_id = 0
                                    , question_title = "Error Question"
                                    , answer_id = 0
                                    , answer_answer = "Error Answer"
                                    }
                    in
                        { id = firstAnswer.question_id
                        , title = firstAnswer.question_title
                        , answers =
                            List.map
                                (\answer ->
                                    { id = answer.answer_id
                                    , answer = answer.answer_answer
                                    }
                                )
                                group
                        }
                )
                grouped
    in
        mapped


type alias IpsativeQuestion =
    { id : Int
    , title : String
    , pointsLeft : List PointsLeft
    , answers : List IpsativeAnswer
    }


type alias IpsativeAnswer =
    { id : Int
    , answer : String
    , category : String
    , pointsAssigned : List PointsAssigned
    }


type alias IpsativeServerQuestion =
    { id : Int
    , title : String
    , answers : List IpsativeServerAnswer
    }


type alias IpsativeServerAnswer =
    { id : Int
    , category : String
    , answer : String
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
    { id = 0
    , name = "test"
    , updated_at = "test"
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
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "updated_at" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


type alias LikertQuestion =
    { id : Int
    , title : String
    , choices : List String
    , answers : List LikertAnswer
    }


type alias LikertServerQuestion =
    { title : String
    , id : Int
    , answers : List LikertServerAnswer
    }


type alias LikertAnswer =
    { id : Int
    , answer : String
    , selectedChoice : Maybe String
    }


type alias LikertServerAnswer =
    { id : Int
    , answer : String
    }


defaultChoices : List String
defaultChoices =
    [ "Strongly Disagree"
    , "Disagree"
    , "Neutral"
    , "Agree"
    , "Strongly Agree"
    ]


emptyLikertQuestion : LikertQuestion
emptyLikertQuestion =
    { id = 0
    , title = "UNKNOWN"
    , choices = defaultChoices
    , answers = [ emptyLikertAnswer ]
    }


emptyLikertAnswer : LikertAnswer
emptyLikertAnswer =
    { id = 0
    , answer = ""
    , selectedChoice = Nothing
    }


emptyIpsativeQuestion : IpsativeQuestion
emptyIpsativeQuestion =
    { id = 0
    , title = "UNKNOWN"
    , pointsLeft = [ emptyPointsLeft ]
    , answers =
        [ emptyAnswer
        ]
    }


emptyAnswer : IpsativeAnswer
emptyAnswer =
    { id = 0
    , answer = "EMPTY QUESTION"
    , category = "EMPTY CATEGORY"
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


ipsativeQuestionDecoder : Decoder IpsativeServerQuestion
ipsativeQuestionDecoder =
    decode IpsativeServerQuestion
        |> required "id" Decode.int
        |> required "title" Decode.string
        |> required "answers" (Decode.list ipsativeAnswerDecoder)


ipsativeAnswerDecoder : Decoder IpsativeServerAnswer
ipsativeAnswerDecoder =
    decode IpsativeServerAnswer
        |> required "id" Decode.int
        |> required "category" Decode.string
        |> required "answer" Decode.string


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


createLikertSurvey : SurveyMetaData -> List LikertServerQuestion -> Survey
createLikertSurvey metaData serverQuestions =
    Likert
        { metaData = metaData
        , questions = Zipper.fromList (likertQuestionsMapped serverQuestions metaData) |> Zipper.withDefault emptyLikertQuestion
        }


likertQuestionsMapped : List LikertServerQuestion -> SurveyMetaData -> List LikertQuestion
likertQuestionsMapped serverQuestions metaData =
    List.map
        (\serverQuestion ->
            { id = serverQuestion.id
            , title = serverQuestion.title
            , answers = likertAnswersMapped serverQuestion.answers
            , choices = defaultChoices
            }
        )
        serverQuestions


likertAnswersMapped : List LikertServerAnswer -> List LikertAnswer
likertAnswersMapped answers =
    List.map
        (\answer ->
            { id = answer.id
            , answer = answer.answer
            , selectedChoice = Nothing
            }
        )
        answers


ipsativeQuestionsMapped : List IpsativeServerQuestion -> Int -> Int -> List IpsativeQuestion
ipsativeQuestionsMapped serverQuestions numGroups numPointsPerQuestion =
    List.map
        (\x ->
            { id = x.id
            , title = x.title
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
            { id = x.id
            , answer = x.answer
            , category = x.category
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
