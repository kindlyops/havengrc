module Page.Errored exposing (PageLoadError, pageLoadError, view)

import Html exposing (..)
import Html.Attributes exposing (alt, class, id, tabindex)


type PageLoadError
    = PageLoadError Model


type alias Model =
    { errorMessage : String
    }


pageLoadError : String -> PageLoadError
pageLoadError errorMessage =
    PageLoadError { errorMessage = errorMessage }


view : model -> Html msg
view model =
    div []
        [ text "This is the ERRORED view" ]
