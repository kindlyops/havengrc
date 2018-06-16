module Data.RadarChart exposing (..)

--import Survey exposing (IpsativeSurvey, IpsativeQuestion)
--import Set as Set exposing (..)

import Color exposing (..)
import List.Zipper as Zipper exposing (..)
import List.Extra exposing (..)


-- import Color.Convert exposing (colorToCssRgba)
-- import Data.Survey exposing (IpsativeQuestion, IpsativeSurvey)
-- import Data.SurveyResponses exposing (AvailableResponse)


colors : List Color
colors =
    [ rgb 255 99 132
    , rgb 54 162 235
    , rgb 255 159 64
    , rgb 255 205 86
    , rgb 75 192 192
    , rgb 153 102 255
    , rgb 201 203 207
    ]


type alias RadarChartDataSet =
    { label : String
    , backgroundColor : String
    , borderColor : String
    , pointBackgroundColor : String
    , data : List Int
    }


emptyRadarChartDataSet : RadarChartDataSet
emptyRadarChartDataSet =
    { label = "test"
    , backgroundColor = "test"
    , borderColor = "test"
    , pointBackgroundColor = "test"
    , data = [ 1, 2, 3 ]
    }


type alias RadarChartData =
    { labels : List String
    , datasets : List RadarChartDataSet
    }


type alias LegendOptions =
    { position : String
    }


type alias TitleOptions =
    { display : Bool
    , text : String
    }


type alias ScaleOptions =
    { ticks : TickOptions
    }


type alias TickOptions =
    { beginAtZero : Bool
    }


type alias RadarChartOptions =
    { legend : LegendOptions
    , title : TitleOptions
    , scale : ScaleOptions
    }


type alias RadarChartConfig =
    { type_ : String
    , data : RadarChartData
    , options : RadarChartOptions
    }



-- generateIpsativeChart : AvailableResponse -> RadarChartConfig
-- generateIpsativeChart availableResponse =
--     let
--         radarChartData =
--             { labels = [ "one", "two", "three" ]
--             , datasets = [ emptyRadarChartDataSet ]
--             }
--         radarChartOptions =
--             { legend = { position = "top" }
--             , title =
--                 { display = True
--                 , text = " TEST TITLE"
--                 }
--             , scale = { ticks = { beginAtZero = True } }
--             }
--     in
--         { type_ = "radar"
--         , data = radarChartData
--         , options = radarChartOptions
--         }
-- generateIpsativeChartOld : IpsativeSurvey -> RadarChartConfig
-- generateIpsativeChartOld survey =
--     let
--         questions =
--             Zipper.toList survey.questions
--         radarChartData =
--             { labels = getLabels questions
--             , datasets = getDataSets questions
--             }
--         radarChartOptions =
--             { legend = { position = "top" }
--             , title = { display = True, text = survey.metaData.name ++ " Survey Results" }
--             , scale = { ticks = { beginAtZero = True } }
--             }
--     in
--         { type_ = "radar"
--         , data = radarChartData
--         , options = radarChartOptions
--         }


type alias MappedResponse =
    { answer_id : Int
    , category : String
    , group : Int
    , points : Int
    }



--getMappedResponses : List IpsativeQuestion -> List MappedResponse
--getMappedResponses questions =
--    let
--        newAnswers =
--            List.map
--                (\question ->
--                    List.map
--                        (\answer ->
--                            List.map
--                                (\pointsAssigned ->
--                                    { answer_id = answer.id
--                                    , category = answer.category
--                                    , group = pointsAssigned.group
--                                    , points = pointsAssigned.points
--                                    }
--                                )
--                                answer.pointsAssigned
--                        )
--                        question.answers
--                )
--                questions
--    in
--        newAnswers |> List.concat |> List.concat
-- getDataSets : List IpsativeQuestion -> List RadarChartDataSet
-- getDataSets questions =
--     [ emptyRadarChartDataSet ]
--let
--    allResponses =
--        getMappedResponses questions
--    sortedByGroup =
--        List.sortBy .group allResponses
--    groupedByGroup =
--        groupWhile
--            (\x y ->
--                x.group == y.group
--            )
--            sortedByGroup
--    test =
--        List.map
--            (\group ->
--                let
--                    first =
--                        List.head group
--                    groupNumber =
--                        case first of
--                            Just x ->
--                                x.group
--                            _ ->
--                                0
--                in
--                    { label = "Group " ++ toString groupNumber
--                    , backgroundColor = colorToCssRgba (makeTransparent (getAt (groupNumber - 1) colors |> Maybe.withDefault (rgb 0 0 0)))
--                    , borderColor = colorToCssRgba (getAt (groupNumber - 1) colors |> Maybe.withDefault (rgb 0 0 0))
--                    , pointBackgroundColor = colorToCssRgba (getAt (groupNumber - 1) colors |> Maybe.withDefault (rgb 0 0 0))
--                    , data = getDataFromGroupedAnswers allResponses groupNumber
--                    }
--            )
--            groupedByGroup
--in
--    test


makeTransparent : Color -> Color
makeTransparent color =
    let
        colorObject =
            toRgb color
    in
        rgba colorObject.red colorObject.green colorObject.blue 0.2


getDataFromGroupedAnswers : List MappedResponse -> Int -> List Int
getDataFromGroupedAnswers responses groupNumber =
    let
        filtered =
            List.filter
                (\x ->
                    x.group == groupNumber
                )
                responses

        sorted =
            List.sortBy .answer_id filtered

        grouped =
            groupWhile
                (\x y ->
                    x.answer_id == y.answer_id
                )
                sorted

        test =
            List.map
                (\x ->
                    List.sum (List.map (\y -> y.points) x)
                )
                grouped
    in
        test



-- getLabels : List IpsativeQuestion -> List String
-- getLabels questions =
--     [ "one", "two", "three", "four" ]
--getLabels questions =
--    let
--        allCategories =
--            List.map
--                (\question ->
--                    List.map
--                        (\answer ->
--                            answer.category
--                        )
--                        question.answers
--                )
--                questions
--    in
--        unique (allCategories |> List.concat)
