module Comment.Types exposing (..)

import Http


type alias Comment =
    { uuid : String
    , created_at : String
    , user_email : String
    , user_id : String
    , message : String
    }

type alias Model =
    { comments : List Comment
    , newComment : Comment
    }


type Msg
    = SetCommentMessageInput String
    | AddComment Model
    | GetComments Model
    | NewComments (Result Http.Error (List Comment))
    | NewComment (Result Http.Error (List Comment))

emptyNewComment : Comment
emptyNewComment =
    Comment "" "" "" "" ""
