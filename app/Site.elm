module Site exposing (config)

import BackendTask exposing (BackendTask)
import Constants exposing (canonicalUrl)
import FatalError exposing (FatalError)
import Head
import MimeType
import Pages.Manifest as Manifest
import Pages.Url
import Route
import SiteConfig exposing (SiteConfig)
import Skin.Global
import UrlPath


config : SiteConfig
config =
    { canonicalUrl = canonicalUrl
    , head = head
    }


head : BackendTask FatalError (List Head.Tag)
head =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.appleTouchIcon (Just 180) (pathFromString "/favicons/apple-touch-icon.png")
    , Head.metaName "msapplication-TileColor" (Head.raw Skin.Global.colorSecondaryHexString)
    , Head.metaName "theme-color" (Head.raw Skin.Global.colorSecondaryHexString)
    ]
        ++ icons
            [ ( 32, "favicon-32x32.png" )
            , ( 16, "favicon-16x16.png" )
            ]
        |> BackendTask.succeed


manifest : Manifest.Config
manifest =
    Manifest.init
        { name = "The Trans Dimension"
        , description = "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place."
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ { src = pathFromString "/favicons/android-chrome-192x192.png"
              , sizes = [ ( 192, 192 ) ]
              , mimeType = Just MimeType.Png
              , purposes = []
              }
            , { src = pathFromString "/favicons/android-chrome-512x512.png"
              , sizes = [ ( 512, 512 ) ]
              , mimeType = Just MimeType.Png
              , purposes = []
              }
            ]
        }
        |> Manifest.withBackgroundColor Skin.Global.colorPrimaryRgb
        |> Manifest.withThemeColor Skin.Global.colorSecondaryRgb


pathFromString srcString =
    Pages.Url.fromPath <| UrlPath.fromString srcString


icons : List ( Int, String ) -> List Head.Tag
icons iconConfigList =
    List.map
        (\( size, src ) ->
            Head.icon [ ( size, size ) ]
                MimeType.Png
                (("/favicons/" ++ src)
                    |> pathFromString
                )
        )
        iconConfigList
