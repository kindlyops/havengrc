module Types exposing (..)

import Authentication
import Http
import Navigation
import Comment.Types
import Route


type alias Model =
    { count : Int
    , authModel : Authentication.Model
    , route : Route.Model
    , selectedTab : Int
    , comments : List Comment.Types.Comment
    , newComment : Comment.Types.Comment
    }


type Msg
    = AuthenticationMsg Authentication.Msg
    | NavigateTo (Maybe Route.Location)
    | UrlChange Navigation.Location
    | GetComments Model
    | AddComment Model
    | NewComments (Result Http.Error (List Comment.Types.Comment))
    | NewComment (Result Http.Error String)
    | SetCommentMessageInput String
