module Model exposing (Model, initialModel)

import API exposing (getRegulations)
import Authentication
import Keycloak exposing (keycloakShowLock, keycloakLogout)
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


initialModel : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
initialModel initialUser location =
    ( { count = 0
      , authModel = (Authentication.init keycloakShowLock keycloakLogout initialUser)
      , route =
            Route.init Nothing

      -- (Just location)
      , mdl = Material.model
      , selectedTab = 0
      , regulations = []
      }
    , getRegulations
    )
