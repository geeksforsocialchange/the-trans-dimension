module Theme.Page.NewsItem exposing (viewArticle)

import Css exposing (Style, after, auto, batch, block, bold, borderRadius, center, display, firstChild, fontSize, fontWeight, height, margin, margin2, margin4, marginTop, maxWidth, pct, property, px, rem, textAlign, width)
import Css.Global exposing (descendants, typeSelector)
import Data.PlaceCal.Articles
import Helpers.TransDate as TransDate
import Html.Styled exposing (Html, article, div, figure, img, p, span, text, time)
import Html.Styled.Attributes exposing (alt, css, src)
import Theme.GlobalLayout exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.TransMarkdown as TransMarkdown


viewArticle : Data.PlaceCal.Articles.Article -> Html msg
viewArticle newsItem =
    article [ css [ articleStyle ] ]
        [ p [ css [ articleMetaStyle ] ]
            [ if List.length newsItem.partnerIds > 0 then
                span [ css [ newsItemAuthorStyle ] ]
                    [ text (String.join ", " newsItem.partnerIds) ]

              else
                text ""
            , time [] [ text (TransDate.humanDateFromPosix newsItem.publishedDatetime) ]
            ]
        , articleImage newsItem.imageSrc
        , div [ css [ articleContentStyle ] ] (TransMarkdown.markdownToHtml newsItem.body)
        ]


articleImage : String -> Html msg
articleImage imageSrc =
    figure [ css [ articleFigureStyle ] ]
        [ img [ src imageSrc, css [ articleFigureImageStyle ], alt "" ] []
        ]


articleStyle : Style
articleStyle =
    batch
        [ margin2 (rem 0) (rem 0.25)
        , withMediaTabletLandscapeUp [ maxWidth (px 636), margin2 (rem 0) auto ]
        ]


articleMetaStyle : Style
articleMetaStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , display block
        , margin (rem 0)
        , withMediaTabletPortraitUp [ margin4 (rem 0) (rem 2) (rem 3) (rem 2) ]
        ]


articleFigureStyle : Style
articleFigureStyle =
    batch
        [ margin2 (rem 2) (rem 0)
        , withMediaSmallDesktopUp [ marginTop (rem 5) ]
        , withMediaTabletLandscapeUp [ margin2 (rem 2) (rem 0) ]
        , withMediaTabletPortraitUp [ margin2 (rem 2) (rem 1) ]
        ]


articleFigureImageStyle : Style
articleFigureImageStyle =
    batch
        [ width (pct 100)
        , height (pct 56.25)
        , property "object-fit" "cover"
        , borderRadius (rem 0.3)
        ]



{- not in use
   articleFigureCaptionStyle : Style
   articleFigureCaptionStyle =
       batch
           [ fontSize (rem 0.875)
           , textAlign center
           , margin (rem 0.75)
           , fontStyle italic
           ]
-}


articleContentStyle : Style
articleContentStyle =
    batch
        [ margin2 (rem 4) (rem 0)
        , withMediaTabletPortraitUp [ maxWidth (px 636), margin2 (rem 4) auto, fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ maxWidth (px 560), margin2 (rem 4) auto ]
        , descendants
            [ typeSelector "p"
                [ batch
                    [ firstChild
                        [ fontSize (rem 2) ]
                    ]
                ]
            ]
        ]


newsItemAuthorStyle : Style
newsItemAuthorStyle =
    batch
        [ after [ property "content" "\"•\"", margin2 (rem 0) (rem 0.25) ]
        ]
