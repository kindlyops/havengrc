module Data.Comment exposing (Comment, emptyNewComment, decode)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Json.Decode.Pipeline exposing (decode, required)


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


decode : Decoder Comment
decode =
    Json.Decode.Pipeline.decode Comment
        |> required "uuid" Decode.string
        |> required "createdAt" Decode.string
        |> required "userEmail" Decode.string
        |> required "userId" Decode.string
        |> required "message" Decode.string


encode : Comment -> Value
encode record =
    Encode.object
        [ ( "message", Encode.string <| record.message )
        ]
