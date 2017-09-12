module WebComponents.Paper exposing (..)

import Html exposing (Html, Attribute, node)


input : List (Attribute a) -> List (Html a) -> Html a
input =
    node "paper-input"


textarea : List (Attribute a) -> List (Html a) -> Html a
textarea =
    node "paper-textarea"


button : List (Attribute a) -> List (Html a) -> Html a
button =
    node "paper-button"


iconButton : List (Attribute a) -> List (Html a) -> Html a
iconButton =
    node "paper-icon-button"


item : List (Attribute a) -> List (Html a) -> Html a
item =
    node "paper-item"


itemBody : List (Attribute a) -> List (Html a) -> Html a
itemBody =
    node "paper-item-body"


paperMenu : List (Attribute a) -> List (Html a) -> Html a
paperMenu =
    node "paper-menu"


paperItem : List (Attribute a) -> List (Html a) -> Html a
paperItem =
    node "paper-item"


paperCard : List (Attribute a) -> List (Html a) -> Html a
paperCard =
    node "paper-card"


paperFab : List (Attribute a) -> List (Html a) -> Html a
paperFab =
    node "paper-fab"
