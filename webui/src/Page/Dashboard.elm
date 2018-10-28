module Page.Dashboard exposing (view, Model, init, update, Msg)

import Html exposing (Html, div, br, button, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Views.Centroid as Centroid
import Ports


type Msg
    = ShowError String


type alias Model =
    { data : List Float
    }


init : Model
init =
    { data = [ 1, 1, 2, 3, 5, 8, 13 ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowError str ->
            model ! [ Ports.showError str ]


view : Model -> Html Msg
view model =
    div
        []
        [ Centroid.view model.data
        , br [] []
        , button
            [ class "btn btn-secondary"
            , onClick (ShowError "this is an error message")
            ]
            [ text "Show Error" ]
        ]
