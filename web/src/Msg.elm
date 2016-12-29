module Msg exposing (Msg(..))

import Authentication
import Http
import Material
import Navigation
import Regulation exposing (Regulation)
import Route


-- Messages


type Msg
    = AuthenticationMsg Authentication.Msg
    | Mdl (Material.Msg Msg)
    | SelectTab Int
    | NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | NewRegulations (Result Http.Error (List Regulation))
