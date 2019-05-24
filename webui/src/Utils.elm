module Utils exposing (getHTTPErrorMessage, smashList)

import Http


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
