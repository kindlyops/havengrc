module Update exposing (update)

import Authentication
import Material
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation
import Route exposing (Location(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map AuthenticationMsg cmd )

        -- When the `Mdl` messages come through, update appropriately.
        Mdl msg_ ->
            Material.update msg_ model

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
                model ! []

        SelectTab num ->
            let
                _ =
                    Debug.log "SelectTab: " num
            in
                { model | selectedTab = num } ! []
