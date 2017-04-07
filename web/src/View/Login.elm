module View.Login exposing (view)

import Authentication
import Msg exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Material.Button as Button
import Material.Options as Options exposing (css, onClick)
import Material.Scheme
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Html Msg
view model =
    div
        [ class "mdl-grid" ]
        [ div [ class "mdl-layout-spacer" ] []
        , div [ class "mdl-cell mdl-cell--4-col" ]
            [ text "redirecting to login page" ]
        , div [ class "mdl-layout-spacer" ] []
        ]
        |> Material.Scheme.top
