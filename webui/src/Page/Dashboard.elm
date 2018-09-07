module Page.Dashboard exposing (view, Model, init, update, Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Views.Centroid as Centroid
import Ports


type Msg
    = NoOp
    | ShowError String


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
        NoOp ->
            model ! []

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
