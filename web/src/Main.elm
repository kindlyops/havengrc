-- Main.elm


port module Main exposing (..)

import Authentication
import Auth0 exposing (auth0authResult)
import Html
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation
import Route exposing (locFor)
import Update
import View


main : Program (Maybe Auth0.LoggedInUser) Model Msg
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
    auth0authResult (Authentication.handleAuthResult >> Msg.AuthenticationMsg)
