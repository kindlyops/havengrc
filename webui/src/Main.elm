module Main exposing (..)

import Keycloak
import Navigation
import Date
import LineChart
import Centroid
import Gravatar
import Json.Decode as Decode exposing (Decoder, field, succeed, value)
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
import Data.Survey


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , selectedTab : Int
    , comments : List Comment
    , newComment : Comment
    , surveyModel : Survey.Model
    , serverIpsativeSurveys : List Data.Survey.IpsativeServerMetaData
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
    | GetIpsativeSurveyData
    | GotServerIpsativeSurveys (Result Http.Error (List Data.Survey.IpsativeServerMetaData))
    | BeginIpsativeSurvey


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
            , serverIpsativeSurveys = []
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

                                Route.SurveyPrototype ->
                                    [ getIpsativeSurveys model.authModel ]

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

        GetIpsativeSurveyData ->
            model ! [ getIpsativeSurveys model.authModel ]

        GotServerIpsativeSurveys (Ok surveys) ->
            { model | serverIpsativeSurveys = surveys } ! []

        GotServerIpsativeSurveys (Err error) ->
            model ! [ Ports.showError (getHTTPErrorMessage error) ]

        BeginIpsativeSurvey ->
            model ! []


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


getIpsativeSurveys : Authentication.Model -> Cmd Msg
getIpsativeSurveys authModel =
    let
        request =
            Http.request
                { method = "GET"
                , headers = Authentication.tryGetAuthHeader authModel
                , url = "/api/ipsative_surveys?select=id,updated_at,name,description,instructions,author"
                , body = Http.emptyBody
                , expect = Http.expectJson (Decode.list Data.Survey.decoder)
                , timeout = Nothing
                , withCredentials = True
                }
    in
        Http.send GotServerIpsativeSurveys request


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
    , { text = "PostgrestTestPage", iconName = "gavel", route = Just Route.PostgrestTestPage }
    ]


view : Model -> Html Msg
view model =
    case Authentication.tryGetUserProfile model.authModel of
        Nothing ->
            viewHome model

        Just user ->
            viewMain model user


viewMain model user =
    div []
        [ viewNavBar model user
        , viewNavigationDrawer model
        , viewBody model
        ]


viewNavBar model user =
    nav [ class "navbar navbar-expand-lg fixed-top navbar-dark bg-primary " ]
        [ button [ attribute "aria-controls" "navdrawerDefault", attribute "aria-expanded" "false", attribute "aria-label" "Toggle Navdrawer", class "navbar-toggler d-lg-none", attribute "data-breakpoint" "lg", attribute "data-target" "#navdrawerDefault", attribute "data-toggle" "navdrawer", attribute "data-type" "permanent" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , a [ class "navbar-brand", href "#" ]
            [ text "Haven GRC" ]
        , button [ attribute "aria-controls" "navbarSupportedContent", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation", class "navbar-toggler", attribute "data-target" "#navbarSupportedContent", attribute "data-toggle" "collapse", type_ "button" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , viewNavUser model user
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
                        [ text "Github" ]
                    ]
                ]
            , ul [ class "navbar-nav" ]
                [ li [ class "nav-item active" ] [ a [ class "nav-link" ] [ text "Programs" ] ]
                , li [ class "nav-item active" ] [ a [ class "nav-link" ] [ text "Assets" ] ]
                , li [ class "nav-item active" ] [ a [ class "nav-link" ] [ text "People" ] ]
                ]
            ]
        ]


viewNavigationDrawer : Model -> Html Msg
viewNavigationDrawer model =
    div [ attribute "aria-hidden" "true", class "navdrawer navdrawer-permanent-lg navdrawer-permanent-clipped", id "navdrawerDefault", attribute "tabindex" "-1" ]
        [ div [ class "navdrawer-content" ]
            [ div [ class "navdrawer-header" ]
                [ a [ class "navbar-brand px-0", href "#" ]
                    [ text "Pages" ]
                ]
            , viewNavDrawerItems navDrawerItems model.route
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    div [ id "content", class "content-wrapper" ]
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
                viewSurveyPrototype model

            Just Route.PostgrestTestPage ->
                viewPostgrestTestPage model

            Just _ ->
                notFoundBody model
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
                    , Html.Attributes.value newComment.message
                    ]
                    []
                , label [ class "mdc-textfield__label" ] [ text "Comment" ]
                ]
            ]
        , button
            [ class "btn btn-primary"
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
                [ class "btn btn-primary"
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


viewSurveyPrototype : Model -> Html Msg
viewSurveyPrototype model =
    --Survey.view model.surveyModel |> Html.map SurveyMsg
    --div [ class "container " ] [ viewApp model ]
    div [ class "container " ]
        [ div [ class "" ]
            [ h1 [ class "display-4" ] [ text "KindlyOps Haven Survey Prototype" ]
            , p [ class "lead" ] [ text "Welcome to the Elm Haven Survey Prototype. " ]
            , hr [ class "my-4" ] []

            --, p [ class "" ] [ text ("There are currently " ++ (toString (List.length model.availableSurveys)) ++ " surveys to choose from.") ]
            , p [ class "" ] [ text "There are currently FIX surveys to choose from." ]
            , div [ class "row" ]
                (List.map
                    (\metaData ->
                        div [ class "col-sm" ] [ viewSurveyMetaData metaData ]
                    )
                    model.serverIpsativeSurveys
                )
            ]
        ]


viewSurveyMetaData : Data.Survey.IpsativeServerMetaData -> Html Msg
viewSurveyMetaData metaData =
    div [ class "card" ]
        [ div [ class "card-header" ] [ text "Ipsative" ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text metaData.name
                ]
            , p [ class "card-text" ] [ text metaData.description ]
            ]
        , ul [ class "list-group list-group-flush" ]
            [ li [ class "list-group-item" ] [ text ("Last Updated: " ++ metaData.updated_at) ]
            , li [ class "list-group-item" ] [ text ("Created By: " ++ metaData.author) ]
            , li [ class "list-group-item" ] [ button [ class "btn btn-primary", onClick BeginIpsativeSurvey ] [ text "Click to Start Survey" ] ]
            ]
        ]


viewPostgrestTestPage : Model -> Html Msg
viewPostgrestTestPage model =
    let
        firstSurveyName =
            case List.head model.serverIpsativeSurveys of
                Nothing ->
                    "NotLoaded or Error"

                Just x ->
                    x.name
    in
        div [ class "container" ]
            [ div [ class "row" ]
                [ div [ class "col" ]
                    [ button [ class "btn btn-primary", onClick GetIpsativeSurveyData ]
                        [ text "get it" ]
                    , p [] [ text firstSurveyName ]
                    ]
                ]
            ]


notFoundBody : Model -> Html Msg
notFoundBody model =
    div [] [ text "This is the notFound view" ]


showDebugData : record -> Html Msg
showDebugData record =
    div [ class "debug" ] [ text ("DEBUG: " ++ toString record) ]


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


viewNavUser model user =
    ul [ class "navbar-nav" ]
        [ li [ class "nav-item dropdown" ]
            [ a [ attribute "aria-expanded" "false", attribute "aria-haspopup" "true", class "nav-link dropdown-toggle", attribute "data-toggle" "dropdown", href "#", id "navbarDropdown", attribute "role" "button" ]
                [ img
                    [ attribute "src" (getGravatar user.username)
                    , class "user-avatar"
                    ]
                    []
                ]
            , div [ attribute "aria-labelledby" "navbarDropdown", class "dropdown-menu" ]
                [ a [ class "dropdown-item", href "#" ]
                    [ text "Profile" ]
                , a [ class "dropdown-item", href "#" ]
                    [ text "Another action" ]
                , div [ class "dropdown-divider" ]
                    []
                , a [ class "dropdown-item", href "#", onClick (AuthenticationMsg Authentication.LogOut) ]
                    [ text "Logout" ]
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


viewHome : Model -> Html Msg
viewHome model =
    div [ class "" ]
        [ div [ class "" ]
            [ div [ class "jumbotron text-center" ]
                [ div [ class "container" ]
                    [ img [ class "img-fluid mb-4", alt "Haven GRC Company Logo", attribute "data-rjs" "2", id "logo", src "/img/logo@2x.png", height 71, width 82 ]
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
                        [ class "btn btn-primary mt-4"
                        , onClick (AuthenticationMsg Authentication.ShowLogIn)
                        ]
                        [ text "Login" ]
                    ]
                ]
            ]
        , div [ class "py-5 bg-light text-center " ]
            [ div [ class "" ]
                [ div [ class "" ]
                    [ img [ class "img-lg", width 552, height 375, alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/wireframe-large.png" ]
                        []
                    ]
                , div [ class "row" ]
                    [ div [ class "col-4" ]
                        [ img [ alt "Clipboard check list", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/record_assets.png" ]
                            []
                        , h2 []
                            [ text "Record Assets" ]
                        , p []
                            [ text "You already have well-defined controls, but it’s nearly impossible to keep up with the speed at which applications and services are purchased and provisioned in the cloud.  Reduce the Shadow IT burden by allowing teams to identify and report new cloud services regularly. Everyone can easily see which cloud services are approved, which ones need review, which ones are being retired, as well as what type of data is stored and processed." ]
                        ]
                    , div [ class "col-4" ]
                        [ img [ alt "icon with exclaimation point warning symbol alert", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/track_risk.png" ]
                            []
                        , h2 []
                            [ text "Track Risk" ]
                        , p []
                            [ text "When reviewing applications, services, and vendors for regulatory compliance, you inevitably find issues that need to be addressed. We help you quantify the relative importance and risk of each issue to the overall business so that everyone can see what needs priority attention. You can then easily track those issues through all stages of remediation and provide at-a-glance status for your overall risk profile to all stakeholders." ]
                        ]
                    , div [ class "col-4" ]
                        [ img [ alt "Award badge ribbon", class "img-responsive center-block", attribute "data-rjs" "2", src "/img/give_credit.png" ]
                            []
                        , h2 []
                            [ text "Give Credit" ]
                        , p []
                            [ text "Compliance + risk work can seem never-ending and thankless. Resilience and safety comes from humans, and giving people credit for their work results in higher engagement and improved acuity for identifying and mitigating risks as they emerge. People get excited about how they are helping to improve the company risk profile rather than dragging their feet about the rules. Empower your team to innovate with confidence!" ]
                        ]
                    ]
                ]
            ]
        , div [ class "text-center bg-light", id "footer-container" ]
            [ img [ class "", id "footer-image", alt "Wireframe graphic of compliance and risk dashboard Haven GRC", src "/img/footer_lines@2x.png" ]
                []
            , footer [ class "bg-primary py-4" ]
                [ div [ class "" ]
                    [ span []
                        [ text "© 2018 "
                        , a [ href "https://kindlyops.com", title "Kindly Ops Website" ]
                            [ text "KINDLY OPS" ]
                        ]
                    ]
                ]
            ]
        ]
