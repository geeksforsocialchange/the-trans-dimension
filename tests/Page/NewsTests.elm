module Page.NewsTests exposing (..)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Articles
import Expect
import Html
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestFixtures
import TestUtils exposing (queryFromStyled)
import Theme.Page.News


viewNewsListHtml : List Data.PlaceCal.Articles.Article -> Query.Single msg
viewNewsListHtml newsList =
    queryFromStyled
        (Theme.Page.News.viewNewsList newsList)


suite : Test
suite =
    describe "News page"
        [ test "Contains a list of news" <|
            \_ ->
                viewNewsListHtml TestFixtures.news
                    |> Query.findAll [ Selector.tag "ul" ]
                    |> Query.first
                    |> Query.children [ Selector.tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "Contains expected news content" <|
            \_ ->
                viewNewsListHtml TestFixtures.news
                    |> Query.contains
                        [ Html.text "Some news"
                        , Html.text "21st February 2022"
                        , Html.text "Nunc augue erat, ullamcorper et nunc nec, placerat rhoncus nulla. Quisque nec sollicitudin turpis. Etiam risus dolor, ullamcorper vitae consectetur..."
                        , Html.text "Article Author1"
                        , Html.text "Article Author1, Article Author2"
                        , Html.text "Big news!"
                        , Html.text "22nd February 2022"
                        ]
        , test "Does not contain list if there is no news" <|
            \_ ->
                viewNewsListHtml []
                    |> Query.findAll [ Selector.tag "p" ]
                    |> Query.index 0
                    |> Query.contains [ Html.text (t NewsEmptyText) ]
        ]
