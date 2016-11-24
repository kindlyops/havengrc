module View.Home exposing (view)

import Authentication
import Auth0
import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Button as Button
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Options exposing (css)
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Auth0.UserProfile -> Html Msg
view model user =
    Material.Scheme.topWithScheme Color.Teal Color.LightGreen <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            ]
            { header = [ h1 [ style [ ( "padding", "2rem" ) ] ] [ text "ComplianceOps" ] ]
            , drawer = []
            , tabs = ( [ text "Controls", text "Activities" ], [ Color.background (Color.color Color.Teal Color.S400) ] )
            , main = [ viewBody model user ]
            }


viewBody : Model -> Auth0.UserProfile -> Html Msg
viewBody model user =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ div []
            [ p [] [ img [ src user.picture ] [] ]
            , p [] [ text ("Hello, " ++ user.name ++ "!") ]
            ]
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.onClick
                (Msg.AuthenticationMsg Authentication.LogOut)
            , css "margin" "0 24px"
            ]
            [ text "Logout" ]
        , text
            (case model.selectedTab of
                0 ->
                    "First tab content"

                1 ->
                    "Second tab content"

                _ ->
                    "We don't have this tab"
            )
        ]
