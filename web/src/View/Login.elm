module View.Login exposing (view)

import Authentication
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types exposing (Model, Msg)


view : Model -> Html Msg
view model =
    div
        []
        [ text "Welcome to Haven GRC"
        , div
            []
            [ node "paper-button"
                -- Add this attribute
                [ attribute "raised" "raised"
                , onClick (Types.AuthenticationMsg Authentication.ShowLogIn)
                ]
                [ text "Login" ]
            ]
        ]
