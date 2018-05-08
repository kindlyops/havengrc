module Data.Survey exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Decode.Pipeline exposing (decode, required)


type alias IpsativeServerSurvey =
    { metaData : IpsativeServerMetaData
    , questions : List IpsativeServerQuestion
    }


type alias IpsativeServerMetaData =
    { name : String
    , updated_at : String
    , description : String
    , instructions : String
    , author : String
    }


type alias IpsativeServerQuestion =
    { id : Int
    , title : String
    , answers : List IpsativeServerAnswer
    }


type alias IpsativeServerAnswer =
    { id : Int
    , category : String
    , answer : String
    }


decoder : Decoder IpsativeServerMetaData
decoder =
    decode IpsativeServerMetaData
        |> required "name" Decode.string
        |> required "updated_at" Decode.string
        |> required "description" Decode.string
        |> required "instructions" Decode.string
        |> required "author" Decode.string


ipsativeQuestionDecoder : Decoder IpsativeServerQuestion
ipsativeQuestionDecoder =
    decode IpsativeServerQuestion
        |> required "id" Decode.int
        |> required "title" Decode.string
        |> required "answers" (Decode.list ipsativeAnswerDecoder)


ipsativeAnswerDecoder : Decoder IpsativeServerAnswer
ipsativeAnswerDecoder =
    decode IpsativeServerAnswer
        |> required "id" Decode.int
        |> required "category" Decode.string
        |> required "answer" Decode.string
