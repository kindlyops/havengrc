module Survey exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List.Zipper as Zipper exposing (..)


type Page
    = Home
    | SurveyInstructions
    | Survey
    | IncompleteSurvey
    | Finished


type alias Model =
    { currentSurvey : Survey
    , availableSurveys : List Survey
    , currentPage : Page
    , numberOfGroups : Int
    }



--init : ( Model, Cmd Msg )


init : Model
init =
    { currentSurvey = forceSurveyData
    , availableSurveys = [ scdsSurveyData, forceSurveyData ]
    , currentPage = Home
    , numberOfGroups = 2
    }



--init : ( Model, Cmd Msg )
--init =
--    ( { currentSurvey = forceSurveyData
--      , availableSurveys = [ scdsSurveyData, forceSurveyData ]
--      , currentPage = Home
--      , numberOfGroups = 2
--      }
--    , Cmd.none
--    )


type Msg
    = NoOp
    | StartLikertSurvey
    | StartIpsativeSurvey
    | BeginLikertSurvey
    | BeginIpsativeSurvey
    | IncrementAnswer IpsativeAnswer Int
    | DecrementAnswer IpsativeAnswer Int
    | NextQuestion
    | PreviousQuestion
    | GoToHome
    | ChangeNumberOfGroups String
    | FinishSurvey
      --| GenerateChart
    | SelectLikertAnswer Int String
    | GotoQuestion Survey Int


limitNumberOfGroups : Int -> Int
limitNumberOfGroups input =
    if input < 0 then
        1
    else
        input



--update : Msg -> Model -> ( Model, Cmd Msg )


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        SelectLikertAnswer answerNumber choice ->
            let
                newSurvey =
                    case model.currentSurvey of
                        Likert survey ->
                            Likert (selectLikertAnswer survey answerNumber choice)

                        _ ->
                            model.currentSurvey
            in
                { model | currentSurvey = newSurvey }

        --GenerateChart ->
        --    case model.currentSurvey of
        --        Ipsative survey ->
        --            ( model, Ports.radarChart (RadarChart.generateIpsativeChart survey) )
        --        _ ->
        --            model
        ChangeNumberOfGroups number ->
            let
                newNumber =
                    String.toInt number |> Result.toMaybe |> Maybe.withDefault model.numberOfGroups |> limitNumberOfGroups
            in
                { model | numberOfGroups = newNumber }

        GoToHome ->
            { model | currentPage = Home }

        FinishSurvey ->
            if validateSurvey model.currentSurvey then
                { model | currentPage = Finished }
            else
                { model | currentPage = IncompleteSurvey }

        StartLikertSurvey ->
            { model | currentPage = Survey }

        StartIpsativeSurvey ->
            { model | currentPage = Survey }

        BeginLikertSurvey ->
            let
                newModel =
                    { model | currentSurvey = forceSurveyData }
            in
                { newModel | currentPage = SurveyInstructions }

        BeginIpsativeSurvey ->
            let
                newSurvey =
                    createIpsativeSurvey 10 model.numberOfGroups scdsMetaData scdsQuestions

                newModel =
                    { model | currentSurvey = newSurvey }
            in
                { newModel | currentPage = SurveyInstructions }

        NextQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            { model | currentSurvey = Ipsative { survey | questions = x } }

                        _ ->
                            { model | currentSurvey = Ipsative survey }

                Likert survey ->
                    case Zipper.next survey.questions of
                        Just x ->
                            { model | currentSurvey = Likert { survey | questions = x } }

                        _ ->
                            { model | currentSurvey = Likert survey }

        PreviousQuestion ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.previous survey.questions of
                        Just x ->
                            { model | currentSurvey = Ipsative { survey | questions = x } }

                        _ ->
                            { model | currentSurvey = Ipsative survey }

                Likert survey ->
                    case Zipper.previous survey.questions of
                        Just x ->
                            { model | currentSurvey = Likert { survey | questions = x } }

                        _ ->
                            { model | currentSurvey = Likert survey }

        DecrementAnswer answer groupNumber ->
            --if points for this answer is > 0,
            --then decrement the point in this answer and
            --increment the points left for the group
            let
                newSurvey =
                    case model.currentSurvey of
                        Ipsative survey ->
                            Ipsative (decrementAnswer survey answer groupNumber)

                        _ ->
                            model.currentSurvey
            in
                { model | currentSurvey = newSurvey }

        IncrementAnswer answer groupNumber ->
            --    --if points left in group > 0,
            --then increment the point in the group for
            --this answer and decrement the points assigned for the group
            let
                newSurvey =
                    case model.currentSurvey of
                        Ipsative survey ->
                            Ipsative (incrementAnswer survey answer groupNumber)

                        _ ->
                            model.currentSurvey
            in
                { model | currentSurvey = newSurvey }

        GotoQuestion survey questionNumber ->
            case model.currentSurvey of
                Ipsative survey ->
                    case Zipper.find (\x -> x.id == questionNumber) (Zipper.first survey.questions) of
                        Just x ->
                            { model | currentSurvey = Ipsative { survey | questions = x }, currentPage = Survey }

                        _ ->
                            { model | currentSurvey = Ipsative survey }

                Likert survey ->
                    case Zipper.find (\x -> x.id == questionNumber) (Zipper.first survey.questions) of
                        Just x ->
                            { model | currentSurvey = Likert { survey | questions = x }, currentPage = Survey }

                        _ ->
                            { model | currentSurvey = Likert survey }


validateSurvey : Survey -> Bool
validateSurvey survey =
    if List.length (getIncompleteQuestions survey) == 0 then
        True
    else
        False


getIncompleteQuestions : Survey -> List Int
getIncompleteQuestions survey =
    case survey of
        Ipsative survey ->
            --Survey question is good if all the points for all the groups for all the answers is zero
            List.foldr
                (\question incompleteQuestions ->
                    if validateIpsativeQuestion question then
                        incompleteQuestions
                    else
                        question.id :: incompleteQuestions
                )
                []
                (Zipper.toList survey.questions)

        Likert survey ->
            --Survey question is good if all the answers have a selectedChoice
            List.foldr
                (\question incompleteQuestions ->
                    if validateLikertQuestion question then
                        incompleteQuestions
                    else
                        question.id :: incompleteQuestions
                )
                []
                (Zipper.toList survey.questions)


validateLikertQuestion : LikertQuestion -> Bool
validateLikertQuestion question =
    let
        checkedQuestions =
            List.filterMap
                (\answer ->
                    answer.selectedChoice
                )
                question.answers
    in
        if List.length checkedQuestions == List.length question.answers then
            True
        else
            False


validateIpsativeQuestion : IpsativeQuestion -> Bool
validateIpsativeQuestion question =
    let
        checkedQuestions =
            List.filterMap
                (\pointsLeft ->
                    validatePointsLeft pointsLeft
                )
                question.pointsLeft
    in
        if List.length checkedQuestions == 0 then
            True
        else
            False


validatePointsLeft : PointsLeft -> Maybe Bool
validatePointsLeft pointsLeft =
    if pointsLeft.pointsLeft == 0 then
        Nothing
    else
        Just False


selectLikertAnswer : LikertSurvey -> Int -> String -> LikertSurvey
selectLikertAnswer survey answerNumber choice =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    { id = question.id
                    , title = question.title
                    , choices = question.choices
                    , answers =
                        List.map
                            (\answer ->
                                if answer.id == answerNumber then
                                    { answer
                                        | selectedChoice = Just choice
                                    }
                                else
                                    answer
                            )
                            question.answers
                    }
                )
                survey.questions
    in
        { survey | questions = newQuestions }


incrementAnswer : IpsativeSurvey -> IpsativeAnswer -> Int -> IpsativeSurvey
incrementAnswer survey answer groupNumber =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    { id = question.id
                    , title = question.title
                    , pointsLeft =
                        List.map
                            (\pointsLeftInGroup ->
                                if pointsLeftInGroup.group == groupNumber then
                                    if pointsLeftInGroup.pointsLeft > 0 then
                                        { group = groupNumber, pointsLeft = pointsLeftInGroup.pointsLeft - 1 }
                                    else
                                        pointsLeftInGroup
                                else
                                    pointsLeftInGroup
                            )
                            question.pointsLeft
                    , answers =
                        List.map
                            (\x ->
                                if x.id == answer.id then
                                    { x
                                        | pointsAssigned =
                                            List.map
                                                (\y ->
                                                    if y.group == groupNumber then
                                                        if isPointsInGroup question.pointsLeft groupNumber then
                                                            { y | points = y.points + 1 }
                                                        else
                                                            y
                                                    else
                                                        y
                                                )
                                                x.pointsAssigned
                                    }
                                else
                                    x
                            )
                            question.answers
                    }
                )
                survey.questions
    in
        { survey | questions = newQuestions }


decrementAnswer : IpsativeSurvey -> IpsativeAnswer -> Int -> IpsativeSurvey
decrementAnswer survey answer groupNumber =
    let
        newQuestions =
            Zipper.mapCurrent
                (\question ->
                    { id = question.id
                    , title = question.title
                    , pointsLeft =
                        List.map
                            (\pointsLeftInGroup ->
                                if pointsLeftInGroup.group == groupNumber then
                                    if isAnswerGreaterThanZero answer groupNumber then
                                        { pointsLeftInGroup | pointsLeft = pointsLeftInGroup.pointsLeft + 1 }
                                    else
                                        pointsLeftInGroup
                                else
                                    pointsLeftInGroup
                            )
                            question.pointsLeft
                    , answers =
                        List.map
                            (\x ->
                                if x.id == answer.id then
                                    { x
                                        | pointsAssigned =
                                            List.map
                                                (\y ->
                                                    if y.group == groupNumber then
                                                        if y.points > 0 then
                                                            { y | points = y.points - 1 }
                                                        else
                                                            y
                                                    else
                                                        y
                                                )
                                                x.pointsAssigned
                                    }
                                else
                                    x
                            )
                            question.answers
                    }
                )
                survey.questions
    in
        { survey | questions = newQuestions }


isAnswerGreaterThanZero answer group =
    let
        filtered =
            List.filter (\x -> x.group == group) answer.pointsAssigned

        first =
            List.head filtered
    in
        case first of
            Just x ->
                if x.points > 0 then
                    True
                else
                    False

            _ ->
                False


isPointsInGroup pointsLeft group =
    let
        filtered =
            List.filter (\x -> x.group == group) pointsLeft

        first =
            List.head filtered
    in
        case first of
            Just x ->
                if x.pointsLeft > 0 then
                    True
                else
                    False

            _ ->
                False


view : Model -> Html.Html Msg
view model =
    div [] [ viewNavbar, viewApp model ]


viewApp : Model -> Html Msg
viewApp model =
    case model.currentPage of
        Home ->
            viewHero model

        SurveyInstructions ->
            viewSurveyInstructions model.currentSurvey

        Survey ->
            viewSurvey model.currentSurvey

        IncompleteSurvey ->
            viewIncomplete model.currentSurvey

        Finished ->
            viewFinished model


viewIncomplete : Survey -> Html Msg
viewIncomplete survey =
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div [ class "jumbotron" ]
                ([ h1 [ class "display-4" ] [ text "Incomplete Survey" ]
                 , p [ class "lead" ] [ text "You haven't answered all of the survey questions fully." ]
                 ]
                    ++ viewIncompleteButtons survey (getIncompleteQuestions survey)
                )
            ]
        ]


viewIncompleteButtons : Survey -> List Int -> List (Html Msg)
viewIncompleteButtons survey questionNumbers =
    List.map
        (\questionNumber ->
            div [ class "my-2" ] [ button [ class "btn btn-primary", onClick (GotoQuestion survey questionNumber) ] [ text ("Click to go back to question " ++ (toString questionNumber)) ] ]
        )
        questionNumbers


viewSurveyInstructions : Survey -> Html Msg
viewSurveyInstructions survey =
    case survey of
        Ipsative survey ->
            viewIpsativeSurveyInstructions survey

        Likert survey ->
            viewLikertSurveyInstructions survey


viewIpsativeSurveyInstructions : IpsativeSurvey -> Html Msg
viewIpsativeSurveyInstructions survey =
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div
                [ class "jumbotron" ]
                [ h1 [ class "display-4" ] [ text survey.metaData.name ]
                , p [ class "lead" ] [ text survey.metaData.instructions ]
                , hr [ class "my-4" ] []
                , button [ class "btn btn-primary", onClick StartIpsativeSurvey ] [ text "Begin" ]
                ]
            ]
        ]


viewLikertSurveyInstructions : LikertSurvey -> Html Msg
viewLikertSurveyInstructions survey =
    div [ class "container mt-3" ]
        [ div [ class "row" ]
            [ div
                [ class "jumbotron" ]
                [ h1 [ class "display-4" ] [ text survey.metaData.name ]
                , p [ class "lead" ] [ text survey.metaData.instructions ]
                , hr [ class "my-4" ] []
                , button [ class "btn btn-primary", onClick StartLikertSurvey ] [ text "Begin" ]
                ]
            ]
        ]


viewHero : Model -> Html Msg
viewHero model =
    div [ class "jumbotron" ]
        [ h1 [ class "display-4" ] [ text "KindlyOps Haven Survey Prototype" ]
        , p [ class "lead" ] [ text "Welcome to the Elm Haven Survey Prototype. " ]
        , hr [ class "my-4" ] []
        , p [ class "" ] [ text ("There are currently " ++ (toString (List.length model.availableSurveys)) ++ " surveys to choose from.") ]
        , div [ class "row" ]
            (List.map
                (\survey ->
                    case survey of
                        Ipsative survey ->
                            div [ class "col-sm" ]
                                [ viewScdsCard survey model.numberOfGroups
                                ]

                        Likert survey ->
                            div [ class "col-sm" ]
                                [ viewForceCard survey
                                ]
                )
                model.availableSurveys
            )
        ]


viewForceCard : LikertSurvey -> Html Msg
viewForceCard survey =
    div [ class "card" ]
        [ div [ class "card-header" ] [ text "Likert" ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text survey.metaData.name
                ]
            , p [ class "card-text" ] [ text survey.metaData.description ]
            ]
        , ul [ class "list-group list-group-flush" ]
            [ li [ class "list-group-item" ] [ text ("Last Updated: " ++ survey.metaData.lastUpdated) ]
            , li [ class "list-group-item" ] [ text ("Created By: " ++ survey.metaData.createdBy) ]
            , li [ class "list-group-item" ] [ button [ class "btn btn-primary", onClick BeginLikertSurvey ] [ text "Click to start survey" ] ]
            ]
        ]


viewScdsCard : IpsativeSurvey -> Int -> Html Msg
viewScdsCard survey numberOfGroups =
    div [ class "card" ]
        [ div [ class "card-header" ] [ text "Ipsative" ]
        , div [ class "card-body" ]
            [ h5 [ class "card-title" ]
                [ text survey.metaData.name
                ]
            , p [ class "card-text" ] [ text survey.metaData.description ]
            ]
        , ul [ class "list-group list-group-flush" ]
            [ li [ class "list-group-item" ] [ text ("Last Updated: " ++ survey.metaData.lastUpdated) ]
            , li [ class "list-group-item" ] [ text ("Created By: " ++ survey.metaData.createdBy) ]
            , li [ class "list-group-item" ]
                [ label [] [ text "Number of Groups" ]
                , input
                    [ type_ "number"
                    , class "form-control form-control-sm"
                    , onInput ChangeNumberOfGroups
                    , Html.Attributes.value (toString numberOfGroups)
                    ]
                    []
                ]
            , li [ class "list-group-item" ] [ button [ class "btn btn-primary", onClick BeginIpsativeSurvey ] [ text ("Click to Start Survey with " ++ (toString numberOfGroups) ++ " Groups") ] ]
            ]
        ]


viewFinished : Model -> Html Msg
viewFinished model =
    case model.currentSurvey of
        Ipsative survey ->
            div [ class "container mt-3" ]
                [ div [ class "row" ]
                    [ div [ class "jumbotron" ]
                        [ h1 [ class "display-4" ] [ text "You finished the survey!" ]
                        , button [ class "btn btn-primary", onClick NoOp ] [ text "Click to generate radar chart of results." ]
                        , canvas [ id "chart" ] []
                        ]
                    ]
                ]

        Likert survey ->
            div [] [ text "You finished the survey!" ]


viewSurvey : Survey -> Html Msg
viewSurvey survey =
    case survey of
        Ipsative survey ->
            viewIpsativeSurvey survey

        Likert survey ->
            viewLikertSurvey survey


viewLikertSurvey : LikertSurvey -> Html Msg
viewLikertSurvey survey =
    div [ class "container-fluid" ]
        [ viewLikertSurveyTitle survey
        , br [] []
        , viewLikertSurveyTable (Zipper.current survey.questions)
        , br [] []
        , viewSurveyFooter
        ]


viewLikertSurveyTable : LikertQuestion -> Html Msg
viewLikertSurveyTable surveyQuestion =
    div [ class "row" ]
        [ div [ class "col-md" ]
            [ table [ class "table table-bordered table-hover table-sm" ]
                [ viewLikertSurveyTableHeader surveyQuestion
                , viewLikertSurveyTableRows surveyQuestion
                ]
            ]
        ]


viewLikertSurveyTableRows question =
    tbody []
        (List.map
            (\answer ->
                tr [ class "" ]
                    (td [] [ text answer.answer ]
                        :: (List.map
                                (\choice ->
                                    if isLikertSelected answer choice then
                                        td [ class "bg-success text-white text-center", onClick (SelectLikertAnswer answer.id choice) ]
                                            [ i [ class "material-icons" ] [ text "check" ] ]
                                    else
                                        td [ class "", onClick (SelectLikertAnswer answer.id choice) ]
                                            [ div [ class "" ] []
                                            ]
                                )
                                question.choices
                           )
                    )
            )
            question.answers
        )


isLikertSelected : LikertAnswer -> String -> Bool
isLikertSelected answer choice =
    case answer.selectedChoice of
        Just x ->
            if x == choice then
                True
            else
                False

        Nothing ->
            False


viewLikertSurveyTableHeader : LikertQuestion -> Html Msg
viewLikertSurveyTableHeader surveyQuestion =
    thead [ class "thead-light" ]
        [ tr [ class "" ]
            (th [ class " " ] [ text "Statement" ]
                :: (List.map
                        (\choice ->
                            th [ class " " ] [ text choice ]
                        )
                        surveyQuestion.choices
                   )
            )
        ]


viewIpsativeSurvey survey =
    div [ class "container-fluid" ]
        [ viewIpsativeSurveyTitle survey
        , br [] []
        , viewIpsativeSurveyBoxes (Zipper.current survey.questions)
        , br [] []
        , viewSurveyFooter
        ]


viewNavbar : Html Msg
viewNavbar =
    nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
        [ a [ class "navbar-brand", style [ ( "cursor", "pointer" ) ], onClick GoToHome ]
            [ text "Haven Survey Prototype" ]
        , button [ attribute "aria-controls" "navbarSupportedContent", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation", class "navbar-toggler", attribute "data-target" "#navbarSupportedContent", attribute "data-toggle" "collapse", type_ "button" ]
            [ span [ class "navbar-toggler-icon" ]
                []
            ]
        , div [ class "collapse navbar-collapse", id "navbarSupportedContent" ]
            [ ul [ class "navbar-nav mr-auto" ]
                [ li [ class "nav-item active" ]
                    [ a [ class "nav-link", style [ ( "cursor", "pointer" ) ], onClick GoToHome ]
                        [ text "Home "
                        , span [ class "sr-only" ]
                            [ text "(current)" ]
                        ]
                    ]
                , li [ class "nav-item" ]
                    [ a [ class "nav-link", href "https://github.com/kindlyops/elm-survey-prototype" ]
                        [ text "Github" ]
                    ]
                ]
            ]
        ]


viewLikertSurveyTitle : LikertSurvey -> Html Msg
viewLikertSurveyTitle survey =
    let
        currentQuestion =
            Zipper.current survey.questions

        questionNumber =
            currentQuestion.id

        totalQuestions =
            List.length (Zipper.toList survey.questions)

        questionTitle =
            currentQuestion.title
    in
        div [ class "row" ]
            [ div [ class "col-lg ", style [ ( "text-align", "center" ) ] ]
                [ h3 [ class "" ] [ text ("Question " ++ (toString questionNumber) ++ " of " ++ (toString totalQuestions)) ]
                , h4 [] [ text questionTitle ]
                ]
            ]


viewIpsativeSurveyTitle : IpsativeSurvey -> Html Msg
viewIpsativeSurveyTitle survey =
    let
        currentQuestion =
            Zipper.current survey.questions

        questionNumber =
            currentQuestion.id

        totalQuestions =
            List.length (Zipper.toList survey.questions)

        questionTitle =
            currentQuestion.title
    in
        div [ class "row" ]
            [ div [ class "col-lg ", style [ ( "text-align", "center" ) ] ]
                [ h3 [ class "" ] [ text ("Question " ++ (toString questionNumber) ++ " of " ++ (toString totalQuestions)) ]
                , h4 [] [ text questionTitle ]
                , div [ class "row" ] (viewPointsLeft currentQuestion.pointsLeft survey.pointsPerQuestion)
                ]
            ]


viewPointsLeft : List PointsLeft -> Int -> List (Html Msg)
viewPointsLeft pointsLeft pointsPerQuestion =
    List.map
        (\x ->
            div [ class "col-md" ]
                [ p [] [ text ("Group " ++ (toString x.group) ++ ": " ++ (toString x.pointsLeft) ++ "/" ++ (toString pointsPerQuestion)) ]
                , div [ class "progress" ]
                    [ div [ class "progress-bar bg-primary", style [ (calculateProgressBarPercent x.pointsLeft pointsPerQuestion) ] ] []
                    ]
                ]
        )
        pointsLeft


calculateProgressBarPercent : Int -> Int -> ( String, String )
calculateProgressBarPercent current max =
    let
        percent =
            100 * ((toFloat current) / (toFloat max))

        percentString =
            toString percent ++ "%"
    in
        ( "width", percentString )


viewIpsativeSurveyBoxes : IpsativeQuestion -> Html Msg
viewIpsativeSurveyBoxes surveyQuestion =
    div [ class "row" ]
        (List.map
            (\answer ->
                viewSurveyBox answer
            )
            surveyQuestion.answers
        )


viewSurveyBox : IpsativeAnswer -> Html Msg
viewSurveyBox answer =
    div [ class "col-md-6" ]
        [ div [ class "card mb-4 box-shadow" ]
            [ div [ class "card-body" ]
                [ p [ class "card-text h5 mb-4" ] [ text answer.answer ]
                , ul [ class "list-group list-group-flush" ]
                    (List.map
                        (\group -> viewSurveyPointsGroup answer group)
                        answer.pointsAssigned
                    )
                ]
            ]
        ]


viewSurveyPointsGroup answer group =
    li [ class "list-group-item" ]
        [ div [ class "row" ]
            [ div [ class "col-6" ]
                [ p [ class "card-text" ] [ text ("Group " ++ toString group.group ++ ":") ]
                ]
            , div [ class "col-6 " ]
                [ button [ type_ "button", class "btn btn-outline-primary", onClick (DecrementAnswer answer group.group) ] [ i [ class "material-icons" ] [ text "remove" ] ]
                , span [ class " px-4 align-middle h5 " ] [ text (toString group.points) ]
                , button [ type_ "button", class "btn btn-outline-primary", onClick (IncrementAnswer answer group.group) ] [ i [ class "material-icons" ] [ text "add" ] ]
                ]
            ]
        ]


viewSurveyFooter : Html Msg
viewSurveyFooter =
    div [ class "row mb-4 pb-4" ]
        [ div [ class "col-md-8" ] []
        , div [ class "col-md-4 " ]
            [ button [ class "btn btn-primary btn-lg mx-1", onClick GoToHome ] [ text "Back" ]
            , button [ class "btn btn-default btn-lg mx-1", onClick PreviousQuestion ] [ text "<" ]
            , button [ class "btn btn-default btn-lg mx-1", onClick NextQuestion ] [ text ">" ]
            , button [ class "btn btn-primary btn-lg mx-1", onClick FinishSurvey ] [ text "Finish" ]
            ]
        ]


scdsSurveyData : Survey
scdsSurveyData =
    createIpsativeSurvey 10 2 scdsMetaData scdsQuestions


forceSurveyData : Survey
forceSurveyData =
    createLikertSurvey forceMetaData forceServerQuestions


forceMetaData : LikertMetaData
forceMetaData =
    { name = "Security FORCE Survey"
    , createdBy = "Lance Hayden"
    , lastUpdated = "09/15/2015"
    , description = "Survey to identify existing security culture in an organization."
    , choices =
        [ "Strongly Disagree"
        , "Disagree"
        , "Neutral"
        , "Agree"
        , "Strongly Agree"
        ]
    , instructions = "To complete this Security FORCE Survey, please indicate your level of agreement with each of the following statements regarding information security values and practices within your organization. Choose one response per statement. Please respond to all statements."
    }


scdsMetaData : IpsativeMetaData
scdsMetaData =
    { name = "SCDS"
    , description = "Survey to identify existing security culture in an organization."
    , lastUpdated = "09/15/2015"
    , instructions = "For each question, assign a total of 10 points, divided among the four statements based on how accurately you think each describes your organization."
    , createdBy = "Lance Hayden"
    }


forceServerQuestions : List LikertServerQuestion
forceServerQuestions =
    [ { title = "Security Value of Failure"
      , id = 1
      , answers =
            [ { id = 1
              , answer = "I feel confident I could predict where the organization’s next security incident will happen."
              }
            , { id = 2
              , answer = "I regularly identify security problems while doing my job."
              }
            , { id = 3
              , answer = "I feel very comfortable reporting security problems up the management chain."
              }
            , { id = 4
              , answer = "I know that security problems I report will be taken seriously."
              }
            , { id = 5
              , answer = "When a security problem is found, it gets fixed."
              }
            ]
      }
    , { title = "Security Value of Operations"
      , id = 2
      , answers =
            [ { id = 1
              , answer = "I know that someone is constantly keeping watch over how secure the organization is."
              }
            , { id = 2
              , answer = "I am confident that information security in the organization actually works the way that people and policies say it does."
              }
            , { id = 3
              , answer = "I feel like there are many experts around the organization willing and able to help me understand how things work."
              }
            , { id = 4
              , answer = "Management and the security team regularly share information about security assessments."
              }
            , { id = 5
              , answer = "Management stays actively involved in security and makes sure appropriate resources are available."
              }
            ]
      }
    , { title = "Security Value of Resilience"
      , id = 3
      , answers =
            [ { id = 1
              , answer = "I feel like people are trained to know more about security than just the minimum level necessary."
              }
            , { id = 2
              , answer = "The organization has reserves of skill and expertise to call on in the event of a security incident or crisis."
              }
            , { id = 3
              , answer = "I feel like everyone in the organization is encouraged to “get out of their comfort zone” and be part of security challenges. "
              }
            , { id = 4
              , answer = "I feel like people are interested in what I know about security, and willing to share their own skills to help me as well."
              }
            , { id = 5
              , answer = "The organization often conducts drills and scenarios to test how well we respond to security incidents and failures."
              }
            ]
      }
    , { title = "Security Value of Complexity"
      , id = 4
      , answers =
            [ { id = 1
              , answer = "I feel like people in the organization prefer complex explanations over simple ones."
              }
            , { id = 2
              , answer = "I feel like people are open to being challenged or questioned about how they arrived at an answer."
              }
            , { id = 3
              , answer = "The organization always has plenty of data to explain and justify its decisions."
              }
            , { id = 4
              , answer = "People from outside the security team are encouraged to participate and question security plans and decisions."
              }
            , { id = 5
              , answer = "The organization formally reviews strategies and predictions to make sure they were accurate, and adjusts accordingly."
              }
            ]
      }
    , { title = "Security Value of Expertise"
      , id = 5
      , answers =
            [ { id = 1
              , answer = "I know exactly where to go in the organization when I need an expert."
              }
            , { id = 2
              , answer = "I think everyone in the organization feels that monitoring security is part of their job."
              }
            , { id = 3
              , answer = "In the event of a security incident, people can legitimately bypass the bureaucracy to get things done."
              }
            , { id = 4
              , answer = "People in the organization are encouraged to help other groups if they have the right skills to help them."
              }
            , { id = 5
              , answer = "I feel empowered to take action myself, if something is about to cause a security failure."
              }
            ]
      }
    ]


scdsQuestions : List IpsativeServerQuestion
scdsQuestions =
    [ { id = 1
      , title = "What's valued most?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Stability and reliability are valued most by the organization. It is critical that everyone knows the rules and follows them. The organization cannot succeed if people are all doing things different ways without centralized visibility."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Successfully meeting external requirements is valued most by the organization. The organization is under a lot of scrutiny. It cannot succeed if people fail audits or do not live up to the expectations of those watching."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Adapting quickly and competing aggressively are valued most by the organization. Results are what matters. The organization cannot succeed if bureaucracy and red tape impair people's ability to be agile."
              }
            , { id = 4
              , category = "Trust"
              , answer = "People and a sense of community are valued most by the organization. Everyone is in it together. The organization cannot succeed unless people are given the opportunities and skills to succeed on their own."
              }
            ]
      }
    , { id = 2
      , title = "How does the organization work?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "The organization works on authority, policy, and standard ways of doing things. Organizational charts are formal and important. The organization is designed to ensure control and efficiency."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "The organization works on outside requirements and regular reviews. Audits are a central feature of life. The organization is designed to ensure everyone meets their obligations."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "The organization works on independent action and giving people decision authority. There's no one right way to do things. The organization is designed to ensure that the right things get done in the right situations."
              }
            , { id = 4
              , category = "Trust"
              , answer = "The organization works on teamwork and cooperation. It is a community. The organization is designed to ensure everyone is constantly learning, growing, and supporting one another."
              }
            ]
      }
    , { id = 3
      , title = "What does security mean?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Security means policies, procedures, and standards, automated wherever possible using technology. When people talk about security they are talking about the infrastructures in place to protect the organization's information assets."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Security means showing evidence of visibility and control, particularly to external parties. When people talk about security they are talking about passing an audit or meeting a regulatory requirement."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Security means enabling the organization to adapt and compete, not hindering it or saying “no” to everything. When people talk about security they are talking about balancing risks and rewards."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Security means awareness and shared responsibility. When people talk about security they are talking about the need for everyone to be an active participant in protecting the organization."
              }
            ]
      }
    , { id = 4
      , title = "How is information managed and controlled?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Information is seen as a direct source of business value, accounted for, managed, and controlled like any other business asset. Formal rules and policies govern information use and control."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Information is seen as a sensitive and protected resource, entrusted to the organization by others and subject to review and audit. Information use and control must always be documented and verified."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Information is seen as a flexible tool that is the key to agility and adaptability in the organization's environment. Information must be available where and when it is needed by the business, with a minimum of restrictive control."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Information is seen as key to people's productivity, collaboration, and success. Information must be a shared resource, minimally restricted, and available throughout the community to empower people and make them more successful."
              }
            ]
      }
    , { id = 5
      , title = "How are operations managed?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Operations are controlled and predictable, managed according to the same standards throughout the organization."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Operations are visible and verifiable, managed and documented in order to support audits and outside reviews."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Operations are agile and adaptable, managed with minimal bureaucracy and capable of fast adaptation and flexible execution to respond to changes in the environment."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Operations are inclusive and supportive, allowing people to master new skills and responsibilities and to grow within the organization."
              }
            ]
      }
    , { id = 6
      , title = "How is technology managed?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Technology is centrally managed. Standards and formal policies exist to ensure uniform performance internally."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Technology is regularly reviewed. Audits and evaluations exist to ensure the organization meets its obligations to others."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Technology is locally managed. Freedom exists to ensure innovation, adaptation, and results."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Technology is accessible to everyone. Training and support exists to empower users and maximize productivity."
              }
            ]
      }
    , { id = 7
      , title = "How are people managed?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "People must conform to the needs of the organization. They must adhere to policies and standards of behavior. The success of the organization is built on everyone following the rules."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "People must demonstrate that they are doing things correctly. They must ensure the organization meets its obligations. The success of the organization is built on everyone regularly proving that they are doing things properly."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "People must take risks and make quick decisions. They must not wait for someone else to tell them what's best. The success of the organization is built on everyone experimenting and innovating in the face of change."
              }
            , { id = 4
              , category = "Trust"
              , answer = "People must work as a team and support one other. They must know that everyone is doing their part. The success of the organization is built on everyone learning and growing together."
              }
            ]
      }
    , { id = 8
      , title = "How is risk managed?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Risk is best managed by getting rid of deviations in the way things are done. Increased visibility and control reduce uncertainty and negative outcomes. The point is to create a reliable standard."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Risk is best managed by documentation and regular review. Frameworks and evaluations reduce uncertainty and negative outcomes. The point is to keep everyone on their toes."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Risk is best managed by decentralizing authority. Negative outcomes are always balanced by potential opportunities. The point is to let those closest to the decision make the call."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Risk is best managed by sharing information and knowledge. Education and support reduce uncertainty and negative outcomes. The point is to foster a sense of shared responsibility."
              }
            ]
      }
    , { id = 9
      , title = "How is accountability achieved?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Accountability is stable and formalized. People know what to expect and what is expected of them. The same rewards and consequences are found throughout the organization."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Accountability is enabled through review and audit. People know that they will be asked to justify their actions. Rewards and consequences are contingent upon external expectations and judgments."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Accountability is results-driven. People know there are no excuses for failing. Rewards and consequences are a product of successful execution on the organization's business."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Accountability is shared among the group. People know there are no rock stars or scapegoats. Rewards and consequences apply to everyone because everyone is a stakeholder in the organization."
              }
            ]
      }
    , { id = 10
      , title = "How is performance evaluated?"
      , answers =
            [ { id = 1
              , category = "Process"
              , answer = "Performance is evaluated against formal strategies and goals. Success criteria are unambiguous."
              }
            , { id = 2
              , category = "Compliance"
              , answer = "Performance is evaluated against the organization's ability to meet external requirements. Audits define success."
              }
            , { id = 3
              , category = "Autonomy"
              , answer = "Performance is evaluated on the basis of specific decisions and outcomes. Business success is the primary criteria."
              }
            , { id = 4
              , category = "Trust"
              , answer = "Performance is evaluated by the organizational community. Success is defined through shared values, commitment, and mutual respect."
              }
            ]
      }
    ]


type Survey
    = Ipsative IpsativeSurvey
    | Likert LikertSurvey


type alias IpsativeSurvey =
    { metaData : IpsativeMetaData
    , pointsPerQuestion : Int
    , numGroups : Int
    , questions : Zipper IpsativeQuestion
    }


type alias IpsativeMetaData =
    { name : String
    , description : String
    , instructions : String
    , lastUpdated : String
    , createdBy : String
    }


type alias IpsativeQuestion =
    { id : Int
    , title : String
    , pointsLeft : List PointsLeft
    , answers : List IpsativeAnswer
    }


type alias IpsativeAnswer =
    { id : Int
    , answer : String
    , category : String
    , pointsAssigned : List PointsAssigned
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


type alias PointsLeft =
    { group : Int
    , pointsLeft : Int
    }


type alias PointsAssigned =
    { group : Int
    , points : Int
    }


type alias LikertSurvey =
    { metaData : LikertMetaData
    , questions : Zipper LikertQuestion
    }


type alias LikertMetaData =
    { name : String
    , choices : List String
    , instructions : String
    , createdBy : String
    , description : String
    , lastUpdated : String
    }


type alias LikertQuestion =
    { id : Int
    , title : String
    , choices : List String
    , answers : List LikertAnswer
    }


type alias LikertServerQuestion =
    { title : String
    , id : Int
    , answers : List LikertServerAnswer
    }


type alias LikertAnswer =
    { id : Int
    , answer : String
    , selectedChoice : Maybe String
    }


type alias LikertServerAnswer =
    { id : Int
    , answer : String
    }


emptyLikertQuestion : LikertQuestion
emptyLikertQuestion =
    { id = 0
    , title = "UNKNOWN"
    , choices =
        [ "Strongly Disagree"
        , "Disagree"
        , "Neutral"
        , "Agree"
        , "Strongly Agree"
        ]
    , answers = [ emptyLikertAnswer ]
    }


emptyLikertAnswer : LikertAnswer
emptyLikertAnswer =
    { id = 0
    , answer = ""
    , selectedChoice = Nothing
    }


emptyIpsativeQuestion : IpsativeQuestion
emptyIpsativeQuestion =
    { id = 0
    , title = "UNKNOWN"
    , pointsLeft = [ emptyPointsLeft ]
    , answers =
        [ emptyAnswer
        ]
    }


emptyAnswer : IpsativeAnswer
emptyAnswer =
    { id = 0
    , answer = "EMPTY QUESTION"
    , category = "EMPTY CATEGORY"
    , pointsAssigned = [ emptyPointsAssigned ]
    }


emptyPointsLeft : PointsLeft
emptyPointsLeft =
    { group = 1
    , pointsLeft = 10
    }


emptyPointsAssigned : PointsAssigned
emptyPointsAssigned =
    { group = 1
    , points = 1
    }


createIpsativeSurvey : Int -> Int -> IpsativeMetaData -> List IpsativeServerQuestion -> Survey
createIpsativeSurvey pointsPerQuestion numGroups metaData questions =
    Ipsative
        { metaData = metaData
        , pointsPerQuestion = pointsPerQuestion
        , numGroups = numGroups
        , questions =
            Zipper.fromList (ipsativeQuestionsMapped questions numGroups pointsPerQuestion)
                |> Zipper.withDefault emptyIpsativeQuestion
        }


createLikertSurvey : LikertMetaData -> List LikertServerQuestion -> Survey
createLikertSurvey metaData serverQuestions =
    Likert
        { metaData = metaData
        , questions = Zipper.fromList (likertQuestionsMapped serverQuestions metaData) |> Zipper.withDefault emptyLikertQuestion
        }


likertQuestionsMapped : List LikertServerQuestion -> LikertMetaData -> List LikertQuestion
likertQuestionsMapped serverQuestions metaData =
    List.map
        (\serverQuestion ->
            { id = serverQuestion.id
            , title = serverQuestion.title
            , answers = likertAnswersMapped serverQuestion.answers
            , choices = metaData.choices
            }
        )
        serverQuestions


likertAnswersMapped : List LikertServerAnswer -> List LikertAnswer
likertAnswersMapped answers =
    List.map
        (\answer ->
            { id = answer.id
            , answer = answer.answer
            , selectedChoice = Nothing
            }
        )
        answers


ipsativeQuestionsMapped : List IpsativeServerQuestion -> Int -> Int -> List IpsativeQuestion
ipsativeQuestionsMapped serverQuestions numGroups numPointsPerQuestion =
    List.map
        (\x ->
            { id = x.id
            , title = x.title
            , pointsLeft = createPointsLeft numGroups numPointsPerQuestion
            , answers = createAnswers x.answers numGroups
            }
        )
        serverQuestions


createPointsLeft : Int -> Int -> List PointsLeft
createPointsLeft numGroups numPointsPerQuestion =
    List.map
        (\x ->
            { group = x
            , pointsLeft = numPointsPerQuestion
            }
        )
        (List.range 1 numGroups)


createAnswers : List IpsativeServerAnswer -> Int -> List IpsativeAnswer
createAnswers serverAnswers numGroups =
    List.map
        (\x ->
            { id = x.id
            , answer = x.answer
            , category = x.category
            , pointsAssigned = createPointsAssigned numGroups
            }
        )
        serverAnswers


createPointsAssigned : Int -> List PointsAssigned
createPointsAssigned numGroups =
    List.map
        (\x ->
            { group = x
            , points = 0
            }
        )
        (List.range 1 numGroups)
