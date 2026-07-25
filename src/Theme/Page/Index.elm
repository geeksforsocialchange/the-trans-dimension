module Theme.Page.Index exposing (view)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, absolute, after, auto, backgroundImage, backgroundPosition, backgroundRepeat, backgroundSize, batch, before, block, borderRadius, bottom, calc, center, color, display, em, fontSize, fontStyle, fontWeight, height, important, inlineBlock, int, italic, lineHeight, margin2, marginBottom, marginLeft, marginRight, marginTop, maxWidth, minus, noRepeat, none, padding2, padding4, paddingBottom, paddingLeft, paddingRight, paddingTop, pct, position, property, px, relative, rem, textAlign, top, url, vw, width, zIndex)
import Data.PlaceCal.Articles
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Helpers.TransRoutes
import Html.Styled exposing (Html, a, div, h1, h2, img, p, section, text)
import Html.Styled.Attributes exposing (alt, css, href, src)
import Theme.Global
import Theme.Page.Events exposing (Msg, fromRegionSelectorMsg)
import Theme.Page.News
import Theme.Paginator
import Theme.RegionSelector
import Time


view :
    { events : List Data.PlaceCal.Events.Event
    , partners : List Data.PlaceCal.Partners.Partner
    , articles : List Data.PlaceCal.Articles.Article
    , time : Time.Posix
    , timezone : Time.Zone
    }
    ->
        { localModel
            | filterByRegion : Int
            , nowTime : Time.Posix
        }
    -> Html Theme.Page.Events.Msg
view sharedData localModel =
    div [ css [ pageWrapperStyle ] ]
        [ viewIntro (t IndexIntroTitle) (t IndexIntroMessage) (t IndexIntroButtonText)
        , viewFeatured localModel.nowTime sharedData.timezone (Data.PlaceCal.Events.eventsWithPartners sharedData.events sharedData.partners) localModel.filterByRegion
        , viewLatestNews sharedData.partners (List.head sharedData.articles) (t IndexNewsHeader) (t IndexNewsButtonText)
        ]


viewIntro : String -> String -> String -> Html msg
viewIntro introTitle introMsg eventButtonText =
    section [ css [ sectionStyle, Theme.Global.pinkBackgroundStyle, introSectionStyle ] ]
        [ h1 [ css [ logoStyle ] ]
            [ img
                [ src "/images/logos/tdd_logo_with_strapline.svg"
                , alt (t SiteTitle ++ ", " ++ t SiteStrapline)
                , css [ logoImageStyle ]
                ]
                []
            ]
        , h2 [ css [ sectionSubtitleStyle ] ] [ text introTitle ]
        , p [ css [ sectionTextStyle ] ] [ text introMsg ]
        , p [ css [ Theme.Global.buttonFloatingWrapperStyle, width (calc (pct 100) minus (rem 2)) ] ]
            [ a
                [ href (Helpers.TransRoutes.toAbsoluteUrl Helpers.TransRoutes.Events)
                , css [ Theme.Global.whiteButtonStyle ]
                ]
                [ text eventButtonText ]
            ]
        ]


viewFeatured : Time.Posix -> Time.Zone -> List Data.PlaceCal.Events.Event -> Int -> Html Msg
viewFeatured fromTime timezone eventList regionId =
    section [ css [ sectionStyle, Theme.Global.darkBlueBackgroundStyle, eventsSectionStyle ] ]
        [ h2 [ css [ Theme.Global.smallFloatingTitleStyle ] ] [ text (t IndexFeaturedHeader) ]
        , if List.length Data.PlaceCal.Partners.partnershipTagList > 1 then
            Theme.RegionSelector.viewRegionSelector { filterBy = regionId } |> Html.Styled.map fromRegionSelectorMsg

          else
            text ""
        , Theme.Page.Events.viewEventsList { filterByDate = Theme.Paginator.Future, filterByRegion = regionId, nowTime = fromTime, timezone = timezone } eventList (Just 8)
        , viewAllEventsButton
        ]


viewAllEventsButton : Html msg
viewAllEventsButton =
    p [ css [ Theme.Global.buttonFloatingWrapperStyle, width (calc (pct 100) minus (rem 2)) ] ]
        [ a
            [ href (Helpers.TransRoutes.toAbsoluteUrl Helpers.TransRoutes.Events)
            , css [ Theme.Global.pinkButtonOnDarkBackgroundStyle ]
            ]
            [ text (t IndexFeaturedButtonText) ]
        ]


viewLatestNews : List Data.PlaceCal.Partners.Partner -> Maybe Data.PlaceCal.Articles.Article -> String -> String -> Html msg
viewLatestNews partnerList maybeNewsItem title buttonText =
    section [ css [ sectionStyle, Theme.Global.darkBlueBackgroundStyle, newsSectionStyle ] ]
        [ h2 [ css [ Theme.Global.smallFloatingTitleStyle ] ] [ text title ]
        , case maybeNewsItem of
            Just news ->
                Theme.Page.News.viewNewsArticle partnerList news

            Nothing ->
                text ""
        , p [ css [ Theme.Global.buttonFloatingWrapperStyle, bottom (rem -6), width (calc (pct 100) minus (rem 2)) ] ]
            [ a
                [ href (Helpers.TransRoutes.toAbsoluteUrl Helpers.TransRoutes.News)
                , css [ Theme.Global.darkBlueButtonStyle ]
                ]
                [ text buttonText ]
            ]
        ]


pageWrapperStyle : Style
pageWrapperStyle =
    batch
        [ margin2 (rem 0) (rem 0.75)
        , Theme.Global.withMediaSmallDesktopUp [ margin2 (rem 0) (rem 6) ]
        , Theme.Global.withMediaTabletLandscapeUp [ margin2 (rem 0) (rem 5) ]
        , Theme.Global.withMediaTabletPortraitUp [ margin2 (rem 0) (rem 1.5) ]
        ]


logoStyle : Style
logoStyle =
    batch
        [ display none
        , Theme.Global.withMediaMediumDesktopUp
            [ top (px -750) ]
        , Theme.Global.withMediaSmallDesktopUp
            [ top (px -575) ]
        , Theme.Global.withMediaTabletLandscapeUp
            [ top (px -425) ]
        , Theme.Global.withMediaTabletPortraitUp
            [ display block
            , position absolute
            , width (pct 100)
            , textAlign center
            , top (px -600)
            ]
        ]


logoImageStyle : Style
logoImageStyle =
    batch
        [ width (px 268)
        , display inlineBlock
        , Theme.Global.withMediaMediumDesktopUp [ width (px 527) ]
        , Theme.Global.withMediaSmallDesktopUp [ width (px 381) ]
        , Theme.Global.withMediaTabletLandscapeUp [ width (px 305) ]
        ]


sectionStyle : Style
sectionStyle =
    batch
        [ borderRadius (rem 0.3)
        , padding4 (rem 1) (rem 1) (rem 4) (rem 1)
        , marginBottom (rem 2)
        , position relative
        , before
            [ property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , zIndex (int -1)
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -1.75)
            , Theme.Global.withMediaMediumDesktopUp
                [ backgroundSize (px 1920)
                , margin2 (rem 0) (calc (vw -50) minus (px -475))
                ]
            , Theme.Global.withMediaSmallDesktopUp
                [ backgroundSize (px 1366)
                , margin2 (rem 0) (rem -14)
                ]
            , Theme.Global.withMediaTabletLandscapeUp
                [ backgroundSize (px 1200)
                , margin2 (rem 0) (rem -6)
                ]
            , Theme.Global.withMediaTabletPortraitUp
                [ backgroundSize (px 900)
                , margin2 (rem 0) (rem -2.5)
                ]
            ]
        , Theme.Global.withMediaMediumDesktopUp
            [ maxWidth (px 950), marginRight auto, marginLeft auto ]
        , Theme.Global.withMediaSmallDesktopUp
            [ padding4 (rem 3) (rem 1) (rem 3) (rem 1)
            , marginLeft (rem 7)
            , marginRight (rem 7)
            ]
        , Theme.Global.withMediaTabletPortraitUp
            [ paddingBottom (rem 3) ]
        ]


sectionSubtitleStyle : Style
sectionSubtitleStyle =
    batch
        [ padding2 (rem 0.5) (rem 1)
        , marginBottom (rem 1)
        , textAlign center
        , fontStyle italic
        , fontSize (rem 2.1)
        , lineHeight (em 1.1)
        , fontWeight (int 500)
        , color Theme.Global.darkBlue
        , Theme.Global.withMediaSmallDesktopUp
            [ margin2 (rem 0.5) (rem 1) ]
        , Theme.Global.withMediaTabletPortraitUp
            [ fontSize (rem 3.2)
            , margin2 (rem 0.5) (rem 4)
            , paddingLeft (rem 0)
            , paddingRight (rem 0)
            ]
        ]


sectionTextStyle : Style
sectionTextStyle =
    batch
        [ textAlign center
        , color Theme.Global.darkBlue
        , Theme.Global.withMediaSmallDesktopUp
            [ margin2 (rem 2) (rem 8) ]
        , Theme.Global.withMediaTabletPortraitUp
            [ fontSize (rem 1.2)
            , margin2 (rem 1) (rem 4)
            ]
        ]


introSectionStyle : Style
introSectionStyle =
    batch
        [ marginTop (px 430)
        , before
            [ backgroundImage (url "/images/illustrations/320px/homepage_1_header.png")
            , height (px 626)
            , top (px -550)
            , Theme.Global.withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/homepage_1_header.png")
                , height (px 1306)
                , top (px -1100)
                ]
            , Theme.Global.withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/homepage_1_header.png")
                , height (px 1142)
                , top (px -850)
                ]
            , Theme.Global.withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/homepage_1_header.png")
                , height (px 792)
                , top (px -650)
                ]
            , Theme.Global.withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/homepage_1_header.png")
                , height (px 960)
                , top (px -900)
                ]
            ]
        , Theme.Global.withMediaMediumDesktopUp [ marginTop (px 1000) ]
        , Theme.Global.withMediaSmallDesktopUp [ marginTop (px 750) ]
        , Theme.Global.withMediaTabletLandscapeUp [ marginTop (px 550) ]
        , Theme.Global.withMediaTabletPortraitUp
            [ marginTop (px 820)
            ]
        ]


eventsSectionStyle : Style
eventsSectionStyle =
    batch
        [ marginTop (px 250)
        , before
            [ backgroundImage (url "/images/illustrations/320px/homepage_3.png")
            , height (px 240)
            , top (px -250)
            , Theme.Global.withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/homepage_3.png")
                , height (px 250)
                , top (px -220)
                , important (marginLeft (calc (vw -50) minus (px -575)))
                , important (marginRight (calc (vw -50) minus (px -575)))
                ]
            , Theme.Global.withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/homepage_3.png")
                , height (px 200)
                , important (marginLeft (rem -7))
                , important (marginRight (rem -7))
                , top (px -200)
                ]
            , Theme.Global.withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/homepage_3.png")
                , height (px 280)
                , top (px -230)
                ]
            , Theme.Global.withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/homepage_3.png")
                , height (px 200)
                , top (px -195)
                ]
            ]
        , Theme.Global.withMediaMediumDesktopUp
            [ important (maxWidth (px 1150))
            , important (marginLeft auto)
            , important (marginRight auto)
            , marginTop (px 220)
            ]
        , Theme.Global.withMediaSmallDesktopUp
            [ important (marginLeft (rem 0))
            , important (marginRight (rem 0))
            ]
        , Theme.Global.withMediaTabletLandscapeUp
            [ marginTop (px 150) ]
        , Theme.Global.withMediaTabletPortraitUp
            [ marginTop (px 175) ]
        ]


newsSectionStyle : Style
newsSectionStyle =
    batch
        [ marginTop (px 240)
        , marginBottom (px 240)
        , before
            [ backgroundImage (url "/images/illustrations/320px/homepage_4.png")
            , height (px 240)
            , top (px -240)
            , Theme.Global.withMediaMediumDesktopUp
                [ backgroundImage (url "/images/illustrations/1920px/homepage_4.png")
                , height (px 250)
                , top (px -250)
                ]
            , Theme.Global.withMediaSmallDesktopUp
                [ backgroundImage (url "/images/illustrations/1366px/homepage_4.png")
                , height (px 237)
                , top (px -200)
                ]
            , Theme.Global.withMediaTabletLandscapeUp
                [ backgroundImage (url "/images/illustrations/1024px/homepage_4.png")
                , height (px 280)
                , top (px -230)
                ]
            , Theme.Global.withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/homepage_4.png")
                , height (px 200)
                , top (px -195)
                ]
            ]
        , after
            [ backgroundImage (url "/images/illustrations/320px/homepage_5.png")
            , property "content" "\"\""
            , display block
            , width (vw 100)
            , backgroundSize (px 420)
            , backgroundPosition center
            , position absolute
            , zIndex (int -1)
            , backgroundRepeat noRepeat
            , margin2 (rem 0) (rem -1.75)
            , bottom (px -270)
            , height (px 240)
            , Theme.Global.withMediaMediumDesktopUp
                [ backgroundSize (px 1920)
                , backgroundImage (url "/images/illustrations/1920px/homepage_5.png")
                , margin2 (rem 0) (calc (vw -50) minus (px -475))
                , height (px 250)
                , bottom (px -210)
                ]
            , Theme.Global.withMediaSmallDesktopUp
                [ backgroundSize (px 1366)
                , margin2 (rem 0) (rem -14)
                , backgroundImage (url "/images/illustrations/1366px/homepage_5.png")
                , height (px 237)
                , bottom (px -200)
                ]
            , Theme.Global.withMediaTabletLandscapeUp
                [ backgroundSize (px 1200)
                , margin2 (rem 0) (rem -6)
                , backgroundImage (url "/images/illustrations/1024px/homepage_5.png")
                , height (px 280)
                , bottom (px -220)
                ]
            , Theme.Global.withMediaTabletPortraitUp
                [ backgroundImage (url "/images/illustrations/768px/homepage_5.png")
                , backgroundSize (px 900)
                , height (px 200)
                , bottom (px -195)
                , margin2 (rem 0) (rem -2.5)
                ]
            ]
        , Theme.Global.withMediaMediumDesktopUp
            [ marginBottom (px 230), marginTop (px 220) ]
        , Theme.Global.withMediaSmallDesktopUp
            [ marginBottom (px 200) ]
        , Theme.Global.withMediaTabletLandscapeUp
            [ marginTop (px 150), marginBottom (px 150) ]
        , Theme.Global.withMediaTabletPortraitUp
            [ marginTop (px 175), marginBottom (px 175), paddingTop (rem 2), important (paddingBottom (rem 4)) ]
        ]
