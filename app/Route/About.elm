module Route.About exposing
    ( Model, Msg, RouteParams, route, Data, ActionData
    , Maker
    )

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import BackendTask.File
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import FatalError
import Head
import Json.Decode as Decode
import Markdown.Block
import PagesMsg
import RouteBuilder
import Shared
import Theme.Page.About
import Theme.PageTemplate
import Theme.TransMarkdown
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


route : RouteBuilder.StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildNoState
            { view = view }


type alias Data =
    { main : Theme.PageTemplate.SectionWithTextHeader
    , accessibility : Theme.PageTemplate.SectionWithTextHeader
    , makers : List Maker
    , placecal : Theme.PageTemplate.SectionWithImageHeader
    }


type alias Maker =
    { name : String
    , url : String
    , logo : String
    , body : List Markdown.Block.Block
    }


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.map4
        (\main accessibility makers placecal ->
            { main = main
            , accessibility = accessibility
            , makers = makers
            , placecal = placecal
            }
        )
        (BackendTask.File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map3
                    (\title subtitle markdownBlocks ->
                        { title = title
                        , subtitle = subtitle
                        , body = markdownBlocks
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "subtitle" Decode.string)
                    (markdownString
                        |> Theme.TransMarkdown.markdownToBlocks
                        |> Theme.TransMarkdown.fromResult
                    )
            )
            "theme/content/about/main.md"
        )
        (BackendTask.File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map3
                    (\title subtitle markdownBlocks ->
                        { title = title
                        , subtitle = subtitle
                        , body = markdownBlocks
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "subtitle" Decode.string)
                    (markdownString
                        |> Theme.TransMarkdown.markdownToBlocks
                        |> Theme.TransMarkdown.fromResult
                    )
            )
            "theme/content/about/accessibility.md"
        )
        (BackendTask.map2
            (\gi gfsc ->
                [ gi, gfsc ]
            )
            (BackendTask.File.bodyWithFrontmatter
                (\markdownString ->
                    Decode.map4
                        (\name logo url markdownBlocks ->
                            { name = name
                            , logo = logo
                            , url = url
                            , body = markdownBlocks
                            }
                        )
                        (Decode.field "name" Decode.string)
                        (Decode.field "logo" Decode.string)
                        (Decode.field "url" Decode.string)
                        (markdownString
                            |> Theme.TransMarkdown.markdownToBlocks
                            |> Theme.TransMarkdown.fromResult
                        )
                )
                "theme/content/about/makers/gfsc.md"
            )
            (BackendTask.File.bodyWithFrontmatter
                (\markdownString ->
                    Decode.map4
                        (\name logo url markdownBlocks ->
                            { name = name
                            , logo = logo
                            , url = url
                            , body = markdownBlocks
                            }
                        )
                        (Decode.field "name" Decode.string)
                        (Decode.field "logo" Decode.string)
                        (Decode.field "url" Decode.string)
                        (markdownString
                            |> Theme.TransMarkdown.markdownToBlocks
                            |> Theme.TransMarkdown.fromResult
                        )
                )
                "theme/content/about/makers/partnership.md"
            )
        )
        (BackendTask.File.bodyWithFrontmatter
            (\markdownString ->
                Decode.map4
                    (\title subtitleimg subtitleimgalt markdownBlocks ->
                        { title = title
                        , subtitleimg = subtitleimg
                        , subtitleimgalt = subtitleimgalt
                        , body = markdownBlocks
                        }
                    )
                    (Decode.field "title" Decode.string)
                    (Decode.field "subtitleimg" Decode.string)
                    (Decode.field "subtitleimgalt" Decode.string)
                    (markdownString
                        |> Theme.TransMarkdown.markdownToBlocks
                        |> Theme.TransMarkdown.fromResult
                    )
            )
            "theme/content/about/placecal.md"
        )
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = AboutTitle
        , description = AboutMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app _ =
    { title = t (PageMetaTitle (t AboutTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "about"
            , title = app.data.main.title
            , bigText = { text = app.data.main.subtitle, node = "p" }
            , smallText = Nothing
            , innerContent = Just (Theme.Page.About.viewIntro app.data.main.body)
            , outerContent =
                Just
                    (Theme.Page.About.viewSections
                        { accessibilityData = app.data.accessibility
                        , makersData = app.data.makers
                        , aboutPlaceCalData = app.data.placecal
                        }
                    )
            }
        ]
    }
