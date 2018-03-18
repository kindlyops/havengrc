module View exposing (view)

import Authentication
import Html exposing (Html)
import Types exposing (Model, Msg)
import View.Login
import View.Home


-- View


view : Model -> Html Msg
view model =
    (case Authentication.tryGetUserProfile model.authModel of
        Nothing ->
            View.Login.view model

        Just user ->
            loadingView model user
    )


loadingView : Model -> Keycloak.UserProfile -> Html Msg
loadingView model user =
    case model.PageState of
        Loaded page ->
            View.Home.View False model user
        TransitioningFrom page ->
            View.Home.View True model user
