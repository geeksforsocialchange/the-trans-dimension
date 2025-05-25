module Data.PlaceCal.Articles exposing (Article, articleFromSlug, articlesData, replacePartnerIdWithName, summaryFromArticleBody)

import Array
import BackendTask
import BackendTask.Custom
import Copy.Utils exposing (isValidUrl)
import Data.PlaceCal.Api
import Data.PlaceCal.Partners
import FatalError
import Helpers.TransDate
import Helpers.TransRoutes
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Time


type alias Article =
    { title : String
    , body : String
    , publishedDatetime : Time.Posix
    , partnerIds : List String
    , imageSrc : String
    }


emptyArticle : Article
emptyArticle =
    { title = ""
    , body = ""
    , publishedDatetime = Time.millisToPosix 0
    , partnerIds = []
    , imageSrc = "/images/news/article_1.jpg"
    }



----------------------------
-- BackendTask query & decode
----------------------------


articlesData : BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Custom.Error } AllArticlesResponse
articlesData =
    Data.PlaceCal.Api.fetchAndCachePlaceCalData "articles"
        allArticlesQuery
        articlesDecoder


allArticlesQuery : Json.Encode.Value
allArticlesQuery =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string """
            query { articleConnection { edges {
                node {
                  articleBody
                  datePublished
                  headline
                  providers { id }
                  image
            } } } }
            """
          )
        ]


articlesDecoder : Json.Decode.Decoder AllArticlesResponse
articlesDecoder =
    Json.Decode.succeed AllArticlesResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "articleConnection", "edges" ] (Json.Decode.list decode)


decode : Json.Decode.Decoder Article
decode =
    (Json.Decode.succeed Article
        |> Json.Decode.Pipeline.requiredAt [ "node", "headline" ]
            Json.Decode.string
        |> Json.Decode.Pipeline.requiredAt [ "node", "articleBody" ]
            Json.Decode.string
        |> Json.Decode.Pipeline.requiredAt [ "node", "datePublished" ]
            Helpers.TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.requiredAt [ "node", "providers" ]
            (Json.Decode.list partnerIdDecoder)
        |> Json.Decode.Pipeline.optionalAt [ "node", "image" ]
            Json.Decode.string
            ""
    )
        |> Json.Decode.andThen (\article -> addStockImage article)


partnerIdDecoder : Json.Decode.Decoder String
partnerIdDecoder =
    Json.Decode.succeed ProviderId
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.map (\providerItem -> providerItem.id)


type alias ProviderId =
    { id : String }


type alias AllArticlesResponse =
    { allArticles : List Article }


replacePartnerIdWithName : List Article -> List Data.PlaceCal.Partners.Partner -> List Article
replacePartnerIdWithName articleData partnerData =
    List.map
        (\article ->
            { article | partnerIds = Data.PlaceCal.Partners.partnerNamesFromIds partnerData article.partnerIds }
        )
        articleData


addStockImage article =
    Json.Decode.succeed
        { article
            | imageSrc =
                if isValidUrl article.imageSrc then
                    article.imageSrc

                else
                    pickImageFromArticleLength (String.length article.body)
        }


pickImageFromArticleLength : Int -> String
pickImageFromArticleLength articleLength =
    Array.get
        (modBy
            (List.length stockImages)
            articleLength
        )
        (Array.fromList stockImages)
        |> Maybe.withDefault "/images/news/article_1.jpg"


stockImages : List String
stockImages =
    List.map
        (\id ->
            "/images/news/article_" ++ String.fromInt id ++ ".jpg"
        )
        [ 1, 2, 3, 4, 5, 6 ]


articleFromSlug : String -> List Article -> List Data.PlaceCal.Partners.Partner -> Article
articleFromSlug slug allArticles allPartners =
    List.filter
        (\article -> Helpers.TransRoutes.stringToSlug article.title == slug)
        (replacePartnerIdWithName allArticles allPartners)
        |> List.head
        |> Maybe.withDefault emptyArticle


summaryFromArticleBody : String -> String
summaryFromArticleBody articleBody =
    String.words articleBody
        |> List.take 20
        |> String.join " "
        |> (\summary -> summary ++ "...")
