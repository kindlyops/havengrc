module Views.Centroid exposing (view)

import Visualization.Shape as Shape exposing (defaultPieConfig, Arc)
import Visualization.Path as Path
import List.Extra exposing (getAt)
import Svg exposing (Svg, svg, g, path)
import Svg.Attributes exposing (transform, d, style, width, height)


screenWidth : Float
screenWidth =
    800


screenHeight : Float
screenHeight =
    504


colors : List String
colors =
    [ "rgba(31, 119, 180, 0.5)"
    , "rgba(255, 127, 14, 0.5)"
    , "rgba(44, 159, 44, 0.5)"
    , "rgba(214, 39, 40, 0.5)"
    , "rgba(148, 103, 189, 0.5)"
    , "rgba(140, 86, 75, 0.5)"
    , "rgba(227, 119, 194, 0.5)"
    , "rgba(128, 128, 128, 0.5)"
    , "rgba(188, 189, 34, 0.5)"
    , "rgba(23, 190, 207, 0.5)"
    ]


radius : Float
radius =
    min (screenWidth / 2) screenHeight / 2 - 10


dot : String
dot =
    Path.begin |> Path.moveTo 5 5 |> Path.arc 0 0 5 0 (2 * pi) False |> Path.toAttrString


circular : List Arc -> Svg msg
circular arcs =
    let
        makeSlice index datum =
            path [ d (Shape.arc datum), style ("fill:" ++ (Maybe.withDefault "#000" <| getAt index colors) ++ "; stroke: #000;") ] []

        makeDot datum =
            path [ d dot, transform ("translate" ++ toString (Shape.centroid datum)) ] []
    in
        g [ transform ("translate(" ++ toString radius ++ "," ++ toString radius ++ ")") ]
            [ g [] <| List.indexedMap makeSlice arcs
            , g [] <| List.map makeDot arcs
            ]


annular : List Arc -> Svg msg
annular arcs =
    let
        makeSlice index datum =
            path [ d (Shape.arc { datum | innerRadius = radius - 60 }), style ("fill:" ++ (Maybe.withDefault "#000" <| getAt index colors) ++ "; stroke: #000;") ] []

        makeDot datum =
            path [ d dot, transform ("translate" ++ toString (Shape.centroid { datum | innerRadius = radius - 60 })) ] []
    in
        g [ transform ("translate(" ++ toString (radius + 20) ++ "," ++ toString radius ++ ")") ]
            [ g [] <| List.indexedMap makeSlice arcs
            , g [] <| List.map makeDot arcs
            ]


view : List Float -> Svg msg
view data =
    let
        pieData =
            data |> Shape.pie { defaultPieConfig | outerRadius = radius }
    in
        svg [ width (toString screenWidth ++ "px"), height (toString screenHeight ++ "px") ]
            [ annular pieData ]
