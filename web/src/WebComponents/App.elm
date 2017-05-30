module WebComponents.App exposing (appDrawer, appDrawerLayout, appToolbar, appHeader, appHeaderLayout, ironSelector)

import Html exposing (Html, Attribute, node)


appDrawer : List (Attribute a) -> List (Html a) -> Html a
appDrawer =
    node "app-drawer"


appDrawerLayout : List (Attribute a) -> List (Html a) -> Html a
appDrawerLayout =
    node "app-drawer-layout"


appToolbar : List (Attribute a) -> List (Html a) -> Html a
appToolbar =
    node "app-toolbar"


appHeader : List (Attribute a) -> List (Html a) -> Html a
appHeader =
    node "app-header"


appHeaderLayout : List (Attribute a) -> List (Html a) -> Html a
appHeaderLayout =
    node "app-header-layout"


ironSelector : List (Attribute a) -> List (Html a) -> Html a
ironSelector =
    node "iron-selector"
