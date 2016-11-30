-- The MIT License (MIT)
-- Copyright (c) 2016 Josh Adams
-- Copyright (c) 2016 Kindly Ops, LLC
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


module Route exposing (..)

import String exposing (split)
import Navigation


type Location
    = Login
    | Home
    | Users
    | NewUser
    | ShowUser Int
    | EditUser Int
    | Projects
    | NewProject
    | ShowProject Int
    | EditProject Int
    | Organizations
    | NewOrganization
    | ShowOrganization Int
    | EditOrganization Int


type alias Model =
    Maybe Location


init : Maybe Navigation.Location -> Model
init location =
    locFor location


urlFor : Location -> String
urlFor loc =
    let
        url =
            case loc of
                Login ->
                    "/login"

                Home ->
                    "/"

                Users ->
                    "/users"

                NewUser ->
                    "/users/new"

                ShowUser id ->
                    "/users/" ++ (toString id)

                EditUser id ->
                    "/users/" ++ (toString id) ++ "/edit"

                Projects ->
                    "/projects"

                NewProject ->
                    "/projects/new"

                ShowProject id ->
                    "/projects/" ++ (toString id)

                EditProject id ->
                    "/projects/" ++ (toString id) ++ "/edit"

                Organizations ->
                    "/organizations"

                NewOrganization ->
                    "/organizations/new"

                ShowOrganization id ->
                    "/organizations/" ++ (toString id)

                EditOrganization id ->
                    "/organizations/" ++ (toString id) ++ "/edit"
    in
        "#" ++ url


locFor : Maybe Navigation.Location -> Maybe Location
locFor path =
    case path of
        Nothing ->
            Nothing

        Just path ->
            let
                segments =
                    path.hash
                        |> split "/"
                        |> List.filter (\seg -> seg /= "" && seg /= "#")
            in
                case segments of
                    [ "login" ] ->
                        Just Login

                    [] ->
                        Just Home

                    [ "users" ] ->
                        Just Users

                    [ "users", "new" ] ->
                        Just NewUser

                    [ "users", stringId ] ->
                        case String.toInt stringId of
                            Ok id ->
                                Just (ShowUser id)

                            Err _ ->
                                Nothing

                    [ "users", stringId, "edit" ] ->
                        String.toInt stringId
                            |> Result.toMaybe
                            |> Maybe.map EditUser

                    [ "projects" ] ->
                        Just Projects

                    [ "projects", "new" ] ->
                        Just NewProject

                    [ "projects", stringId ] ->
                        case String.toInt stringId of
                            Ok id ->
                                Just (ShowProject id)

                            Err _ ->
                                Nothing

                    [ "projects", stringId, "edit" ] ->
                        String.toInt stringId
                            |> Result.toMaybe
                            |> Maybe.map EditProject

                    [ "organizations" ] ->
                        Just Organizations

                    [ "organizations", "new" ] ->
                        Just NewOrganization

                    [ "organizations", stringId ] ->
                        case String.toInt stringId of
                            Ok id ->
                                Just (ShowOrganization id)

                            Err _ ->
                                Nothing

                    [ "organizations", stringId, "edit" ] ->
                        String.toInt stringId
                            |> Result.toMaybe
                            |> Maybe.map EditOrganization

                    _ ->
                        Nothing
