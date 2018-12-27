-- Copyright (c) 2016 Kindly Ops, LLC


module Route exposing (Route(..), locFor, pathFor, titleFor)

import String exposing (fromList, join, split)
import Url
import Url.Builder
import Url.Parser exposing ((</>), (<?>), Parser, int, map, oneOf, parse, s, string, top)


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
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home top
        , map Activity (s "activity")
        , map Comments (s "comments")
        , map Dashboard (s "dashboard")
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

                NotFound ->
                    "Not Found"
           )


pathFor : Route -> String
pathFor loc =
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

                NotFound ->
                    "/"
    in
    url


locFor : Url.Url -> Route
locFor url =
    case parse routeParser url of
        Just route ->
            route

        Nothing ->
            NotFound
