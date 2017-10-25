module Comment.Types exposing (..)


type alias Comment =
    { uuid : String
    , time : String
    , user_email : String
    , message : String
    }


emptyNewComment : Comment
emptyNewComment =
    Comment "" "" "" ""
