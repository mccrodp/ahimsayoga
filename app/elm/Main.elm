module Main exposing (main)

import Html as H exposing (Html, text, div)
import Html.Attributes as A exposing (class)
import Html.Events as E
import Json.Decode as JD
import Navigation exposing (Location)
import Routes exposing (Sitemap(..))
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Bootstrap.Alert as Alert


-- Main
-- ----


main : Program Never Model Msg
main =
    Navigation.program parseRoute
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model
-- ------


type alias Model =
    { route : Sitemap
    , navbarState : Navbar.State
    , ready : Bool
    , error : Maybe String
    }


type Msg
    = RouteChanged Sitemap
    | RouteTo Sitemap
    | NavbarMsg Navbar.State


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        initialModel =
            { route = Routes.parsePath location
            , navbarState = navbarState
            , ready = False
            , error = Nothing
            }

        ( model, routeCmd ) =
            handleRoute initialModel.route initialModel
    in
        ( model, Cmd.batch [ navbarCmd, routeCmd ] )



-- Subscriptions
-- -------------


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg



-- Update
-- ------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged route ->
            handleRoute route model

        RouteTo route ->
            model ! [ Routes.navigateTo route ]

        NavbarMsg state ->
            { model | navbarState = state } ! []


parseRoute : Location -> Msg
parseRoute =
    Routes.parsePath >> RouteChanged


handleRoute : Sitemap -> Model -> ( Model, Cmd Msg )
handleRoute route ({ ready } as model) =
    let
        newModel =
            { model | route = route }
    in
        case route of
            _ ->
                newModel ! []



-- View
-- ----


view : Model -> Html Msg
view model =
    Grid.container []
        [ header
        , navigation model
        , div [ class "mt-3" ] [ content model ]
        ]


header : Html Msg
header =
    div []
        [ H.h1 [ class "brand" ]
            [ H.text "Ahimsa Yoga"
            ]
        , H.div []
            [ div [ class "address-bar" ]
                [ text ("Komatsu | Ishikawa, Japan") ]
            ]
        ]


navigation : Model -> Html Msg
navigation model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.items
            [ Navbar.itemLink (linkAttrs HomeR) [ text "Home" ]
            , Navbar.itemLink (linkAttrs ScheduleR) [ text "Schedule" ]
            , Navbar.itemLink (linkAttrs AboutR) [ text "About" ]
            ]
        |> Navbar.view model.navbarState


content : Model -> Html Msg
content ({ route } as model) =
    case model.route of
        HomeR ->
            home

        ScheduleR ->
            schedule

        AboutR ->
            about

        NotFoundR ->
            notFound


notFound : Html Msg
notFound =
    Alert.danger [ text "Page not found" ]


home : Html Msg
home =
    div [ class "box" ]
        [ H.h3 [ class "mb-2" ] [ text "Home" ]
        , H.p []
            [ text "Click to fetch post #123 which doesn't exist" ]
        ]


about : Html Msg
about =
    div [ class "box" ] [ H.p [] [ text "About page..." ] ]


schedule : Html Msg
schedule =
    div [ class "box" ] [ H.p [] [ text "Schedule page..." ] ]


loading : Html Msg
loading =
    Alert.warning [ text "Loading ..." ]


linkAttrs : Sitemap -> List (H.Attribute Msg)
linkAttrs route =
    let
        onClickRoute =
            E.onWithOptions
                "click"
                { preventDefault = True
                , stopPropagation = True
                }
                (JD.succeed <| RouteTo route)
    in
        [ A.href <| Routes.toString route
        , onClickRoute
        ]
