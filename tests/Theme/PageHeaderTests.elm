module Theme.PageHeaderTests exposing (..)

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
                header
                    |> Query.find [ Selector.tag "h1" ]
                    |> Query.find [ Selector.tag "a" ]
                    |> Query.has [ Selector.text "The Trans Dimension" ]
        ]
