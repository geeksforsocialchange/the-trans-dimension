module Theme.PageHeaderTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Html.Attributes
import Messages exposing (Msg)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyled)
import Theme.PageHeader
import UrlPath


header : Query.Single Msg
header =
    Theme.PageHeader.viewPageHeader
        { path = UrlPath.fromString "/events", route = Nothing }
        { showMobileMenu = False }
        |> queryFromStyled


suite : Test
suite =
    describe "Page header"
        [ test "The logo links to the home page" <|
            \_ ->
                header
                    |> Query.find [ Selector.tag "h1" ]
                    |> Query.find [ Selector.tag "a" ]
                    |> Query.has [ Selector.attribute (Html.Attributes.href "/") ]
        , test "The logo link has an accessible name" <|
            \_ ->
                -- Assert on the full title + strapline, not just the site
                -- title. The logo SVG carries its own <title> reading "The
                -- Trans Dimension", but it sits inside the aria-hidden span
                -- and so contributes nothing to the link's accessible name.
                -- Matching the shorter string would pass even if the
                -- screen-reader-only span were deleted.
                header
                    |> Query.find [ Selector.tag "h1" ]
                    |> Query.find [ Selector.tag "a" ]
                    |> Query.has
                        [ Selector.text (t SiteTitle ++ ", " ++ t SiteStrapline) ]
        , test "The logo SVG is hidden from assistive tech" <|
            \_ ->
                -- aria-hidden sits on the span wrapping the SVG, so assert
                -- the hidden element is the one containing it.
                header
                    |> Query.find [ Selector.tag "h1" ]
                    |> Query.find
                        [ Selector.attribute (Html.Attributes.attribute "aria-hidden" "true") ]
                    |> Query.has [ Selector.tag "svg" ]
        ]
