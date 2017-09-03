module Main exposing (..)

import Keycloak
import Navigation
import State
import Types exposing (..)
import View


main : Program (Maybe Keycloak.LoggedInUser) Model Msg
main =
    Navigation.programWithFlags (UrlChange)
        { init = State.init
        , update = State.update
        , subscriptions = State.subscriptions
        , view = View.view
        }
