module Route.Index exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Articles
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Effect
import FatalError
import Head
import Html.Styled
import Messages exposing (Msg(..))
import PagesMsg
import RouteBuilder
import Shared
import Theme.Page.Events exposing (Msg(..))
import Theme.Page.Index
import Theme.PageTemplate
import Theme.RegionSelector exposing (Msg(..))
import Time
import UrlPath
import View


type alias Model =
    { filterByRegion : Int
    , nowTime : Time.Posix
    }


type alias Msg =
    Theme.Page.Events.Msg


type alias RouteParams =
    {}


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app shared =
    ( { filterByRegion = Maybe.withDefault 0 shared.filterParam
      , nowTime = app.sharedData.time
      }
    , Effect.none
    )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg, Maybe Shared.Msg )
update app _ msg model =
    case msg of
        RegionSelectorMsg submsg ->
            case submsg of
                ClickedSelector tagId ->
                    ( { model
                        | filterByRegion = tagId
                      }
                    , Effect.none
                    , Just (SetRegion tagId)
                    )

        _ ->
            ( model, Effect.none, Nothing )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildWithSharedState
            { init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


type alias Data =
    { events : List Data.PlaceCal.Events.Event
    }


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.map Data
        (BackendTask.map (\eventsData -> eventsData.allEvents) Data.PlaceCal.Events.eventsData)
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = SiteTitle
        , description = IndexMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app shared model =
    { title = t SiteTitle
    , body =
        let
            sharedData =
                app.sharedData

            sharedDataWithEvents =
                { events = app.data.events
                , partners = sharedData.partners
                , articles = sharedData.articles
                , time = sharedData.time
                , timezone = shared.timezone
                }
        in
        [ Theme.Page.Index.view sharedDataWithEvents model
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
