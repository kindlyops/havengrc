module Data.Survey exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import List.Zipper as Zipper exposing (..)


type Survey
    = Ipsative IpsativeSurvey
    | Likert LikertSurvey


type alias IpsativeSurvey =
    { metaData : IpsativeMetaData
    , pointsPerQuestion : Int
    , numGroups : Int
    , questions : Zipper IpsativeQuestion
    }


type alias IpsativeServerSurvey =
    { metaData : IpsativeServerMetaData
    , questions : List IpsativeServerQuestion
    }


type alias IpsativeServerMetaData =
    { name : String
    , updated_at : String
    , description : String
    , instructions : String
    , author : String
    }


ipsativeMetaDataDecoder : Decoder IpsativeServerMetaData
ipsativeMetaDataDecoder =
    decode IpsativeServerMetaData
        |> required "name" Decode.string
        |> required "updated_at" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


type alias IpsativeMetaData =
    { name : String
    , updated_at : String
    , description : String
    , instructions : String
    , author : String
    }


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


emptyIpsativeServerMetaData : IpsativeMetaData
emptyIpsativeServerMetaData =
    { name = "test"
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
    { metaData : LikertMetaData
    , questions : Zipper LikertQuestion
    }


type alias LikertMetaData =
    { name : String
    , choices : List String
    , instructions : String
    , createdBy : String
    , description : String
    , lastUpdated : String
    }


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


emptyLikertQuestion : LikertQuestion
emptyLikertQuestion =
    { id = 0
    , title = "UNKNOWN"
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



--forceMetaData : LikertMetaData
--forceMetaData =
--    { name = "Security FORCE Survey"
--    , createdBy = "Lance Hayden"
--    , lastUpdated = "09/15/2015"
--    , description = "Survey to identify existing security culture in an organization."
--    , choices =
--        [ "Strongly Disagree"
--        , "Disagree"
--        , "Neutral"
--        , "Agree"
--        , "Strongly Agree"
--        ]
--    , instructions = "To complete this Security FORCE Survey, please indicate your level of agreement with each of the following statements regarding information security values and practices within your organization. Choose one response per statement. Please respond to all statements."
--    }
--scdsMetaData : IpsativeMetaData
--scdsMetaData =
--    { name = "SCDS"
--    , description = "Survey to identify existing security culture in an organization."
--    , lastUpdated = "09/15/2015"
--    , instructions = "For each question, assign a total of 10 points, divided among the four statements based on how accurately you think each describes your organization."
--    , createdBy = "Lance Hayden"
--    }
--scdsSurveyData : Survey
--scdsSurveyData =
--    createIpsativeSurvey 10 2 scdsMetaData scdsQuestions
--forceSurveyData : Survey
--forceSurveyData =
--    createLikertSurvey forceMetaData forceServerQuestions


createIpsativeSurvey : Int -> Int -> IpsativeMetaData -> List IpsativeServerQuestion -> Survey
createIpsativeSurvey pointsPerQuestion numGroups metaData questions =
    Ipsative
        { metaData = metaData
        , pointsPerQuestion = pointsPerQuestion
        , numGroups = numGroups
        , questions =
            Zipper.fromList (ipsativeQuestionsMapped questions numGroups pointsPerQuestion)
                |> Zipper.withDefault emptyIpsativeQuestion
        }


createLikertSurvey : LikertMetaData -> List LikertServerQuestion -> Survey
createLikertSurvey metaData serverQuestions =
    Likert
        { metaData = metaData
        , questions = Zipper.fromList (likertQuestionsMapped serverQuestions metaData) |> Zipper.withDefault emptyLikertQuestion
        }


likertQuestionsMapped : List LikertServerQuestion -> LikertMetaData -> List LikertQuestion
likertQuestionsMapped serverQuestions metaData =
    List.map
        (\serverQuestion ->
            { id = serverQuestion.id
            , title = serverQuestion.title
            , answers = likertAnswersMapped serverQuestion.answers
            , choices = metaData.choices
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
