module Data.Session exposing (Session)

import Keycloak exposing (LoggedInUser)


type alias Session =
    { user : Maybe LoggedInUser }
