module Data.ArticlesTests exposing (..)

import Data.PlaceCal.Articles exposing (Article, articlesWithPartnershipPartners)
import Expect
import Test exposing (Test, describe, test)
import TestFixtures
import Time


articleWithPartnerIds : String -> List String -> Article
articleWithPartnerIds title partnerIds =
    { title = title
    , body = "Some article body"
    , publishedDatetime = Time.millisToPosix 1645449400000
    , partnerIds = partnerIds
    , imageSrc = ""
    }


suite : Test
suite =
    describe "Data.PlaceCal.Articles.articlesWithPartnershipPartners"
        [ test "Keeps an article whose partners are all in the partnership" <|
            \_ ->
                [ articleWithPartnerIds "In partnership" [ "1", "2" ] ]
                    |> articlesWithPartnershipPartners TestFixtures.partners
                    |> Expect.equal [ articleWithPartnerIds "In partnership" [ "1", "2" ] ]
        , test "Drops an article whose partners are all outside the partnership" <|
            \_ ->
                [ articleWithPartnerIds "Outside partnership" [ "1000", "1001" ] ]
                    |> articlesWithPartnershipPartners TestFixtures.partners
                    |> Expect.equal []
        , test "Keeps an article with a mix of partners, dropping the ones outside the partnership" <|
            \_ ->
                [ articleWithPartnerIds "Mixed" [ "1", "1000" ] ]
                    |> articlesWithPartnershipPartners TestFixtures.partners
                    |> Expect.equal [ articleWithPartnerIds "Mixed" [ "1" ] ]
        , test "Drops an article with no partners at all" <|
            \_ ->
                [ articleWithPartnerIds "No partners" [] ]
                    |> articlesWithPartnershipPartners TestFixtures.partners
                    |> Expect.equal []
        , test "Only drops the articles that are outside the partnership" <|
            \_ ->
                [ articleWithPartnerIds "In partnership" [ "2" ]
                , articleWithPartnerIds "Outside partnership" [ "1000" ]
                , articleWithPartnerIds "No partners" []
                ]
                    |> articlesWithPartnershipPartners TestFixtures.partners
                    |> List.map .title
                    |> Expect.equal [ "In partnership" ]
        , test "Returns no articles when there are no partners" <|
            \_ ->
                [ articleWithPartnerIds "In partnership" [ "1" ] ]
                    |> articlesWithPartnershipPartners []
                    |> Expect.equal []
        ]
