-- Main.elm


port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Auth0
import Authentication
import Material
import Material.Scheme
import Material.Button as Button
import Material.Color as Color
import Material.Layout as Layout
import Material.Options exposing (css)


main : Program (Maybe Auth0.LoggedInUser) Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , mdl : Material.Model
    , selectedTab : Int
    }


type alias Mdl =
    Material.Model



-- Init


init : Maybe Auth0.LoggedInUser -> ( Model, Cmd Msg )
init initialUser =
    ( Model 0 (Authentication.init auth0showLock auth0logout initialUser) Material.model 0, Cmd.none )



-- Messages


type Msg
    = AuthenticationMsg Authentication.Msg
    | Mdl (Material.Msg Msg)
    | SelectTab Int



-- Ports


port auth0showLock : Auth0.Options -> Cmd msg


port auth0authResult : (Auth0.RawAuthenticationResult -> msg) -> Sub msg


port auth0logout : () -> Cmd msg



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map AuthenticationMsg cmd )

        -- When the `Mdl` messages come through, update appropriately.
        Mdl msg_ ->
            Material.update msg_ model

        SelectTab num ->
            let
                _ =
                    Debug.log "SelectTab: " num
            in
                { model | selectedTab = num } ! []



-- Subscriptions


subscriptions : a -> Sub Msg
subscriptions model =
    auth0authResult (Authentication.handleAuthResult >> AuthenticationMsg)



-- View


view : Model -> Html Msg
view model =
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
            , main = [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ div []
            (case Authentication.tryGetUserProfile model.authModel of
                Nothing ->
                    [ p [] [ text "Please log in" ] ]

                Just user ->
                    [ p [] [ img [ src user.picture ] [] ]
                    , p [] [ text ("Hello, " ++ user.name ++ "!") ]
                    ]
            )
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.onClick
                (AuthenticationMsg
                    (if Authentication.isLoggedIn model.authModel then
                        Authentication.LogOut
                     else
                        Authentication.ShowLogIn
                    )
                )
            , css "margin" "0 24px"
            ]
            [ text
                (if Authentication.isLoggedIn model.authModel then
                    "Logout"
                 else
                    "Login"
                )
            ]
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
