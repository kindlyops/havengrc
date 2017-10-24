module Regulation.Rest exposing (..)

import Http
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode
import Keycloak
import Regulation.Types exposing (..)
import Types exposing (..)


regulationDecoder : Decoder Regulation
regulationDecoder =
    Decode.map4 Regulation
        (field "id" Decode.int)
        (field "identifier" Decode.string)
        (field "uri" Decode.string)
        (field "description" Decode.string)


encodeRegulation : Model -> Encode.Value
encodeRegulation model =
    Encode.object
        [ ( "identifier", Encode.string model.newRegulation.identifier )
        , ( "uri", Encode.string model.newRegulation.uri )
        , ( "description", Encode.string model.newRegulation.description )
        ]


regulationsUrl : String
regulationsUrl =
    "http://localhost:3001/regulation"


getRegulations : Model -> Cmd Msg
getRegulations model =
    let
        request =
            Http.request
                { method = "GET"
                , headers = tryGetAuthHeader model
                , url = regulationsUrl
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list regulationDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send NewRegulations request


tryGetAuthHeader : Model -> List Http.Header
tryGetAuthHeader model =
    case model.authModel.state of
        Keycloak.LoggedIn user ->
            let
                _ =
                    Debug.log ("user token is: " ++ user.token)
            in
                [ (Http.header "Authorization" ("Bearer " ++ user.token)) ]

        Keycloak.LoggedOut ->
            let
                _ =
                    Debug.log "didn't get a user token"
            in
                []


postRegulation : Model -> Cmd Msg
postRegulation model =
    let
        url =
            "http://localhost:3001/regulation"

        body =
            encodeRegulation model
                |> Http.jsonBody

        _ =
            Debug.log "postRegulation called"

        request =
            Http.request
                { method = "POST"
                , headers = tryGetAuthHeader model
                , url = url
                , body = body
                , expect = Http.expectString
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send NewRegulation request
