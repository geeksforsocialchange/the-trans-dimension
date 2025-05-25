module Theme.Page.News exposing (viewNewsArticle, viewNewsList)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, after, auto, batch, borderBox, borderRadius, boxSizing, calc, center, displayFlex, em, flexGrow, fontSize, fontStyle, fontWeight, height, int, italic, left, lineHeight, margin, margin2, margin4, marginBottom, marginTop, maxWidth, minus, padding, padding4, paddingLeft, pct, position, property, px, relative, rem, textAlign, width)
import Data.PlaceCal.Articles
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h3, img, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Skin.Global exposing (linkStyle, primaryBackgroundStyle, secondaryButtonOnLightBackgroundStyle)
import Theme.GlobalLayout exposing (buttonFloatingWrapperStyle, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)


viewNewsList : List Data.PlaceCal.Articles.Article -> Html msg
viewNewsList newsList =
    section []
        [ if List.isEmpty newsList then
            p [] [ text (t NewsEmptyText) ]

          else
            ul [] (List.map (\newsItem -> viewNewsItem newsItem) newsList)
        ]


viewNewsItem : Data.PlaceCal.Articles.Article -> Html msg
viewNewsItem newsItem =
    li [ css [ newsItemStyle ] ]
        [ viewNewsArticle newsItem ]


viewNewsArticle : Data.PlaceCal.Articles.Article -> Html msg
viewNewsArticle newsItem =
    article [ css [ newsItemArticleStyle ] ]
        [ newsArticleImage newsItem.imageSrc
        , div [ css [ newsItemInfoStyle ] ]
            [ h3 [ css [ newsItemTitleStyle ] ]
                [ a
                    [ css [ linkStyle ]
                    , href
                        (TransRoutes.toAbsoluteUrl
                            (NewsItem (TransRoutes.stringToSlug newsItem.title))
                        )
                    ]
                    [ text newsItem.title ]
                ]
            , p [ css [ newsItemMetaStyle ] ]
                [ if List.length newsItem.partnerIds > 0 then
                    span [ css [ newsItemAuthorStyle ] ]
                        [ text (String.join ", " newsItem.partnerIds) ]

                  else
                    text ""
                , time [] [ text (TransDate.humanDateFromPosix newsItem.publishedDatetime) ]
                ]
            , p [ css [ newsItemSummaryStyle ] ] [ text (Data.PlaceCal.Articles.summaryFromArticleBody newsItem.body) ]
            ]
        , div [ css [ buttonFloatingWrapperStyle, width (calc (pct 100) minus (rem 2)) ] ]
            [ a
                [ css [ secondaryButtonOnLightBackgroundStyle ]
                , href
                    (TransRoutes.toAbsoluteUrl
                        (NewsItem (TransRoutes.stringToSlug newsItem.title))
                    )
                ]
                [ text (t NewsItemReadMore) ]
            ]
        ]


newsArticleImage : String -> Html msg
newsArticleImage imageSrc =
    img
        [ src imageSrc
        , css [ newsImageStyle ]
        , alt ""
        ]
        []



---------
-- Styles
---------


newsItemStyle : Style
newsItemStyle =
    batch
        [ primaryBackgroundStyle
        , margin4 (rem 2) (rem 0) (rem 3) (rem 0)
        , borderRadius (rem 0.2)
        , padding4 (rem 1.25) (rem 1.25) (rem 3) (rem 1.25)
        , position relative
        , boxSizing borderBox
        , withMediaSmallDesktopUp [ maxWidth (px 920), margin4 (rem 4) auto (rem 5) auto ]
        , withMediaTabletLandscapeUp [ margin (rem 3), padding (rem 2) ]
        , withMediaTabletPortraitUp [ padding (rem 3) ]
        ]


newsItemArticleStyle : Style
newsItemArticleStyle =
    batch
        [ withMediaTabletPortraitUp [ displayFlex ] ]


newsImageStyle : Style
newsImageStyle =
    batch
        [ width (pct 100)
        , height (pct 56.25)
        , property "object-fit" "cover"
        , borderRadius (rem 0.3)
        , marginBottom (rem 1)
        , withMediaSmallDesktopUp [ marginTop (rem 1) ]
        , withMediaTabletLandscapeUp [ width (px 303) ]
        , withMediaTabletPortraitUp [ width (px 294), maxWidth (pct 50) ]
        ]


newsItemInfoStyle : Style
newsItemInfoStyle =
    batch
        [ withMediaTabletPortraitUp
            [ flexGrow (int 1)
            , paddingLeft (rem 2)
            ]
        ]


newsItemTitleStyle : Style
newsItemTitleStyle =
    batch
        [ fontWeight (int 400)
        , fontStyle italic
        , textAlign center
        , fontSize (rem 1.85)
        , lineHeight (em 1.3)
        , withMediaTabletPortraitUp [ textAlign left ]
        ]


newsItemMetaStyle : Style
newsItemMetaStyle =
    batch
        [ fontWeight (int 600)
        , textAlign center
        , withMediaTabletLandscapeUp [ margin2 (rem 1) (rem 0) ]
        , withMediaTabletPortraitUp [ textAlign left ]
        ]


newsItemAuthorStyle : Style
newsItemAuthorStyle =
    batch
        [ after [ property "content" "\"•\"", margin2 (rem 0) (rem 0.25) ]
        , withMediaTabletPortraitUp [ textAlign left ]
        ]


newsItemSummaryStyle : Style
newsItemSummaryStyle =
    batch
        [ textAlign center
        , marginTop (rem 0.5)
        , withMediaTabletPortraitUp [ textAlign left, fontSize (rem 1.2) ]
        ]
