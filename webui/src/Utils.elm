module Utils exposing (formatPrettyDate, getHTTPErrorMessage, smashList)

import DateFormat
import DateFormat.Relative exposing (relativeTime)
import Http
import Iso8601
import Time exposing (Posix, Zone, now, utc)


getHTTPErrorMessage : Http.Error -> String
getHTTPErrorMessage error =
    case error of
        Http.BadUrl url ->
            "Couldn't understand that URL!"

        Http.Timeout ->
            "The request timed out"

        Http.NetworkError ->
            "Is the server running?"

        Http.BadStatus code ->
            "Bad status reponse " ++ String.fromInt code

        Http.BadBody message ->
            "Decoding Failed: " ++ message


smashList list =
    -- in the change from version 7 to 8 groupWhile changed to use a tuple
    -- representing a non-empty list. Convert back to something compatible
    -- with List.map.
    List.map
        (\item ->
            let
                ( a, b ) =
                    item
            in
            [ a ] ++ b
        )
        list


ourTimezone : Zone
ourTimezone =
    -- TODO this should be a preference in user profile
    utc


ourFormatter : Zone -> Posix -> String
ourFormatter =
    DateFormat.format
        [ DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthSuffix
        , DateFormat.text ", "
        , DateFormat.yearNumber
        ]


formatPrettyDate : Posix -> String -> String
formatPrettyDate now isotimestamp =
    let
        t =
            Iso8601.toTime isotimestamp

        formatted =
            case t of
                Ok timestamp ->
                    relativeTime now timestamp

                Err _ ->
                    "Error: could not decode timestamp"
    in
    formatted
