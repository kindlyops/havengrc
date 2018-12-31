module Utils exposing (getHTTPErrorMessage, smashList)

import Http


getHTTPErrorMessage : Http.Error -> String
getHTTPErrorMessage error =
    case error of
        Http.NetworkError ->
            "Is the server running?"

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message _ ->
            "Decoding Failed: " ++ message

        _ ->
            "Unhandled HTTP error type"


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
