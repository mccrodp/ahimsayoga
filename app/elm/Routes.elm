module Routes exposing (Sitemap(..), parsePath, navigateTo, toString)

import Navigation exposing (Location)
import Route exposing (..)


type Sitemap
    = HomeR
    | ScheduleR
    | AboutR
    | NotFoundR


homeR : Route Sitemap
homeR =
    HomeR := static ""


scheduleR : Route Sitemap
scheduleR =
    ScheduleR := static "schedule"


aboutR : Route Sitemap
aboutR =
    AboutR := static "about"


sitemap : Router Sitemap
sitemap =
    router [ homeR, scheduleR, aboutR ]


match : String -> Sitemap
match =
    Route.match sitemap
        >> Maybe.withDefault NotFoundR


toString : Sitemap -> String
toString r =
    case r of
        HomeR ->
            reverse homeR []

        ScheduleR ->
            reverse scheduleR []

        AboutR ->
            reverse aboutR []

        NotFoundR ->
            Debug.crash "cannot render NotFound"


parsePath : Location -> Sitemap
parsePath =
    .pathname >> match


navigateTo : Sitemap -> Cmd msg
navigateTo =
    toString >> Navigation.newUrl
