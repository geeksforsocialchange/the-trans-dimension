module Route.Index exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import BackendTask.Time
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
import Set
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
    BackendTask.map2
        (\eventsData buildTime -> Data (featuredEvents buildTime eventsData.allEvents))
        Data.PlaceCal.Events.eventsData
        BackendTask.Time.now
        |> BackendTask.allowFatal


{-| The homepage renders at most 8 events, but the region selector filters
client side, so the page needs the earliest upcoming events for every region
rather than only the ones visible on load.

It used to ship the whole event list — around 1,800 of them — which is what
made the homepage's inline data payload 2.25 MB. See #547.

The event query starts a month before the build, so past events have to be
dropped here: taking the earliest events without doing so selects ones the
client then filters straight back out, leaving the page empty.

-}
featuredEvents : Time.Posix -> List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Events.Event
featuredEvents buildTime allEvents =
    let
        upcoming : List Data.PlaceCal.Events.Event
        upcoming =
            Data.PlaceCal.Events.afterDate allEvents buildTime
    in
    (0 :: Data.PlaceCal.Partners.partnershipTagIdList)
        |> List.concatMap
            (\regionId ->
                Data.PlaceCal.Events.eventsFromRegionId upcoming regionId
                    |> List.sortBy startMillis
                    |> List.take featuredEventsPerRegion
            )
        |> dedupeById
        |> List.sortBy startMillis


{-| Comfortably more than the 8 the page shows. Events that start between a
build and a visit are filtered out client side, so a margin keeps the list
full between hourly rebuilds.
-}
featuredEventsPerRegion : Int
featuredEventsPerRegion =
    24


startMillis : Data.PlaceCal.Events.Event -> Int
startMillis event =
    Time.posixToMillis event.startDatetime


dedupeById : List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Events.Event
dedupeById events =
    -- Region 0 is everywhere, so its events also appear under their own region.
    List.foldl
        (\event ( seen, kept ) ->
            if Set.member event.id seen then
                ( seen, kept )

            else
                ( Set.insert event.id seen, event :: kept )
        )
        ( Set.empty, [] )
        events
        |> Tuple.second


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
                , articles =
                    Data.PlaceCal.Articles.replacePartnerIdWithName
                        sharedData.articles
                        sharedData.partners
                , time = sharedData.time
                , timezone = shared.timezone
                }
        in
        [ Theme.Page.Index.view sharedDataWithEvents model
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }
