-- The MIT License (MIT)
-- Copyright (c) 2016 Josh Adams
-- Copyright (c) 2016 Kindly Ops, LLC
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


module Route exposing (Model, Route(..), init, locFor, titleFor, urlFor)

import String exposing (fromList, join, split)
import Url
import Url.Builder
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, s, string)


type Route
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


route : Parser (Route -> a) a
route =
    oneOf
        [ map Activity (s "activity")
        , map Comments (s "comments")
        , map Dashboard (s "dashboard")
        , map Home (s "")
        , map Login (s "login")
        , map Privacy (s "privacy")
        , map Landing (s "l")
        , map Reports (s "reports")
        , map Survey (s "survey")
        , map SurveyResponses (s "surveyResponses")
        , map ShowComment (s "comments" </> int)
        , map EditComment (s "comments" </> int </> s "edit")
        , map Terms (s "terms")
        ]


type alias Model =
    Maybe Route


init : Maybe Url.Url -> ( Model, Cmd msg )
init location =
    let
        initialRoute =
            locFor location
    in
    -- TODO when we are loaded with an invalid URL, the wildcard case
    -- in locFor is giving us a route of Nothing, but the browser location
    -- is invalid. In this case the address needs to be updated to the
    -- URL that matches the route or we need to introduce a 404 route.
    -- revisit routing when Elm 0.19 comes out to see if there are better
    -- patterns we should be using
    ( initialRoute, Cmd.none )


titleFor : Route -> String
titleFor r =
    "Haven GRC - "
        ++ (case r of
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
                    "Welcome"

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
           )


urlFor : Route -> String
urlFor loc =
    let
        url =
            case loc of
                Activity ->
                    "/activity/"

                Comments ->
                    "/comments/"

                Dashboard ->
                    "/dashboard/"

                EditComment id ->
                    "/comments/" ++ String.fromInt id ++ "/edit"

                Home ->
                    "/"

                Landing ->
                    "/l/"

                Login ->
                    "/login/"

                Privacy ->
                    "/privacy/"

                Reports ->
                    "/reports/"

                ShowComment id ->
                    "/comments/" ++ String.fromInt id

                Survey ->
                    "/survey/"

                SurveyResponses ->
                    "/surveyResponses/"

                Terms ->
                    "/terms/"
    in
    url


locFor : Maybe Url.Url -> Maybe Route
locFor location =
    case location of
        Nothing ->
            Nothing

        Just loc ->
            let
                selectedRoute =
                    route loc

                segments =
                    loc.path
                        |> split "/"
                        |> List.filter (\seg -> seg /= "" && seg /= "#")

                -- _ =
                --     Debug.log "Route.locFor segments" (toString segments)
                -- _ =
                --     Debug.log "Route.locFor selectedRoute" (toString selectedRoute)
                -- _ =
                --     Debug.log "Route.locFor normal hash" (toString location.hash)
                -- _ =
                --     Debug.log "Route.locFor fixed hash" (toString fixedLocation.hash)
            in
            selectedRoute
