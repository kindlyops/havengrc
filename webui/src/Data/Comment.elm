module Data.Comment exposing (Comment, decode, emptyNewComment, encode)

import Json.Decode as Decode exposing (Decoder, field, int, map5, string)
import Json.Encode as Encode exposing (Value)


type alias Comment =
    { id : String
    , created_at : String
    , user_email : String
    , user_id : String
    , message : String
    }


emptyNewComment : Comment
emptyNewComment =
    Comment "" "" "" "" ""


decode : Decoder Comment
decode =
    map5 Comment
        (field "id" string)
        (field "created_at" string)
        (field "user_email" string)
        (field "user_id" string)
        (field "message" string)


encode : Comment -> Value
encode record =
    Encode.object
        [ ( "message", Encode.string <| record.message )
        ]
