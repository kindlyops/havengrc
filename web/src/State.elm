module State exposing (init, update, subscriptions)

import Authentication
import Http
import Keycloak
import Navigation
import Ports
import Regulation.Rest exposing (getRegulations, postRegulation)
import Route
import Types exposing (..)


init : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
init initialUser location =
    let
        ( route, routeCmd ) =
            Route.init (Just location)
    in
        ( { count = 0
          , authModel = (Authentication.init Ports.keycloakShowLock Ports.keycloakLogout initialUser)
          , route = route
          , selectedTab = 0
          , regulations = []
          }
        , Cmd.batch [ routeCmd, getRegulations ]
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

        GetRegulations model ->
            let
                _ =
                    Debug.log "calling GetRegulations"
            in
                model ! [ postRegulation model ]

        NewRegulation (Ok regulation) ->
            let
                _ =
                    Debug.log "Saved a regulation via POST"
            in
                model ! []

        NewRegulation (Err error) ->
            -- TODO unify REST error handling
            let
                _ =
                    Debug.log "DEBUG: error when POSTing regulation"
            in
                ( model, Cmd.none )

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
