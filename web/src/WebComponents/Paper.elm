module WebComponents.Paper exposing (input, button, iconButton, paperMenu, paperItem, paperCard, paperFab)

import Html exposing (Html, Attribute, node)


input : List (Attribute a) -> List (Html a) -> Html a
input =
    node "paper-input"


button : List (Attribute a) -> List (Html a) -> Html a
button =
    node "paper-button"


iconButton : List (Attribute a) -> List (Html a) -> Html a
iconButton =
    node "paper-icon-button"


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
