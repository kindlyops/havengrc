module View exposing (view)

import Authentication
import Html exposing (Html)
import Model exposing (Model)
import Msg exposing (Msg)
import View.Login
import View.Home


-- View


view : Model -> Html Msg
view model =
    (case Authentication.tryGetUserProfile model.authModel of
        Nothing ->
            View.Login.view model

        Just user ->
            View.Home.view model user
    )
