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


type alias AnswerResponse =
    { answer : String
    , category : String
    , questionNumber : Int
    , points : Int
    }


type alias ColumnCount =
    Maybe Int



-- getQuestionNumbers will align the answers with the question


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
    in
    questions



-- getPoints will get a list of all points from all answers


getPoints : List AnswerResponse -> List Float
getPoints answers =
    let
        points =
            List.map
                (\x ->
                    toFloat x.points
                )
                answers
    in
    points



-- getCategories will get a list of all categories from all answers


getCategories : List AnswerResponse -> List String
getCategories answers =
    let
        categories =
            List.map
                (\x ->
                    x.category
                )
                answers
    in
    categories



-- getAnswers gets all answers and flattnes the pointsAssigned object since we dont use groups


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
            in
            answerList
        )
        questions



-- columnCount is used to set the column count for the chart


columnCount : ColumnCount
columnCount =
    Just 2



-- spec creates the vega-lite spec to be used by js


spec : Data.Survey.IpsativeSurvey -> Spec
spec model =
    let
        questions =
            Zipper.toList model.questions

        answerListing =
            getAnswers questions

        categories =
            getCategories answerListing

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
        , bar [ maColor "#2fa09d" ]
        , columns columnCount
        , enc [ ( "facet", Json.Encode.object [ ( "field", Json.Encode.string "category" ), ( "type", Json.Encode.string "ordinal" ) ] ) ]
        , config []
        ]


havenSpecs : Data.Survey.Model -> Spec
havenSpecs model =
    let
        specs =
            case model.currentSurvey of
                Data.Survey.Ipsative survey ->
                    spec survey

                Data.Survey.Likert survey ->
                    toVegaLite []
    in
    specs
