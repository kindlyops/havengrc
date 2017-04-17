port module Main exposing (..)

import Authentication
import Keycloak exposing (keycloakAuthResult)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation
import Update
import View


main : Program (Maybe Keycloak.LoggedInUser) Model Msg
main =
    Navigation.programWithFlags (UrlChange)
        { init = Model.initialModel
        , update = Update.update
        , subscriptions = subscriptions
        , view = View.view
        }



-- Subscriptions


subscriptions : a -> Sub Msg
subscriptions model =
    keycloakAuthResult (Authentication.handleAuthResult >> Msg.AuthenticationMsg)
