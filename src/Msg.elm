module Msg exposing (Msg(..))

import Authentication
import Material
import Navigation
import Route


-- Messages


type Msg
    = AuthenticationMsg Authentication.Msg
    | Mdl (Material.Msg Msg)
    | SelectTab Int
    | NavigateTo (Maybe Route.Location)
