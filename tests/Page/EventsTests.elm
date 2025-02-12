module Page.EventsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Expect
import Messages exposing (Msg(..))
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures
import TestUtils exposing (queryFromStyled)
import Theme.Page.Events as EventsPage
import Theme.Paginator exposing (Filter(..))
import Theme.RegionSelector exposing (Msg(..))
import Time


viewEventsPageHtml filter =
    queryFromStyled
        (EventsPage.viewEvents TestFixtures.events { filterByDate = Past, filterByRegion = filter, nowTime = Time.millisToPosix 1645466500000 })


suite : Test
suite =
    describe "Test event filter by region"
        [ test "Should trigger ClickedSelector Msg" <|
            \_ ->
                viewEventsPageHtml 0
                    |> Query.findAll [ Selector.tag "button", Selector.containing [ Selector.text "London" ] ]
                    |> Query.first
                    |> Event.simulate Event.click
                    |> Event.expect (EventsPage.RegionSelectorMsg (ClickedSelector 3))
        , test "Should list all events 'everywhere' is selected " <|
            \_ ->
                viewEventsPageHtml 0
                    |> Query.findAll [ Selector.tag "li", Selector.containing [ Selector.tag "article" ] ]
                    |> Query.count (Expect.equal 2)
        , test "Should list only events in London when 'London' is selected" <|
            \_ ->
                viewEventsPageHtml 3
                    |> Query.findAll [ Selector.tag "li", Selector.containing [ Selector.tag "article" ] ]
                    |> Expect.all
                        [ Query.count (Expect.equal 1)
                        , Query.first >> Query.hasNot [ Selector.tag "h4", Selector.containing [ Selector.text "Event 1 name" ] ]
                        , Query.first >> Query.has [ Selector.tag "h4", Selector.containing [ Selector.text "Event 2 name" ] ]
                        ]
        , test "Should list only events in Manchester when 'Manchester' is selected" <|
            \_ ->
                viewEventsPageHtml 30
                    |> Query.findAll [ Selector.tag "li", Selector.containing [ Selector.tag "article" ] ]
                    |> Expect.all
                        [ Query.count (Expect.equal 1)
                        , Query.first >> Query.hasNot [ Selector.tag "h4", Selector.containing [ Selector.text "Event 2 name" ] ]
                        , Query.first >> Query.has [ Selector.tag "h4", Selector.containing [ Selector.text "Event 1 name" ] ]
                        ]
        ]
