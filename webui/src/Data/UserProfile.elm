module Data.UserProfile exposing (UserProfile, decode)

import Json.Decode as Decode exposing (Decoder, bool, field, map7, string)


type alias UserProfile =
    { sub : String
    , email_verified : Bool
    , name : String
    , username : String
    , firstName : String
    , familyName : String
    , email : String
    }


decode : Decoder UserProfile
decode =
    map7 UserProfile
        (field "sub" string)
        (field "email_verified" bool)
        (field "name" string)
        (field "preferred_username" string)
        (field "given_name" string)
        (field "family_name" string)
        (field "email" string)
