module Visualization exposing (havenSpecs)

import Array
import Data.Survey
import Dict
import Json.Decode as Decode
import Json.Encode
import List
import List.Extra
import List.Zipper as Zipper
import Set
import Vega
import VegaLite exposing (..)


getData : Data.Survey.IpsativeSurvey -> List Data.Survey.IpsativeSingleResponse
getData model =
    Data.Survey.getAllResponsesFromIpsativeSurvey model


getQuestionNumbers : List AnswerResponse -> List String -> List String
getQuestionNumbers answers questionNames =
    let
        array =
            Array.fromList questionNames

        questions =
            List.map
                (\x ->
                    case Array.get (x.questionNumber - 1) array of
                        Just questionName ->
                            questionName

                        Nothing ->
                            ""
                )
                answers

        resp =
            Debug.log "List of questionNumbers" questions
    in
    questions


getPoints : List AnswerResponse -> List Float
getPoints answers =
    let
        points =
            List.map
                (\x ->
                    toFloat x.points
                )
                answers

        resp =
            Debug.log "List of points" points
    in
    points


getCategories : List AnswerResponse -> List String
getCategories answers =
    let
        categories =
            List.map
                (\x ->
                    x.category
                )
                answers

        resp =
            Debug.log "List of categories" categories
    in
    categories


type alias AnswerResponse =
    { answer : String
    , category : String
    , questionNumber : Int
    , points : Int
    }


getAnswers : List Data.Survey.IpsativeQuestion -> List AnswerResponse
getAnswers questions =
    List.concatMap
        (\x ->
            let
                answerList =
                    List.map
                        (\l ->
                            let
                                output =
                                    { answer = l.answer
                                    , category = l.category
                                    , questionNumber = l.questionNumber
                                    , points =
                                        (Maybe.withDefault Data.Survey.emptyPointsAssigned
                                            (List.head l.pointsAssigned)
                                        ).points
                                    }
                            in
                            output
                        )
                        x.answers

                --   answer =
                --       Maybe.withDefault Data.Survey.emptyAnswer
                --          (List.Extra.find (\a -> "null" /= a.category) x.answers)
                -- assigned =
                --     Maybe.withDefault Data.Survey.emptyPointsAssigned
                --        (List.head answer.pointsAssigned)
            in
            answerList
        )
        questions


type alias ColumnCount =
    Maybe Int


columnCount : ColumnCount
columnCount =
    Just 2


spec : Data.Survey.IpsativeSurvey -> Spec
spec model =
    let
        responses =
            -- Do something here with some data eventually!
            getData

        questions =
            Zipper.toList model.questions

        answerListing =
            getAnswers questions

        debugLog =
            Debug.log "List of answers for questions" answerListing

        -- TODO
        -- Create decoder to create json from answerListing
        -- jsonList =
        -- Json.Encode.list (Json.Encode.object (Json.Encode.list answerListing))
        categories =
            getCategories answerListing

        resp =
            Debug.log "Responses" questions

        des =
            description "SCDS Assessment"

        questionColumns =
            [ "Org Values"
            , "Org Behaves"
            , "Definition"
            , "Information"
            , "Operations"
            , "Technology"
            , "People"
            , "Risk"
            , "Accountability"
            , "Performance"
            ]

        data =
            dataFromColumns []
                << dataColumn "a" (strs (getQuestionNumbers answerListing questionColumns))
                << dataColumn "category" (strs categories)
                << dataColumn "points" (nums (getPoints answerListing))

        testSpec =
            asSpec [ facet [] ]

        enc =
            encoding
                << position X [ pTitle "", pName "points", pMType Quantitative, pScale [ scDomain (doNums [ 0, 10 ]) ] ]
                << position Y
                    [ pName "a"
                    , pTitle ""
                    , pMType Ordinal
                    , pScale
                        [ scDomain
                            (doStrs
                                [ "Org Values"
                                , "Org Behaves"
                                , "Definition"
                                , "Information"
                                , "Operations"
                                , "Technology"
                                , "People"
                                , "Risk"
                                , "Accountability"
                                , "Performance"
                                ]
                            )
                        ]
                    ]

        specText =
            asSpec [ textMark [ maStyle [ "label" ] ], encoding (text [ tName "a", tMType Quantitative ] []) ]

        config =
            configure << configuration (coNamedStyle "label" [ maAlign haLeft, maBaseline vaMiddle, maDx 3 ])
    in
    toVegaLite
        [ des
        , data []
        , bar []
        , columns columnCount
        , enc [ ( "facet", Json.Encode.object [ ( "field", Json.Encode.string "category" ), ( "type", Json.Encode.string "ordinal" ) ] ) ]
        , config []
        ]


havenSpecs : Data.Survey.Model -> List Spec
havenSpecs model =
    let
        specs =
            case model.currentSurvey of
                Data.Survey.Ipsative survey ->
                    [ spec survey
                    ]

                Data.Survey.Likert survey ->
                    []
    in
    specs
