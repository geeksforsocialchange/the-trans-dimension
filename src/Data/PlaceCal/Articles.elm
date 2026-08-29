module Data.PlaceCal.Articles exposing (Article, articleFromSlug, articlesData, summaryFromArticleBody)

import Array
import BackendTask
import BackendTask.Custom
import Copy.Text exposing (isValidUrl)
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
    BackendTask.combine
        (List.map
            (\partnershipTagInt ->
                Data.PlaceCal.Api.fetchAndCachePlaceCalData
                    ("articles-" ++ String.fromInt partnershipTagInt)
                    (allArticlesQuery (String.fromInt partnershipTagInt))
                    articlesDecoder
            )
            Data.PlaceCal.Partners.partnershipTagIdList
        )
        |> BackendTask.map (List.map .allArticles)
        |> BackendTask.map List.concat
        |> BackendTask.map sortArticlesByDate
        |> BackendTask.map (\articles -> { allArticles = articles })


allArticlesQuery : String -> Json.Encode.Value
allArticlesQuery partnershipTag =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string <|
                """
            query {
                articlesByTag(tagId: """
                    ++ partnershipTag
                    ++ """) {
                headline
                articleBody
                datePublished
                providers {
                    id
                }
                image
                }
            }
            """
          )
        ]


articlesDecoder : Json.Decode.Decoder AllArticlesResponse
articlesDecoder =
    Json.Decode.succeed AllArticlesResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "articlesByTag" ] (Json.Decode.list decode)


decode : Json.Decode.Decoder Article
decode =
    (Json.Decode.succeed Article
        |> Json.Decode.Pipeline.required "headline"
            Json.Decode.string
        |> Json.Decode.Pipeline.required "articleBody"
            Json.Decode.string
        |> Json.Decode.Pipeline.required "datePublished"
            Helpers.TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.required "providers"
            (Json.Decode.list partnerIdDecoder)
        |> Json.Decode.Pipeline.optional "image"
            Json.Decode.string
            ""
    )
        |> Json.Decode.andThen (\article -> addStockImage article)


sortArticlesByDate : List Article -> List Article
sortArticlesByDate articles =
    List.reverse <|
        List.sortBy
            (\article -> Time.posixToMillis article.publishedDatetime)
            articles


partnerIdDecoder : Json.Decode.Decoder String
partnerIdDecoder =
    Json.Decode.succeed ProviderId
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.map (\providerItem -> providerItem.id)


type alias ProviderId =
    { id : String }


type alias AllArticlesResponse =
    { allArticles : List Article }


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


articleFromSlug : String -> List Article -> Article
articleFromSlug slug allArticles =
    List.filter
        (\article -> Helpers.TransRoutes.stringToSlug article.title == slug)
        allArticles
        |> List.head
        |> Maybe.withDefault emptyArticle


summaryFromArticleBody : String -> String
summaryFromArticleBody articleBody =
    String.words articleBody
        |> List.take 20
        |> String.join " "
        |> (\summary -> summary ++ "...")
