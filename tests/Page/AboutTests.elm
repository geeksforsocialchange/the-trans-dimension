module Page.AboutTests exposing (..)

import Expect
import Html
import Markdown.Block
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (queryFromStyled)
import Theme.Page.About
import Theme.PageTemplate
import Theme.TransMarkdown


introMarkdown : List Markdown.Block.Block
introMarkdown =
    "# About us"
        |> Theme.TransMarkdown.markdownToBlocks
        |> fromResult


fromResult : Result String (List Markdown.Block.Block) -> List Markdown.Block.Block
fromResult markdownResult =
    case markdownResult of
        Ok markdownBlocks ->
            markdownBlocks

        Err _ ->
            []


sectionData : { accessibilityData : Theme.PageTemplate.SectionWithTextHeader, makersData : List { name : String, url : String, logo : String, body : List Markdown.Block.Block }, aboutPlaceCalData : Theme.PageTemplate.SectionWithImageHeader }
sectionData =
    { accessibilityData =
        { title = "Accessibility"
        , subtitle = "Accessibility is good for everyone"
        , body = []
        }
    , makersData =
        [ { name = "Makername", url = "google.com", logo = "logo.png", body = [] } ]
    , aboutPlaceCalData =
        { title = "PlaceCal lives here"
        , subtitleimg = "img.jpeg"
        , subtitleimgalt = "PlaceCal logo"
        , body = []
        }
    }


suite : Test
suite =
    describe "About page"
        [ test "Has an intro" <|
            \_ ->
                Theme.Page.About.viewIntro introMarkdown
                    |> queryFromStyled
                    |> Query.find [ Selector.tag "h1" ]
                    |> Query.contains [ Html.text "About us" ]
        , test "Has sections" <|
            \_ ->
                Theme.Page.About.viewSections sectionData
                    |> queryFromStyled
                    |> Query.findAll [ Selector.tag "h3" ]
                    |> Query.count (Expect.equal 3)
        ]
