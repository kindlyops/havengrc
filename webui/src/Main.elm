module Main exposing (..)

import Keycloak
import Navigation
import Date
import LineChart
import Centroid
import Gravatar
import Json.Decode as Decode exposing (Decoder, field, succeed)
import Json.Encode as Encode
import Authentication
import Http
import Keycloak
import Navigation
import Ports
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route
import Survey


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , selectedTab : Int
    , comments : List Comment
    , newComment : Comment
    , surveyModel : Survey.Model
    }


type Msg
    = AuthenticationMsg Authentication.Msg
    | NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | GetComments Model
    | AddComment Authentication.Model Comment
    | NewComments (Result Http.Error (List Comment))
    | NewComment (Result Http.Error (List Comment))
    | SetCommentMessageInput String
    | ShowError String
    | SurveyMsg Survey.Msg


main : Program (Maybe Keycloak.LoggedInUser) Model Msg
main =
    Navigation.programWithFlags (UrlChange)
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : a -> Sub Msg
subscriptions model =
    Ports.keycloakAuthResult (Authentication.handleAuthResult >> AuthenticationMsg)


init : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
init initialUser location =
    let
        initialAuthModel =
            Authentication.init Ports.keycloakLogin Ports.keycloakLogout initialUser

        ( route, routeCmd ) =
            Route.init (Just location)

        model =
            { count = 0
            , authModel = initialAuthModel
            , route = route
            , selectedTab = 0
            , comments = []
            , newComment = emptyNewComment
            , surveyModel = Survey.init
            }
    in
        ( model
        , routeCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map AuthenticationMsg cmd )

        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    let
                        initilizationCommands =
                            [ Navigation.newUrl (Route.urlFor location)
                            , Ports.setTitle (Route.titleFor location)
                            ]

                        additionalCommands =
                            case location of
                                Route.Comments ->
                                    [ getComments model.authModel ]

                                _ ->
                                    []

                        commands =
                            initilizationCommands ++ additionalCommands
                    in
                        model ! commands

        UrlChange location ->
            let
                _ =
                    Debug.log "UrlChange: " location.hash
            in
                { model | route = Route.locFor (Just location) } ! []

        AddComment authModel newComment ->
            model ! [ postComment authModel newComment ]

        GetComments model ->
            model ! [ getComments model.authModel ]

        SetCommentMessageInput value ->
            let
                oldComment =
                    model.newComment

                updatedComment =
                    { oldComment | message = value }
            in
                ( { model | newComment = updatedComment }, Cmd.none )

        NewComment (Ok comment) ->
            let
                morecomments =
                    model.comments ++ comment
            in
                -- TODO we need a more sophisticated way to deal with loading
                -- paginated data and not re-fetching data we already have
                { model | newComment = emptyNewComment, comments = morecomments } ! []

        NewComment (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        NewComments (Ok comments) ->
            { model | comments = comments } ! []

        NewComments (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        ShowError value ->
            model ! [ Ports.showError value ]

        SurveyMsg surveyMsg ->
            { model | surveyModel = Survey.update surveyMsg model.surveyModel } ! []


type alias Comment =
    { uuid : String
    , created_at : String
    , user_email : String
    , user_id : String
    , message : String
    }


emptyNewComment : Comment
emptyNewComment =
    Comment "" "" "" "" ""


commentDecoder : Decoder Comment
commentDecoder =
    Decode.map5 Comment
        (field "uuid" Decode.string)
        (field "created_at" Decode.string)
        (field "user_email" Decode.string)
        (field "user_id" Decode.string)
        (field "message" Decode.string)


encodeComment : Comment -> Encode.Value
encodeComment comment =
    Encode.object
        [ ( "message", Encode.string comment.message ) ]


commentsUrl : String
commentsUrl =
    "/api/comments"


getComments : Authentication.Model -> Cmd Msg
getComments authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = commentsUrl
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list commentDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send NewComments request


postComment : Authentication.Model -> Comment -> Cmd Msg
postComment authModel newComment =
    let
        body =
            encodeComment newComment
                |> Http.jsonBody

        headers =
            (Authentication.tryGetAuthHeader authModel) ++ Authentication.getReturnHeaders

        _ =
            Debug.log "postComment called with " newComment.message

        request =
            Http.request
                { method = "POST"
                , headers = headers
                , url = commentsUrl
                , body = body
                , expect = Http.expectJson (Decode.list commentDecoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send NewComment request


getHTTPErrorMessage : Http.Error -> String
getHTTPErrorMessage error =
    case error of
        Http.NetworkError ->
            "Is the server running?"

        Http.BadStatus response ->
            (toString response.status)

        Http.BadPayload message _ ->
            "Decoding Failed: " ++ message

        _ ->
            (toString error)


type alias MenuItem =
    { text : String
    , iconName : String
    , route : Maybe Route.Location
    }


selectedItem : Route.Model -> String
selectedItem route =
    let
        item =
            List.head (List.filter (\m -> m.route == route) navDrawerItems)
    in
        case item of
            Nothing ->
                "dashboard"

            Just item ->
                String.toLower item.text


getGravatar : String -> String
getGravatar email =
    let
        options =
            Gravatar.defaultOptions
                |> Gravatar.withDefault Gravatar.Identicon

        url =
            Gravatar.url options email
    in
        "https:" ++ url


navDrawerItems : List MenuItem
navDrawerItems =
    [ { text = "Dashboard", iconName = "dashboard", route = Just Route.Home }
    , { text = "Activity", iconName = "history", route = Just Route.Activity }
    , { text = "Reports", iconName = "library_books", route = Just Route.Reports }
    , { text = "Comments", iconName = "gavel", route = Just Route.Comments }
    , { text = "SurveyPrototype", iconName = "gavel", route = Just Route.SurveyPrototype }
    ]


view : Model -> Html Msg
view model =
    (case Authentication.tryGetUserProfile model.authModel of
        Nothing ->
            viewLogin model

        Just user ->
            --viewHome model user
            viewMain model user
    )


viewMain model user =
    div []
        [ viewNavBar model
        , viewNavigationDrawer model
        , viewBody model
        ]


viewNavBar model =
    nav [ class "navbar navbar-expand-lg navbar-light bg-light " ]
        [ button [ attribute "aria-controls" "navdrawerDefault", attribute "aria-expanded" "false", attribute "aria-label" "Toggle Navdrawer", class "navbar-toggler d-lg-none", attribute "data-breakpoint" "lg", attribute "data-target" "#navdrawerDefault", attribute "data-toggle" "navdrawer", attribute "data-type" "permanent" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , a [ class "navbar-brand", href "#" ]
            [ text "Navbar" ]
        , button [ attribute "aria-controls" "navbarSupportedContent", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation", class "navbar-toggler", attribute "data-target" "#navbarSupportedContent", attribute "data-toggle" "collapse", type_ "button" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , div [ class "collapse navbar-collapse", id "navbarSupportedContent" ]
            [ ul [ class "navbar-nav mr-auto" ]
                [ li [ class "nav-item active" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Home "
                        , span [ class "sr-only" ]
                            [ text "(current)" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "#" ]
                        [ text "Link" ]
                    ]
                , li [ class "nav-item dropdown" ]
                    [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link dropdown-toggle", attribute "data-toggle" "dropdown", href "#", id "navbarDropdown", attribute "role" "button" ]
                        [ text "Dropdown        " ]
                    , div [ attribute "aria-labelledby" "navbarDropdown", class "dropdown-menu" ]
                        [ a [ class "dropdown-item", href "#" ]
                            [ text "Action" ]
                        , a [ class "dropdown-item", href "#" ]
                            [ text "Another action" ]
                        , div [ class "dropdown-divider" ]
                            []
                        , a [ class "dropdown-item", href "#" ]
                            [ text "Something else here" ]
                        ]
                    ]
                ]
            , Html.form [ class "form-inline my-2 my-lg-0" ]
                [ input [ attribute "aria-label" "Search", class "form-control mr-sm-2", placeholder "Search", type_ "search" ]
                    []
                , button [ class "btn btn-outline-success my-2 my-sm-0", type_ "submit" ]
                    [ text "Search" ]
                ]
            ]
        ]


viewNavigationDrawer : Model -> Html Msg
viewNavigationDrawer model =
    div [ attribute "aria-hidden" "true", class "navdrawer navdrawer-permanent-lg navdrawer-permanent-clipped", id "navdrawerDefault", attribute "tabindex" "-1" ]
        [ div [ class "navdrawer-content" ]
            [ div [ class "navdrawer-header" ]
                [ a [ class "navbar-brand px-0", href "#" ]
                    [ text "Navdrawer header" ]
                ]
            , viewNavDrawerItems navDrawerItems model.route
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    div [ id "content", class "container-fluid content-wrapper" ]
        [ case model.route of
            Nothing ->
                viewDashboard model

            Just Route.Home ->
                viewDashboard model

            Just Route.Reports ->
                viewReports model

            Just Route.Comments ->
                viewComments model.authModel model.comments model.newComment

            Just Route.Activity ->
                viewActivity model

            Just Route.SurveyPrototype ->
                surveyPrototypeBody model

            Just _ ->
                notFoundBody model
        , snackBar model
        ]


commentsForm : Authentication.Model -> Comment -> Html Msg
commentsForm authModel newComment =
    div
        [ id "Comments" ]
        [ div []
            [ div
                [ class "mdc-textfield"
                , attribute "data-mdc-auto-init" "MDCTextfield"
                ]
                [ input
                    [ class "mdc-textfield__input"
                    , onInput SetCommentMessageInput
                    , value newComment.message
                    ]
                    []
                , label [ class "mdc-textfield__label" ] [ text "Comment" ]
                ]
            ]
        , button
            [ class "mdc-button mdc-button--raised mdc-button--accent"
            , attribute "data-mdc-auto-init" "MDCRipple"
            , onClick (AddComment authModel newComment)
            ]
            [ text "Add" ]
        , showDebugData newComment
        ]


viewActivity : Model -> Html Msg
viewActivity model =
    let
        data =
            [ ( Date.fromTime 1448928000000, 2 )
            , ( Date.fromTime 1451606400000, 2 )
            , ( Date.fromTime 1454284800000, 1 )
            , ( Date.fromTime 1456790400000, 1 )
            ]
    in
        div []
            [ div []
                [ text "What is Risk Management?" ]
            , LineChart.view data
            ]


viewDashboard : Model -> Html Msg
viewDashboard model =
    let
        data =
            [ 1, 1, 2, 3, 5, 8, 13 ]
    in
        div
            []
            [ Centroid.view data
            , br [] []
            , button
                [ class "mdc-button mdc-button--raised mdc-button--accent"
                , attribute "data-mdc-auto-init" "MDCRipple"
                , onClick (ShowError "this is an error message")
                ]
                [ text "Show Error" ]
            ]


viewReports : Model -> Html Msg
viewReports model =
    div []
        [ div []
            [ text "This is the reports view"
            , ol []
                [ li []
                    [ a [ href "../js/pdf/web/viewer.html?file=haven-booth-concepts.pdf", target "_blank" ]
                        [ text "Report" ]
                    ]
                , li []
                    [ a [ href "../js/pdf/web/viewer.html", target "_blank" ]
                        [ text "Same report" ]
                    ]
                ]
            ]
        ]


viewComments : Authentication.Model -> List Comment -> Comment -> Html Msg
viewComments authModel comments newComment =
    div []
        [ text "This is the comments view"
        , ul []
            (List.map (\l -> li [] [ text (l.message ++ " - " ++ l.user_email ++ "(" ++ l.user_id ++ ")" ++ " posted at " ++ l.created_at) ]) comments)
        , commentsForm authModel newComment
        ]


surveyPrototypeBody : Model -> Html Msg
surveyPrototypeBody model =
    Survey.view model.surveyModel |> Html.map SurveyMsg


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


showDebugData : record -> Html Msg
showDebugData record =
    div [ class "debug" ] [ text ("DEBUG: " ++ toString record) ]


snackBar : Model -> Html Msg
snackBar model =
    div
        [ id "error-snackbar"
        , class "mdc-snackbar"
        , attribute "aria-live" "assertive"
        , attribute "aria-atomic" "true"
        , attribute "aria-hidden" "true"

        -- , onClick (ShowError "this is an error message")
        ]
        [ div [ class "mdc-snackbar__text" ] []
        , div [ class "mdc-snackbar__action-wrapper" ]
            [ button [ class "mdc-snackbar__action-button" ] [] ]
        ]


viewHeader : Model -> Html Msg
viewHeader model =
    div [ class "mdc-toolbar mdc-toolbar--fixed header" ]
        [ div [ class "mdc-toolbar__row" ]
            [ section [ class "mdc-toolbar__section mdc-toolbar__section--align-start" ]
                [ button
                    [ id "MenuButton"
                    , class "menu material-icons mdc-toolbar__icon--menu"
                    ]
                    [ text "menu" ]
                , h1 [ class "mdc-toolbar__title" ]
                    [ text "Haven GRC" ]
                ]
            ]
        ]


viewUser model user =
    div [ class "user-container" ]
        [ img
            [ attribute "sizing" "contain"
            , attribute "src" (getGravatar user.username)
            , class "user-avatar"
            ]
            []
        , span [ class "user-name" ]
            [ text user.firstName ]
        , div [ class "mdc-menu-anchor" ]
            [ button
                [ id "UserDropdownButton"
                , class "user-menu-btn"
                ]
                [ i [ class "material-icons" ]
                    [ text "arrow_drop_down" ]
                ]
            , div
                [ id "UserDropdownMenu"
                , class "mdc-simple-menu"
                , attribute "tabindex" "-1"
                ]
                [ ul [ class "mdc-simple-menu__items mdc-list" ]
                    [ a
                        [ class "mdc-list-item"
                        , href "/auth/realms/havendev/account/"
                        , attribute "tabindex" "0"
                        ]
                        [ text "Edit Account" ]
                    , li
                        [ class "mdc-list-item"
                        , onClick (AuthenticationMsg Authentication.LogOut)
                        , attribute "tabindex" "0"
                        ]
                        [ text "Log Out" ]
                    ]
                ]
            ]
        ]


viewNavDrawerItems : List MenuItem -> Route.Model -> Html Msg
viewNavDrawerItems menuItems route =
    nav [ class "navdrawer-nav" ]
        (List.map
            (\menuItem ->
                viewNavDrawerItem menuItem route
            )
            menuItems
        )


viewNavDrawerItem : MenuItem -> Route.Model -> Html Msg
viewNavDrawerItem menuItem route =
    a
        [ attribute "name" (String.toLower menuItem.text)
        , onClick <| NavigateTo <| menuItem.route

        --, href "#"
        , style [ ( "cursor", "pointer" ) ]
        , classList
            [ ( "nav-item", True )
            , ( "nav-link", True )
            , ( "active", (String.toLower menuItem.text) == (selectedItem route) )
            ]
        ]
        [ i [ class "material-icons" ] [ text menuItem.iconName ]
        , text menuItem.text
        ]


viewHome : Model -> Keycloak.UserProfile -> Html Msg
viewHome model user =
    div [ class "container" ]
        [ div
            [ id "MenuDrawer"
            , class "mdc-persistent-drawer mdc-typography sm-screen-drawer lg-screen-drawer"
            ]
            [ nav [ class "mdc-persistent-drawer__drawer sidebar" ]
                [ div [ class "mdc-persistent-drawer__toolbar-spacer" ]
                    []
                , viewUser model user
                , viewNavDrawerItems navDrawerItems model.route
                ]
            ]
        , div [ class "mdc-toolbar-fixed-adjust" ]
            [ viewHeader model
            , viewBody model
            ]
        ]


viewLogin : Model -> Html Msg
viewLogin model =
    div []
        [ div [ class "mdc-layout-grid header-container" ]
            [ div [ class "mdc-layout-grid__inner" ]
                [ div [ class "mdc-layout-grid__cell--span-12 align-center" ]
                    [ img [ alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
                        []
                    , h1 [ class "login-header" ]
                        [ span [ class "text-success" ]
                            [ text "Compliance" ]
                        , span [ class "text-primary" ]
                            [ text " & " ]
                        , span [ class "text-success" ]
                            [ text "Risk " ]
                        , text "Dashboard"
                        ]
                    , button
                        [ class "mdc-button mdc-button--primary mdc-button--raised login-btn"
                        , onClick (AuthenticationMsg Authentication.ShowLogIn)
                        , attribute "data-mdc-auto-init" "MDCRipple"
                        ]
                        [ text "Login" ]
                    ]
                ]
            ]
        , div [ class "mdc-layout-grid align-center advantages-container" ]
            [ div [ class "mdc-layout-grid__inner" ]
                [ div [ class "mdc-layout-grid__cell--span-12", id "wireframe-container" ]
                    [ img [ alt "Wireframe graphic of compliance and risk dashboard Haven GRC", class "img-lg", attribute "data-rjs" "2", id "wireframe", src "/img/wireframe-large.png", width 552, height 375 ]
                        []
                    , img [ alt "Wireframe graphic of compliance and risk dashboard Haven GRC", class "img-sm", attribute "data-rjs" "2", id "wireframe", src "/img/wireframe.png", width 329, height 229 ]
                        []
                    ]
                , div [ class "mdc-layout-grid__cell mdc-layout-grid__cell--span-12-phone mdc-layout-grid__cell--span-12-tablet advantages-list" ]
                    [ img [ alt "Clipboard check list", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/record_assets.png" ]
                        []
                    , h2 []
                        [ text "Record Assets" ]
                    , p []
                        [ text "You already have well-defined controls, but it’s nearly impossible to keep up with the speed at which applications and services are purchased and provisioned in the cloud.  Reduce the Shadow IT burden by allowing teams to identify and report new cloud services regularly. Everyone can easily see which cloud services are approved, which ones need review, which ones are being retired, as well as what type of data is stored and processed." ]
                    ]
                , div [ class "mdc-layout-grid__cell mdc-layout-grid__cell--span-12-phone mdc-layout-grid__cell--span-12-tablet advantages-list" ]
                    [ img [ alt "icon with exclaimation point warning symbol alert", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/track_risk.png" ]
                        []
                    , h2 []
                        [ text "Track Risk" ]
                    , p []
                        [ text "When reviewing applications, services, and vendors for regulatory compliance, you inevitably find issues that need to be addressed. We help you quantify the relative importance and risk of each issue to the overall business so that everyone can see what needs priority attention. You can then easily track those issues through all stages of remediation and provide at-a-glance status for your overall risk profile to all stakeholders." ]
                    ]
                , div [ class "mdc-layout-grid__cell mdc-layout-grid__cell--span-12-phone mdc-layout-grid__cell--span-12-tablet advantages-list" ]
                    [ img [ alt "Award badge ribbon", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/give_credit.png" ]
                        []
                    , h2 []
                        [ text "Give Credit" ]
                    , p []
                        [ text "Compliance + risk work can seem never-ending and thankless. Resilience and safety comes from humans, and giving people credit for their work results in higher engagement and improved acuity for identifying and mitigating risks as they emerge. People get excited about how they are helping to improve the company risk profile rather than dragging their feet about the rules. Empower your team to innovate with confidence!" ]
                    ]
                ]
            ]
        , div [ class "align-center", id "footer-lines-container" ]
            [ img [ alt "Wireframe graphic of compliance and risk dashboard Haven GRC", attribute "data-rjs" "2", id "footer-lines", src "/img/footer_lines@2x.png" ]
                []
            , footer [ class "mdc-toolbar" ]
                [ div [ class "mdc-toolbar__row" ]
                    [ section [ class "mdc-toolbar__section" ]
                        [ span []
                            [ text "© 2018 "
                            , a [ href "https://kindlyops.com", title "Kindly Ops Website" ]
                                [ text "KINDLY OPS" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
