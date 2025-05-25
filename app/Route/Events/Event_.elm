module Route.Events.Event_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..), Prefix(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import FatalError
import Head
import Helpers.TransDate as TransDate
import PagesMsg
import RouteBuilder
import Shared
import Theme.Page.Event
import Theme.PageTemplate
import View


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { event : String }


route : RouteBuilder.StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { data = data, pages = pages, head = head }
        |> RouteBuilder.buildNoState
            { view = view }


type alias Data =
    Data.PlaceCal.Events.Event


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : RouteParams -> BackendTask.BackendTask FatalError.FatalError Data
data { event } =
    Data.PlaceCal.Events.singleEventData
        event
        |> BackendTask.allowFatal


pages : BackendTask.BackendTask FatalError.FatalError (List RouteParams)
pages =
    BackendTask.map
        (\eventData ->
            eventData.allEvents
                |> List.map (\event -> { event = event.id })
        )
        Data.PlaceCal.Events.eventsData
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    let
        event =
            app.data
                |> eventWithPartner app.sharedData.partners
    in
    Theme.PageTemplate.pageMetaTags
        { title = EventTitle NoPrefix (eventMetaTagTitle event)
        , description = EventMetaDescription event.description
        , imageSrc = Nothing
        }


eventMetaTagTitle : Data.PlaceCal.Events.Event -> String
eventMetaTagTitle event =
    let
        eventDay =
            TransDate.humanDayDateMonthFromPosix event.startDatetime

        ( eventHourStart, eventHourEnd ) =
            ( TransDate.humanTimeFromPosix event.startDatetime, TransDate.humanTimeFromPosix event.endDatetime )

        partnerName =
            event.partner.name |> Maybe.withDefault ""
    in
    event.name ++ ", " ++ eventDay ++ ", " ++ eventHourStart ++ "-" ++ eventHourEnd ++ " @ " ++ partnerName


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app _ =
    let
        event : Data.PlaceCal.Events.Event
        event =
            app.data
                |> eventWithPartner app.sharedData.partners
    in
    { title = t (PageMetaTitle event.name)
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "secondary"
            , title = t EventsTitle
            , bigText = { text = event.name, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (Theme.Page.Event.viewEventInfo event)
            , outerContent = Just (Theme.Page.Event.viewButtons event)
            }
        ]
    }


eventWithPartner : List Data.PlaceCal.Partners.Partner -> Data.PlaceCal.Events.Event -> Data.PlaceCal.Events.Event
eventWithPartner partners event =
    { event | partner = Data.PlaceCal.Events.eventPartnerFromId partners event.partner.id }
