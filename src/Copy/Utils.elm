module Copy.Utils exposing (isValidUrl, urlToDisplay)

import Url


urlRecombiner : Maybe Url.Url -> String
urlRecombiner urlRecord =
    case urlRecord of
        Just url ->
            url.host ++ url.path ++ Maybe.withDefault "" url.query ++ Maybe.withDefault "" url.fragment

        Nothing ->
            ""


chompTrailingUrlSlash : String -> String
chompTrailingUrlSlash urlString =
    if String.endsWith "/" urlString then
        String.dropRight 1 urlString

    else
        urlString


urlToDisplay : String -> String
urlToDisplay url =
    Url.fromString url |> urlRecombiner |> chompTrailingUrlSlash


isValidUrl : String -> Bool
isValidUrl urlString =
    case Url.fromString urlString of
        Just url ->
            url.protocol == Url.Https

        Nothing ->
            False
