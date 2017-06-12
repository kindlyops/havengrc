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
    | NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | GetRegulations Model
    | NewRegulations (Result Http.Error (List Regulation.Types.Regulation))
    | NewRegulation (Result Http.Error String)
