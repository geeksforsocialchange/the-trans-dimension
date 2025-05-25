module Theme.Page.About exposing (viewIntro, viewSections)

import Css exposing (Style, absolute, after, alignItems, auto, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, bottom, calc, center, column, display, displayFlex, flexDirection, flexShrink, height, important, int, justifyContent, left, margin, margin2, margin4, marginBottom, marginTop, minus, noRepeat, nthChild, padding, paddingBottom, paddingLeft, paddingRight, paddingTop, pct, position, property, px, relative, rem, right, spaceAround, top, url, vw, width, zIndex)
import Css.Global exposing (descendants, typeSelector)
import Html.Styled exposing (Html, a, div, h3, h4, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Markdown.Block
import Skin.Global exposing (contentWrapperStyle, introTextLargeStyle, normalFirstParagraphStyle, smallFloatingTitleStyle, textBoxSecondaryStyle, whiteButtonStyle)
import Theme.GlobalLayout exposing (buttonFloatingWrapperStyle, contentContainerStyle, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate
import Theme.TransMarkdown


viewIntro : List Markdown.Block.Block -> Html msg
viewIntro introBody =
    section [ css [ introTextStyle ] ] (Theme.TransMarkdown.markdownBlocksToHtml introBody)


viewSections :
    { accessibilityData : Theme.PageTemplate.SectionWithTextHeader
    , makersData : List { name : String, url : String, logo : String, body : List Markdown.Block.Block }
    , aboutPlaceCalData : Theme.PageTemplate.SectionWithImageHeader
    }
    -> Html msg
viewSections { accessibilityData, makersData, aboutPlaceCalData } =
    div []
        [ viewAccessibility accessibilityData
        , viewMakers makersData
        , viewAboutPlaceCal aboutPlaceCalData
        ]


viewAccessibility : Theme.PageTemplate.SectionWithTextHeader -> Html msg
viewAccessibility { title, subtitle, body } =
    section [ css [ contentWrapperStyle, accessibilityStyle ] ]
        [ h3 [ css [ smallFloatingTitleStyle, withMediaMobileOnly [ top (rem -4.5) ] ] ] [ text title ]
        , div [ css [ textBoxSecondaryStyle, accessibilityCharactersStyle ] ] [ p [ css [ introTextLargeStyle ] ] [ text subtitle ] ]
        , div [ css [ contentContainerStyle, aboutAccessibilityTextStyle ] ] (Theme.TransMarkdown.markdownBlocksToHtml body)
        ]


viewMakers : List { name : String, url : String, logo : String, body : List Markdown.Block.Block } -> Html msg
viewMakers makersList =
    section [ css [ makersStyle ] ]
        (List.concat
            [ [ h3 [ css [ smallFloatingTitleStyle ] ] [ text "Meet the Makers" ] ]
            , List.map (\maker -> viewMaker maker) makersList
            ]
        )


viewMaker : { name : String, url : String, logo : String, body : List Markdown.Block.Block } -> Html msg
viewMaker { name, url, logo, body } =
    div [ css [ makerStyle, textBoxSecondaryStyle ] ]
        [ h4 [ css [ makerHeaderStyle ] ] [ img [ src logo, alt name, css [ makerLogoStyle ] ] [] ]
        , div [ css [ normalFirstParagraphStyle ] ] (Theme.TransMarkdown.markdownBlocksToHtml body)
        , p [ css [ buttonFloatingWrapperStyle ] ] [ a [ href url, css [ whiteButtonStyle ] ] [ text "Find out more" ] ]
        ]


viewAboutPlaceCal : Theme.PageTemplate.SectionWithImageHeader -> Html msg
viewAboutPlaceCal { title, subtitleimg, subtitleimgalt, body } =
    section [ css [ contentWrapperStyle, placeCalStyle ] ]
        [ h3 [ css [ smallFloatingTitleStyle ] ] [ text title ]
        , div [ css [ textBoxSecondaryStyle ] ]
            [ img
                [ src subtitleimg
                , alt subtitleimgalt
                , css [ placeCalLogoStyle ]
                ]
                []
            ]
        , div [ css [ Theme.PageTemplate.columnsStyle, contentContainerStyle, normalFirstParagraphStyle ] ] (Theme.TransMarkdown.markdownBlocksToHtml body)
        ]


introTextStyle : Style
introTextStyle =
    batch
        [ textStyle
        , position relative
        , descendants
            [ typeSelector "p"
                [ batch
                    [ withMediaMobileOnly
                        [ nthChild "3"
                            [ before
                                [ backgroundImage (url "/images/illustrations/320px/about_2.png")
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ property "content" "\"\""
                , display block
                , width (px 298)
                , backgroundSize (px 298)
                , backgroundPosition center
                , position absolute
                , backgroundRepeat noRepeat
                , height (px 541)
                , bottom (px -160)
                , right (px -350)
                , backgroundImage (url "/images/characters/about-character-2.png")
                ]
            ]
        ]


textStyle : Style
textStyle =
    batch
        [ normalFirstParagraphStyle
        , marginTop (rem 2)
        , marginBottom (rem 2)
        , descendants
            [ typeSelector "p"
                [ batch
                    [ withMediaMobileOnly
                        [ nthChild "3"
                            [ paddingTop (px 200)
                            , position relative
                            , before
                                [ property "content" "\"\""
                                , display block
                                , width (vw 100)
                                , backgroundSize (px 420)
                                , backgroundPosition center
                                , position absolute
                                , backgroundRepeat noRepeat
                                , margin2 (rem 0) (rem -1.5)
                                , height (px 230)
                                , top (px -30)
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , Theme.PageTemplate.columnsStyle
        ]


accessibilityStyle : Style
accessibilityStyle =
    batch
        [ position relative
        , marginTop (px 370)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , height (px 290)
            , top (px -355)
            , backgroundImage (url "/images/illustrations/320px/about_3.png")
            , withMediaMediumDesktopUp
                [ margin2 (rem 0) (calc (vw -50) minus (px -575))
                , backgroundImage (url "/images/illustrations/1920px/about_2.png")
                , height (px 250)
                , backgroundSize (px 1920)
                , top (px -260)
                ]
            , withMediaSmallDesktopUp
                [ margin2 (rem 0) (rem -7)
                , backgroundImage (url "/images/illustrations/1366px/about_2.png")
                , backgroundSize (px 1367)
                , height (px 200)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_2.png")
                , height (px 280)
                , backgroundSize (px 1200)
                , top (px -250)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_2.png")
                , backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                , height (px 200)
                , top (px -190)
                , zIndex (int -1)
                ]
            ]
        , withMediaSmallDesktopUp
            [ marginTop (px 250) ]
        , withMediaTabletLandscapeUp
            [ marginTop (px 220) ]
        , withMediaTabletPortraitUp
            [ marginTop (px 200) ]
        ]


accessibilityCharactersStyle : Style
accessibilityCharactersStyle =
    batch
        [ position relative
        , before
            [ withMediaSmallDesktopUp
                [ width (px 244)
                , height (px 357)
                , backgroundSize (px 244)
                , left (px -100)
                ]
            , withMediaTabletLandscapeUp
                [ property "content" "\"\""
                , display block
                , width (px 182)
                , height (px 267)
                , backgroundSize (px 182)
                , backgroundPosition center
                , position absolute
                , zIndex (int 2)
                , backgroundRepeat noRepeat
                , backgroundImage (url "/images/characters/about-character-1.png")
                , top (px -190)
                , left (px 10)
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ width (px 429)
                , height (px 478)
                , backgroundSize (px 429)
                , right (px -100)
                , bottom (px -370)
                ]
            , withMediaTabletLandscapeUp
                [ property "content" "\"\""
                , display block
                , width (px 347)
                , height (px 386)
                , backgroundSize (px 347)
                , backgroundPosition center
                , position absolute
                , zIndex (int 2)
                , backgroundRepeat noRepeat
                , backgroundImage (url "/images/characters/about-character-3.png")
                , bottom (px -50)
                , right (px -10)
                ]
            ]
        , withMediaTabletLandscapeUp
            [ important (paddingLeft (rem 10)), important (paddingRight (rem 10)) ]
        ]


aboutAccessibilityTextStyle : Style
aboutAccessibilityTextStyle =
    batch
        [ textStyle
        , descendants
            [ typeSelector "p"
                [ batch
                    [ withMediaMobileOnly
                        [ nthChild "3"
                            [ before
                                [ backgroundImage (url "/images/illustrations/320px/about_4.png")
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


makersStyle : Style
makersStyle =
    batch
        [ position relative
        , marginTop (px 250)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , height (px 230)
            , top (px -250)
            , backgroundImage (url "/images/illustrations/320px/about_5.png")
            , withMediaMediumDesktopUp
                [ margin2 (rem 0) (calc (vw -50) minus (px -575))
                , backgroundImage (url "/images/illustrations/1920px/about_3.png")
                , backgroundSize (px 1920)
                , height (px 250)
                , top (px -240)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/about_3.png")
                , margin2 (rem 0) (rem -14)
                , backgroundSize (px 1367)
                , height (px 200)
                , top (px -200)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_3.png")
                , backgroundSize (px 1200)
                , height (px 280)
                , top (px -210)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_3.png")
                , backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                , height (px 200)
                , top (px -190)
                , zIndex (int -1)
                ]
            ]
        , withMediaMediumDesktopUp
            [ marginTop (px 250) ]
        , withMediaSmallDesktopUp
            [ marginTop (px 200) ]
        , withMediaTabletLandscapeUp
            [ displayFlex, justifyContent spaceAround ]
        , withMediaTabletPortraitUp
            [ marginTop (px 150) ]
        ]


makerStyle : Style
makerStyle =
    batch
        [ marginTop (rem 3)
        , paddingBottom (rem 3)
        , marginBottom (rem 3)
        , position relative
        , withMediaSmallDesktopUp
            [ paddingLeft (rem 3)
            , paddingRight (rem 3)
            , paddingBottom (rem 3)
            ]
        , withMediaTabletLandscapeUp
            [ flexDirection column
            , width (pct 40)
            , marginTop (rem 1)
            ]
        , withMediaTabletPortraitUp
            [ displayFlex
            , alignItems center
            , paddingTop (rem 2)
            ]
        ]


makerHeaderStyle : Style
makerHeaderStyle =
    batch
        [ withMediaTabletLandscapeUp [ padding (rem 0) ]
        , withMediaTabletPortraitUp
            [ flexShrink (int 0)
            , paddingLeft (rem 1)
            , paddingRight (rem 3)
            ]
        ]


makerLogoStyle : Style
makerLogoStyle =
    batch
        [ height (px 50)
        , margin4 (rem 2) auto (rem 3) auto
        , withMediaSmallDesktopUp [ height (px 55) ]
        , withMediaTabletLandscapeUp [ margin4 (rem 1) auto (rem 3) auto ]
        , withMediaTabletPortraitUp [ margin (rem 0) ]
        ]


placeCalStyle : Style
placeCalStyle =
    batch
        [ position relative
        , marginTop (px 530)
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -0.75)
            , height (px 480)
            , top (px -520)
            , backgroundImage (url "/images/illustrations/320px/about_6.png")
            , withMediaMediumDesktopUp
                [ margin2 (rem 0) (calc (vw -50) minus (px -575))
                , backgroundImage (url "/images/illustrations/1920px/about_4.png")
                , height (px 250)
                , top (px -250)
                , backgroundSize (px 1920)
                ]
            , withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/about_4.png")
                , width (vw 100)
                , backgroundSize (px 1367)
                , height (px 200)
                , margin2 (rem 0) (rem -7)
                ]
            , withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/about_4.png")
                , backgroundSize (px 1200)
                , height (px 280)
                , top (px -230)
                ]
            , withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/about_4.png")
                , backgroundSize (px 900)
                , margin2 (rem 0) (rem -2)
                , height (px 200)
                , top (px -190)
                , zIndex (int -1)
                ]
            ]
        , after
            [ withMediaSmallDesktopUp
                [ property "content" "\"\""
                , display block
                , width (px 186)
                , backgroundSize (px 186)
                , backgroundPosition center
                , position absolute
                , backgroundRepeat noRepeat
                , height (px 516)
                , left (px -80)
                , top (px -70)
                , backgroundImage (url "/images/characters/about-character-4.png")
                ]
            ]
        , withMediaMediumDesktopUp
            [ marginTop (px 250) ]
        , withMediaTabletLandscapeUp
            [ marginTop (px 230) ]
        , withMediaTabletPortraitUp
            [ marginTop (px 200) ]
        ]


placeCalLogoStyle : Style
placeCalLogoStyle =
    batch
        [ width (px 200)
        , margin2 (rem 1) auto
        , withMediaTabletPortraitUp
            [ margin2 (rem 1.5) auto ]
        ]
