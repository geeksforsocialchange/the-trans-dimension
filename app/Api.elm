module Api exposing (routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import Constants exposing (canonicalUrl)
import FatalError exposing (FatalError)
import Html exposing (Html)
import Route exposing (Route)


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ sitemap getStaticRoutes
    , robots
    ]


{-| Generates /robots.txt. Without this, Cloudflare Pages serves the SPA fallback
HTML at this path with a 200, which crawlers parse as a malformed robots file.
-}
robots : ApiRoute ApiRoute.Response
robots =
    ApiRoute.succeed
        (BackendTask.succeed robotsTxt)
        |> ApiRoute.literal "robots.txt"
        |> ApiRoute.single


robotsTxt : String
robotsTxt =
    String.join "\n"
        [ "User-agent: *"
        , "Allow: /"
        , ""
        , "Sitemap: " ++ origin ++ "/sitemap.xml"
        , ""
        ]


{-| Generates /sitemap.xml from every pre-rendered route, including the dynamic
event, news and partner pages. Site.elm points crawlers here via Head.sitemapLink.
-}
sitemap : BackendTask FatalError (List Route) -> ApiRoute ApiRoute.Response
sitemap getStaticRoutes =
    ApiRoute.succeed
        (getStaticRoutes |> BackendTask.map sitemapXml)
        |> ApiRoute.literal "sitemap.xml"
        |> ApiRoute.single


sitemapXml : List Route -> String
sitemapXml allRoutes =
    String.concat
        [ "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        , "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n"
        , allRoutes |> List.map urlEntry |> String.concat
        , "</urlset>\n"
        ]


urlEntry : Route -> String
urlEntry route =
    "  <url><loc>" ++ escapeXml (origin ++ Route.toString route) ++ "</loc></url>\n"


{-| The canonical origin without a trailing slash, so it can be joined directly
onto the absolute paths that Route.toString produces.
-}
origin : String
origin =
    if String.endsWith "/" canonicalUrl then
        String.dropRight 1 canonicalUrl

    else
        canonicalUrl


escapeXml : String -> String
escapeXml =
    String.replace "&" "&amp;"
        >> String.replace "<" "&lt;"
        >> String.replace ">" "&gt;"
        >> String.replace "\"" "&quot;"
        >> String.replace "'" "&apos;"
