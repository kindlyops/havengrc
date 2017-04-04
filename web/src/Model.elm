module Model exposing (Model, initialModel)

import API exposing (getRegulations)
import Authentication
import Auth0 exposing (auth0showLock, auth0logout)
import Material
import Msg exposing (Msg)
import Navigation
import Route
import Regulation exposing (Regulation)


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , mdl : Material.Model
    , selectedTab : Int
    , regulations : List Regulation
    }



-- Init
-- initialModel : Maybe Auth0.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
-- initialModel initialUser location =


initialModel : Maybe Auth0.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
initialModel initialUser location =
    ( { count = 0
      , authModel = (Authentication.init auth0showLock auth0logout initialUser)
      , route =
            Route.init Nothing

      -- (Just location)
      , mdl = Material.model
      , selectedTab = 0
      , regulations = []
      }
    , getRegulations
    )
