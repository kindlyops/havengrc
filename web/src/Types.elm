module Types exposing (..)

import Authentication
import Http
import Navigation
import Regulation.Types
import Route


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , selectedTab : Int
    , regulations : List Regulation.Types.Regulation
    }


type Msg
    = AuthenticationMsg Authentication.Msg
    | SelectTab Int
    | NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | NewRegulations (Result Http.Error (List Regulation.Types.Regulation))
