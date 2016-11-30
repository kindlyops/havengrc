module Model exposing (Model, initialModel)

import Authentication
import Auth0 exposing (auth0showLock, auth0logout)
import Material
import Msg exposing (Msg)
import Navigation
import Route


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , mdl : Material.Model
    , selectedTab : Int
    }



-- Init
-- initialModel : Maybe Auth0.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
-- initialModel initialUser location =


initialModel : Maybe Auth0.LoggedInUser -> ( Model, Cmd Msg )
initialModel initialUser =
    ( { count = 0
      , authModel = (Authentication.init auth0showLock auth0logout initialUser)
      , route =
            Route.init Nothing
            -- (Just location)
      , mdl = Material.model
      , selectedTab = 0
      }
    , Cmd.none
    )
