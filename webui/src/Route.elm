-- The MIT License (MIT)
-- Copyright (c) 2016 Josh Adams
-- Copyright (c) 2016 Kindly Ops, LLC
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


module Route exposing (Route(..), Model, init, locFor, titleFor, urlFor)

import String exposing (split, fromList, join)
import String.Extra exposing (replace)
import List.Extra exposing (getAt)
import Navigation
import UrlParser exposing ((</>), (<?>), s, int, string, parseHash, Parser, oneOf)


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
        [ UrlParser.map Activity (s "activity")
        , UrlParser.map Comments (s "comments")
        , UrlParser.map Dashboard (s "dashboard")
        , UrlParser.map Home (s "")
        , UrlParser.map Login (s "login")
        , UrlParser.map Privacy (s "privacy")
        , UrlParser.map Landing (s "l")
        , UrlParser.map Reports (s "reports")
        , UrlParser.map Survey (s "survey")
        , UrlParser.map SurveyResponses (s "surveyResponses")
        , UrlParser.map ShowComment (s "comments" </> int)
        , UrlParser.map EditComment (s "comments" </> int </> s "edit")
        , UrlParser.map Terms (s "terms")
        ]


fixLocationQuery : Navigation.Location -> Navigation.Location
fixLocationQuery location =
    let
        firstQuestionMarkReplacedWithAmpersand =
            case (String.split "/" location.hash) of
                first :: second :: third :: rest ->
                    let
                        dropped =
                            third |> String.split "&" |> List.drop 1

                        newString =
                            if (List.length dropped) > 0 then
                                "?" ++ (String.join "&" dropped)
                            else
                                third
                    in
                        first :: second :: newString :: rest

                _ ->
                    []

        replacedHash =
            join "/" firstQuestionMarkReplacedWithAmpersand

        hash =
            String.split "?" replacedHash
                |> List.head
                |> Maybe.withDefault ""

        search =
            String.split "?" replacedHash
                |> List.drop 1
                |> String.join "?"
                |> String.append "?"
    in
        { location | hash = hash, search = search }


type alias Model =
    Maybe Route


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

            Just _ ->
                ( route, Cmd.none )


titleFor : Route -> String
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

                Home ->
                    "/"

                Login ->
                    "/login/"

                Privacy ->
                    "/privacy/"

                Landing ->
                    "/l/"

                Reports ->
                    "/reports/"

                Survey ->
                    "/survey/"

                SurveyResponses ->
                    "/surveyResponses/"

                ShowComment id ->
                    "/comments/" ++ toString id

                EditComment id ->
                    "/comments/" ++ toString id ++ "/edit"

                Terms ->
                    "/terms/"
    in
        "#" ++ url


locFor : Maybe Navigation.Location -> Maybe Route
locFor location =
    case location of
        Nothing ->
            Nothing

        Just location ->
            let
                fixedLocation =
                    fixLocationQuery location

                selectedRoute =
                    parseHash route fixedLocation

                segments =
                    location.hash
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
