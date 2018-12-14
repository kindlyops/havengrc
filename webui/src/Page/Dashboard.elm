module Page.Dashboard exposing (Model, Msg, init, update, view)

import Html exposing (Html, br, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Ports
import Views.Centroid as Centroid


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
            ( model
            , Ports.showError str
            )


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
