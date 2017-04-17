module State exposing (init, update, subscriptions)

import Authentication
import API
import Http
import Keycloak
import Material
import Navigation
import Ports
import Route
import Types exposing (..)


init : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
init initialUser location =
    ( { count = 0
      , authModel = (Authentication.init Ports.keycloakShowLock Ports.keycloakLogout initialUser)
      , route =
            Route.init Nothing

      -- (Just location)
      , mdl = Material.model
      , selectedTab = 0
      , regulations = []
      }
    , API.getRegulations
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map Types.AuthenticationMsg cmd )

        -- When the `Mdl` messages come through, update appropriately.
        Mdl msg_ ->
            Material.update Mdl msg_ model

        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    model ! [ Navigation.newUrl (Route.urlFor location) ]

        UrlChange location ->
            let
                _ =
                    Debug.log "UrlChange: " location.hash
            in
                { model | route = Route.locFor (Just location) } ! []

        SelectTab num ->
            let
                _ =
                    Debug.log "SelectTab: " num
            in
                { model | selectedTab = num } ! []

        NewRegulations (Ok regulations) ->
            let
                _ =
                    Debug.log "SUCCESS: got it"
            in
                { model | regulations = regulations } ! []

        NewRegulations (Err error) ->
            let
                errorMessage =
                    case error of
                        Http.NetworkError ->
                            "Is the server running?"

                        Http.BadStatus response ->
                            (toString response.status)

                        Http.BadPayload message _ ->
                            "Decoding Failed: " ++ message

                        _ ->
                            (toString error)

                _ =
                    Debug.log "DEBUG: " errorMessage
            in
                ( model, Cmd.none )


subscriptions : a -> Sub Msg
subscriptions model =
    Ports.keycloakAuthResult (Authentication.handleAuthResult >> AuthenticationMsg)
