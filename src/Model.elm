module Model exposing (Model, initialModel)

import Authentication
import Auth0 exposing (auth0showLock, auth0logout)
import Material
import Msg exposing (Msg)


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , mdl : Material.Model
    , selectedTab : Int
    }



-- Init


initialModel : Maybe Auth0.LoggedInUser -> ( Model, Cmd Msg )
initialModel initialUser =
    ( Model 0 (Authentication.init auth0showLock auth0logout initialUser) Material.model 0, Cmd.none )
