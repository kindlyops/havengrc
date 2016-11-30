module View.Login exposing (view)

import Authentication
import Msg exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Button as Button
import Material.Options exposing (css)
import Material.Scheme
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "mdl-grid" ]
        [ div [ class "mdl-layout-spacer" ] []
        , div [ class "mdl-cell mdl-cell--4-col" ]
            [ text "compelling value"
            , Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.onClick (AuthenticationMsg Authentication.ShowLogIn)
                , css "margin" "0 24px"
                ]
                [ text "Login" ]
            ]
        , div [ class "mdl-layout-spacer" ] []
        ]
        |> Material.Scheme.top



-- Button.render
-- Mdl
-- [ 0 ]
-- model.mdl
-- [ Button.onClick (Msg.AuthenticationMsg Authentication.ShowLogIn)
-- , css "margin" "0 24px"
-- ]
