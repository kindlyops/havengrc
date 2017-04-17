module Types exposing (..)

import Authentication
import Http
import Material
import Navigation
import Regulation exposing (Regulation)
import Route


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , mdl : Material.Model
    , selectedTab : Int
    , regulations : List Regulation
    }


type Msg
    = AuthenticationMsg Authentication.Msg
    | Mdl (Material.Msg Msg)
    | SelectTab Int
    | NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | NewRegulations (Result Http.Error (List Regulation))
