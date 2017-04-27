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
import Bootstrap.Grid.Col as Col


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
    div []
        [ header
        , navigation model
        , Grid.container [] [ content model ]
        , footer
        ]


header : Html Msg
header =
    div []
        [ H.h1 [ class "brand" ]
            [ H.text "Ahimsa Yoga"
            ]
        , H.div []
            [ div [ class "address-bar" ]
                [ text ("Shivam Yoga Center - Ishikawa, Japan") ]
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
            , Navbar.itemLink (linkAttrs ContactR) [ text "Contact" ]
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

        ContactR ->
            contact

        NotFoundR ->
            notFound


footer : Html Msg
footer =
    H.footer []
        [ H.div [ class "container" ]
            [ Grid.simpleRow
                [ Grid.col
                    [ Col.lg12, Col.attrs ([ A.class "text-center" ]) ]
                    [ H.p [] [ text "Copyright © Your Website 2017" ] ]
                ]
            ]
        ]


notFound : Html Msg
notFound =
    Alert.danger [ text "Page not found" ]


home : Html Msg
home =
    div []
        [ Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.h2 [ class "brand-before" ]
                    [ H.small []
                        [ text "Welcome To"
                        ]
                    ]
                , H.h1 [ class "brand-name" ]
                    [ text "Ahimsa Yoga" ]
                , H.hr [ class "tagline-divider" ] []
                , H.h2 []
                    [ H.small []
                        [ text "By Start Bootstrap"
                        ]
                    ]
                ]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.hr [] []
                , H.h2 [ class "intro-text text-center" ]
                    [ text "BUILD A WEBSITE WORTH VISITING"
                    ]
                , H.hr [] []
                , H.div []
                    [ H.p []
                        [ text "Loads of text..."
                        ]
                    ]
                ]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.hr [] []
                , H.h2 [ class "intro-text text-center" ]
                    [ text "BEAUTIFUL BOXES TO SHOWCASE YOUR CONTENT"
                    ]
                , H.hr [] []
                , H.div []
                    [ H.p []
                        [ text "Loads more text..."
                        ]
                    ]
                ]
            ]
        ]


schedule : Html Msg
schedule =
    div []
        [ Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.h1 [ class "intro-text text-center" ]
                    [ text "CLASS SCHEDULE" ]
                , H.hr [] []
                , H.div []
                    [ text "Schedule info..."
                    ]
                ]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.hr [] []
                , H.h2 [ class "intro-text text-center" ]
                    [ text "CLASS INFO"
                    ]
                , H.hr [] []
                , H.div []
                    [ H.p []
                        [ text "Loads of class info..."
                        ]
                    ]
                ]
            ]
        ]


about : Html Msg
about =
    div []
        [ Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.h1 [ class "intro-text text-center" ]
                    [ text "ABOUT US" ]
                , H.hr [] []
                , H.div []
                    [ text "About us..."
                    ]
                ]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Col.lg12, Col.attrs ([ A.class "box text-center" ]) ]
                [ H.hr [] []
                , H.h2 [ class "intro-text text-center" ]
                    [ text "MORE INFO"
                    ]
                , H.hr [] []
                , H.div []
                    [ H.p []
                        [ text "Loads of about info..."
                        ]
                    ]
                ]
            ]
        ]


contact : Html Msg
contact =
    div [ class "box" ]
        [ H.hr [] []
        , H.h2 [ class "intro-text text-center" ] [ text "Contact" ]
        , H.hr [] []
        , H.p [] [ text "Contact page text" ]
        ]


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
