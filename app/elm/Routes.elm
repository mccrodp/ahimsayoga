module Routes exposing (Sitemap(..), parsePath, navigateTo, toString)

import Navigation exposing (Location)
import Route exposing (..)


type Sitemap
    = HomeR
    | ScheduleR
    | AboutR
    | ContactR
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


contactR : Route Sitemap
contactR =
    ContactR := static "contact"


sitemap : Router Sitemap
sitemap =
    router [ homeR, scheduleR, aboutR, contactR ]


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

        ContactR ->
            reverse contactR []

        NotFoundR ->
            Debug.crash "cannot render NotFound"


parsePath : Location -> Sitemap
parsePath =
    .pathname >> match


navigateTo : Sitemap -> Cmd msg
navigateTo =
    toString >> Navigation.newUrl
