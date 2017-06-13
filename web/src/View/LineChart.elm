module View.LineChart exposing (..)

import Visualization.Scale as Scale exposing (ContinuousScale, ContinuousTimeScale)
import Visualization.Axis as Axis
import Visualization.List as List
import Visualization.Shape as Shape
import Date
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Date exposing (Date)
import String


w : Float
w =
    900


h : Float
h =
    450


padding : Float
padding =
    30


view : List ( Date, Float ) -> Svg msg
view model =
    let
        xScale : ContinuousTimeScale
        xScale =
            Scale.time ( Date.fromTime 1448928000000, Date.fromTime 1456790400000 ) ( 0, w - 2 * padding )

        yScale : ContinuousScale
        yScale =
            Scale.linear ( 0, 5 ) ( h - 2 * padding, 0 )

        opts : Axis.Options a
        opts =
            Axis.defaultOptions

        xAxis : Svg msg
        xAxis =
            Axis.axis { opts | orientation = Axis.Bottom, tickCount = List.length model } xScale

        yAxis : Svg msg
        yAxis =
            Axis.axis { opts | orientation = Axis.Left, tickCount = 5 } yScale

        areaGenerator : ( Date, Float ) -> Maybe ( ( Float, Float ), ( Float, Float ) )
        areaGenerator ( x, y ) =
            Just ( ( Scale.convert xScale x, Tuple.first (Scale.rangeExtent yScale) ), ( Scale.convert xScale x, Scale.convert yScale y ) )

        lineGenerator : ( Date, Float ) -> Maybe ( Float, Float )
        lineGenerator ( x, y ) =
            Just ( Scale.convert xScale x, Scale.convert yScale y )

        area : String
        area =
            List.map areaGenerator model
                |> Shape.area Shape.monotoneInXCurve

        line : String
        line =
            List.map lineGenerator model
                |> Shape.line Shape.monotoneInXCurve
    in
        svg [ width (toString w ++ "px"), height (toString h ++ "px") ]
            [ g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString (h - padding) ++ ")") ]
                [ xAxis ]
            , g [ transform ("translate(" ++ toString (padding - 1) ++ ", " ++ toString padding ++ ")") ]
                [ yAxis ]
            , g [ transform ("translate(" ++ toString padding ++ ", " ++ toString padding ++ ")"), class "series" ]
                [ Svg.path [ d area, stroke "none", strokeWidth "3px", fill "rgba(255, 0, 0, 0.54)" ] []
                , Svg.path [ d line, stroke "red", strokeWidth "3px", fill "none" ] []
                ]
            ]
