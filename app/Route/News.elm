module Route.News exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Articles
import FatalError
import Head
import PagesMsg
import RouteBuilder
import Shared
import Theme.Page.News
import Theme.PageTemplate
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
    ()


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed ()


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = NewsTitle
        , description = NewsDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app _ =
    { title = t (PageMetaTitle (t NewsTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "secondary"
            , title = t NewsTitle
            , bigText = { text = t NewsDescription, node = "h3" }
            , smallText = Nothing
            , innerContent = Nothing
            , outerContent =
                Just
                    (Theme.Page.News.viewNewsList
                        (Data.PlaceCal.Articles.replacePartnerIdWithName app.sharedData.articles app.sharedData.partners)
                    )
            }
        ]
    }
