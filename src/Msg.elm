module Msg exposing (Msg(..))

import Authentication
import Material


-- Messages


type Msg
    = AuthenticationMsg Authentication.Msg
    | Mdl (Material.Msg Msg)
    | SelectTab Int
