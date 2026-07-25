module Helpers.TransRoutes exposing (Route(..), stringToSlug, toAbsoluteUrl, toPageTitle)

import Copy.Keys exposing (Key(..), Prefix(..))
import Copy.Text exposing (t)
import Slug
import UrlPath


type Route
    = Home
    | About
    | Event String
    | Events
    | JoinUs
    | NewsItem String
    | News
    | Donate
    | Partner String
    | Partners
    | Privacy


toPageTitle : Route -> String
toPageTitle route =
    case route of
        Home ->
            t IndexTitle

        About ->
            t AboutTitle

        Events ->
            t EventsTitle

        Event name ->
            t (EventTitle Prefixed name)

        JoinUs ->
            t JoinUsTitle

        NewsItem title ->
            t (NewsItemTitle Prefixed title)

        News ->
            t NewsTitle

        Donate ->
            t HeaderAskButton

        Partner name ->
            t (PartnerTitle name)

        Partners ->
            t PartnersTitle

        Privacy ->
            t PrivacyTitle


toPath : Route -> UrlPath.UrlPath
toPath route =
    case route of
        Home ->
            UrlPath.fromString "/"

        About ->
            UrlPath.fromString "about"

        Events ->
            UrlPath.fromString "events"

        Event slug ->
            UrlPath.join [ "events", slug ]

        JoinUs ->
            UrlPath.fromString "join-us"

        NewsItem slug ->
            UrlPath.join [ "news", slug ]

        News ->
            UrlPath.fromString "news"

        Donate ->
            UrlPath.fromString "donate"

        Partner slug ->
            UrlPath.join [ "partners", slug ]

        Partners ->
            UrlPath.fromString "partners"

        Privacy ->
            UrlPath.fromString "privacy"


toAbsoluteUrl : Route -> String
toAbsoluteUrl route =
    UrlPath.toAbsolute (toPath route)


stringToSlug : String -> String
stringToSlug stringToSluggify =
    -- Currently nothing done to make sure these are unique
    Slug.generate stringToSluggify
        |> stringFromMaybeSlug


stringFromMaybeSlug : Maybe Slug.Slug -> String
stringFromMaybeSlug maybeSlug =
    case maybeSlug of
        Just slug ->
            Slug.toString slug

        Nothing ->
            "unsluggable"
