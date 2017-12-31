module State exposing (init, update, subscriptions)

import Authentication
import Http
import Keycloak
import Navigation
import Ports
import Comment.Rest exposing (getComments, postComment)
import Comment.Types exposing (Comment, emptyNewComment)
import Route
import Types exposing (..)


init : Maybe Keycloak.LoggedInUser -> Navigation.Location -> ( Model, Cmd Msg )
init initialUser location =
    let
        ( route, routeCmd ) =
            Route.init (Just location)

        model =
            { count = 0
            , authModel = (Authentication.init Ports.keycloakLogin Ports.keycloakLogout initialUser)
            , route = route
            , selectedTab = 0
            , comments = []
            , newComment = emptyNewComment
            }
    in
        ( model
        , routeCmd
        )


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Types.AuthenticationMsg authMsg ->
            let
                ( authModel, cmd ) =
                    Authentication.update authMsg model.authModel
            in
                ( { model | authModel = authModel }, Cmd.map Types.AuthenticationMsg cmd )

        NavigateTo maybeLocation ->
            case maybeLocation of
                Nothing ->
                    model ! []

                Just location ->
                    model
                        ! [ Navigation.newUrl (Route.urlFor location)
                          , Ports.setTitle (Route.titleFor location)
                          ]

        UrlChange location ->
            let
                _ =
                    Debug.log "UrlChange: " location.hash
            in
                { model | route = Route.locFor (Just location) } ! []

        AddComment model ->
            model ! [ postComment model ]

        GetComments model ->
            model ! [ getComments model ]

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


subscriptions : a -> Sub Msg
subscriptions model =
    Ports.keycloakAuthResult (Authentication.handleAuthResult >> AuthenticationMsg)
