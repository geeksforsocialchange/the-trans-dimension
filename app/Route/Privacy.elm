module Route.Privacy exposing (Model, Msg, RouteParams, route, Data, ActionData)

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
import Theme.PageTemplate
import Theme.TextHeavyPage
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
    { title : String
    , subtitle : String
    , body : List Markdown.Block.Block
    }


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.File.bodyWithFrontmatter
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
        "theme/content/privacy.md"
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = PrivacyTitle
        , description = PrivacyMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app _ =
    { title = t (PageMetaTitle (t PrivacyTitle))
    , body =
        [ Theme.TextHeavyPage.view
            app.data.title
            app.data.subtitle
            app.data.body
        ]
    }
