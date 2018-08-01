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
    | Activity
    | Comments
    | Dashboard
    | EditComment Int
    | Home
    | Privacy
    | Landing
    | Reports
    | ShowComment Int
    | Survey
    | SurveyResponses
    | Terms


type alias Model =
    Maybe Location


init : Maybe Navigation.Location -> ( Model, Cmd msg )
init location =
    let
        route =
            locFor location

        _ =
            Debug.log "Route.init : " (toString route)
    in
        -- TODO when we are loaded with an invalid URL, the wildcard case
        -- in locFor is giving us a route of Nothing, but the browser location
        -- is invalid. In this case the address needs to be updated to the
        -- URL that matches the route or we need to introduce a 404 route.
        -- revisit routing when Elm 0.19 comes out to see if there are better
        -- patterns we should be using
        case route of
            Nothing ->
                ( route, Navigation.newUrl (urlFor Home) )

            Just location ->
                ( route, Cmd.none )


titleFor : Location -> String
titleFor route =
    "Haven GRC - "
        ++ case route of
            Activity ->
                "Activity"

            Comments ->
                "Comments"

            Dashboard ->
                "Dashboard"

            EditComment _ ->
                "Thread"

            Home ->
                "Home"

            Login ->
                "Login"

            Privacy ->
                "Privacy Policy"

            Landing ->
                "Landing Page"

            Reports ->
                "Reports"

            ShowComment _ ->
                "Comment"

            Survey ->
                "Survey"

            SurveyResponses ->
                "Survey Responses"

            Terms ->
                "Terms of Service"


urlFor : Location -> String
urlFor loc =
    let
        url =
            case loc of
                Activity ->
                    "/activity"

                Comments ->
                    "/comments"

                Dashboard ->
                    "/dashboard"

                EditComment id ->
                    "/comments/" ++ (toString id) ++ "/edit"

                Home ->
                    "/"

                Login ->
                    "/login"

                Privacy ->
                    "/privacy"

                Landing ->
                    "/l"

                Reports ->
                    "/reports"

                ShowComment id ->
                    "/comments/" ++ (toString id)

                Survey ->
                    "/survey"

                SurveyResponses ->
                    "/surveyResponses"

                Terms ->
                    "/terms"
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

                _ =
                    Debug.log "Route.locFor " (toString segments)
            in
                case segments of
                    [] ->
                        Just Home

                    [ "activity" ] ->
                        Just Activity

                    [ "comments" ] ->
                        Just Comments

                    [ "comments", stringId ] ->
                        case String.toInt stringId of
                            Ok id ->
                                Just (ShowComment id)

                            Err _ ->
                                Nothing

                    [ "comments", stringId, "edit" ] ->
                        String.toInt stringId
                            |> Result.toMaybe
                            |> Maybe.map EditComment

                    [ "dashboard" ] ->
                        Just Dashboard

                    [ "login" ] ->
                        Just Login

                    [ "privacy" ] ->
                        Just Privacy

                    [ "l" ] ->
                        Just Landing

                    [ "reports" ] ->
                        Just Reports

                    [ "survey" ] ->
                        Just Survey

                    [ "surveyResponses" ] ->
                        Just SurveyResponses

                    [ "terms" ] ->
                        Just Terms

                    _ ->
                        let
                            _ =
                                Debug.log "Route.locFor resolved wildcard, location Nothing" ""
                        in
                            Nothing
