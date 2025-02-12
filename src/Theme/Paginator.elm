module Theme.Paginator exposing (Filter(..), Msg(..), ScrollDirection(..), buttonWidthFullWidth, buttonWidthMobile, buttonWidthTablet, filterEvents, paginationButtonStyle, scrollPagination, viewPagination)

import Browser.Dom exposing (Error, Viewport, getViewportOf, setViewportOf)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, active, auto, backgroundColor, batch, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, center, color, cursor, deg, display, displayFlex, fitContent, flexWrap, focus, fontSize, fontWeight, height, hover, important, int, justifyContent, listStyleType, margin, margin2, margin4, maxWidth, noWrap, none, overflowX, padding2, padding4, paddingLeft, paddingRight, pct, pointer, position, property, pseudoElement, px, relative, rem, rotate, scroll, solid, textAlign, transform, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Events
import Helpers.TransDate as TransDate
import Html.Styled exposing (Html, button, div, img, li, text, ul)
import Html.Styled.Attributes exposing (css, id, src)
import Html.Styled.Events
import Task exposing (Task)
import Theme.Global exposing (backgroundColorTransition, borderTransition, colorTransition, darkBlue, darkPurple, pink, white, withMediaCanHover, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Time


type Filter
    = Day Time.Posix
    | Past
    | Future
    | None
    | Unknown


type Msg
    = ClickedDay Time.Posix
    | ClickedAllPastEvents
    | ClickedAllFutureEvents
    | GetTime Time.Posix
    | GotViewport Viewport
    | ScrollRight
    | ScrollLeft
    | NoOp


type ScrollDirection
    = Right
    | Left


viewPagination :
    { localModel
        | filterByDate : Filter
        , nowTime : Time.Posix
    }
    -> Html Msg
viewPagination localModel =
    div [ css [ paginationWrapper ] ]
        [ div [ css [ paginationContainer ] ]
            [ button [ css [ paginationArrowButtonStyle ], Html.Styled.Events.onClick ScrollLeft ] [ img [ src "/images/icons/leftarrow.svg", css [ paginationArrowStyle ] ] [] ]
            , div [ css [ paginationScrollableBoxStyle ], id "scrollable" ]
                [ ul [ css [ paginationButtonListStyle ] ]
                    (List.map
                        (\( label, buttonTime ) ->
                            li [ css [ paginationButtonListItemStyle ] ]
                                [ button
                                    [ css
                                        [ case localModel.filterByDate of
                                            Day day ->
                                                if TransDate.isSameDay buttonTime day then
                                                    paginationButtonListItemButtonActiveStyle

                                                else
                                                    paginationButtonListItemButtonStyle

                                            _ ->
                                                paginationButtonListItemButtonStyle
                                        ]
                                    , Html.Styled.Events.onClick (ClickedDay buttonTime)
                                    ]
                                    [ text label ]
                                ]
                        )
                        (todayTomorrowNext5DaysPosix localModel.nowTime)
                    )
                ]
            , button [ css [ paginationArrowButtonRightStyle ], id "arrow-right", Html.Styled.Events.onClick ScrollRight ] [ img [ src "/images/icons/rightarrow.svg", css [ paginationRightArrowStyle ] ] [] ]
            ]
        , div [ css [ paginationContainer ] ]
            [ ul [ css [ allEventsButtonListStyle ] ]
                [ li [ css [ allEventsButtonListItemStyle ] ]
                    [ button
                        [ css
                            (if localModel.filterByDate == Past then
                                [ important (width (px 200)), paginationButtonListItemButtonActiveStyle ]

                             else
                                [ important (width (px 200)), paginationButtonListItemButtonStyle ]
                            )
                        , Html.Styled.Events.onClick ClickedAllPastEvents
                        ]
                        [ text (t EventsFilterLabelAllPast) ]
                    ]
                , li [ css [ allEventsButtonListItemStyle ] ]
                    [ button
                        [ css
                            (if localModel.filterByDate == Future then
                                [ important (width (px 200)), paginationButtonListItemButtonActiveStyle ]

                             else
                                [ important (width (px 200)), paginationButtonListItemButtonStyle ]
                            )
                        , Html.Styled.Events.onClick ClickedAllFutureEvents
                        ]
                        [ text (t EventsFilterLabelAllFuture) ]
                    ]
                ]
            ]
        ]


filterEvents : Time.Posix -> Filter -> List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Events.Event
filterEvents now filter eventList =
    case filter of
        Day time ->
            Data.PlaceCal.Events.eventsOnDate eventList time

        Past ->
            List.reverse (Data.PlaceCal.Events.onOrBeforeDate eventList now)

        Future ->
            Data.PlaceCal.Events.afterDate eventList now

        None ->
            eventList

        Unknown ->
            eventList


todayTomorrowNext5DaysPosix : Time.Posix -> List ( String, Time.Posix )
todayTomorrowNext5DaysPosix now =
    [ ( t EventsFilterLabelToday, now )
    , ( t EventsFilterLabelTomorrow, addDays 1 now )
    ]
        ++ List.map
            (\days ->
                ( TransDate.humanDayDateMonthFromPosix (addDays days now), addDays days now )
            )
            [ 2, 3, 4, 5, 6 ]


addDays : Int -> Time.Posix -> Time.Posix
addDays days now =
    (days * 24 * 60 * 60 * 1000)
        + Time.posixToMillis now
        |> Time.millisToPosix


scrollPagination : ScrollDirection -> Float -> Task Error ()
scrollPagination direction viewportWidth =
    getViewportOf "scrollable"
        |> Task.andThen
            (\info ->
                let
                    scrollXAmount : Float
                    scrollXAmount =
                        if viewportWidth < Theme.Global.maxMobile then
                            buttonWidthMobile + (buttonMarginMobile * 2)

                        else if viewportWidth < Theme.Global.maxTabletPortrait then
                            buttonWidthTablet + (buttonMarginTablet * 2)

                        else
                            buttonWidthFullWidth + (buttonMarginFullWidth * 2)

                    scrollXValue : Float
                    scrollXValue =
                        case direction of
                            Right ->
                                scrollXAmount

                            Left ->
                                -scrollXAmount
                in
                scrollX scrollXValue info.viewport.x
            )


scrollX : Float -> Float -> Task Error ()
scrollX scrollRemaining viewportXPosition =
    let
        pixelsLeftToMove : Int
        pixelsLeftToMove =
            round (posOrNeg scrollRemaining * scrollRemaining)
    in
    if pixelsLeftToMove < 6 then
        getViewportOf "scrollable"
            |> Task.andThen (\_ -> setViewportOf "scrollable" (viewportXPosition + scrollRemaining) 0)

    else
        getViewportOf "scrollable"
            |> Task.andThen (\_ -> setViewportOf "scrollable" (viewportXPosition + posOrNeg scrollRemaining * 5) 0)
            |> Task.andThen (\_ -> scrollX (scrollRemaining - posOrNeg scrollRemaining * 5) (viewportXPosition + posOrNeg scrollRemaining * 5))


posOrNeg : Float -> Float
posOrNeg numToTest =
    toFloat
        (if numToTest > 0 then
            1

         else
            -1
        )



-- Styles


numberOfButtons : Float
numberOfButtons =
    7


buttonWidthMobile : Float
buttonWidthMobile =
    100


buttonMarginMobile : Float
buttonMarginMobile =
    4


buttonWidthTablet : Float
buttonWidthTablet =
    110


buttonMarginTablet : Float
buttonMarginTablet =
    6


buttonWidthFullWidth : Float
buttonWidthFullWidth =
    130


buttonMarginFullWidth : Float
buttonMarginFullWidth =
    8


paginationWrapper : Style
paginationWrapper =
    batch
        [ margin2 (rem 0) (rem -0.5)
        , withMediaSmallDesktopUp [ margin4 (rem 2) (rem -1) (rem 3) (rem -1) ]
        , withMediaTabletLandscapeUp [ margin2 (rem 2) (rem -1) ]
        ]


paginationContainer : Style
paginationContainer =
    batch
        [ displayFlex
        , maxWidth fitContent
        , margin4 (rem 0) auto (rem 0.5) auto
        , withMediaSmallDesktopUp [ margin2 (rem 0) auto ]
        , withMediaTabletLandscapeUp [ margin2 (rem 0) auto ]
        ]


paginationScrollableBoxStyle : Style
paginationScrollableBoxStyle =
    batch
        [ width (px (buttonWidthMobile * 2 + buttonMarginMobile * 4))
        , position relative
        , overflowX scroll
        , pseudoElement "-webkit-scrollbar" [ display none ]
        , property "-ms-overflow-style" "none"
        , property "scrollbar-width" "none"
        , property "scroll-behaviour" "smooth"
        , withMediaSmallDesktopUp [ width (pct 100) ]
        , withMediaTabletLandscapeUp [ width (px (buttonWidthFullWidth * 5 + buttonMarginFullWidth * 10)) ]
        , withMediaTabletPortraitUp [ width (px (buttonWidthTablet * 4 + buttonMarginTablet * 8)) ]
        ]


paginationButtonStyle : Style
paginationButtonStyle =
    batch
        [ borderStyle solid
        , borderColor pink
        , borderWidth (px 2)
        , color pink
        , borderRadius (rem 0.3)
        , textAlign center
        , cursor pointer
        , withMediaCanHover
            [ hover
                [ backgroundColor darkPurple
                , color white
                , borderColor white
                , descendants [ typeSelector "img" [ property "filter" "invert(1)" ] ]
                ]
            ]
        , focus
            [ backgroundColor white
            , color darkBlue
            , borderColor white
            , descendants [ typeSelector "img" [ property "filter" "invert(0)" ] ]
            ]
        , active
            [ backgroundColor white
            , color darkBlue
            , borderColor white
            , descendants [ typeSelector "img" [ property "filter" "invert(0)" ] ]
            ]
        , transition [ colorTransition, borderTransition, backgroundColorTransition ]
        ]


paginationArrowButtonStyle : Style
paginationArrowButtonStyle =
    batch
        [ paginationButtonStyle
        , backgroundColor pink
        , margin4 (rem 0.25) (rem 0.25) (rem 0.25) (rem 0)
        , paddingRight (rem 0.5)
        , withMediaSmallDesktopUp [ display none ]
        , withMediaTabletLandscapeUp
            [ padding2 (rem 0) (rem 0.5), margin2 (rem 0.25) (rem 0.75) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 0.25) (rem 0.5) (rem 0.25) (rem 0) ]
        ]


paginationArrowButtonRightStyle : Style
paginationArrowButtonRightStyle =
    batch
        [ paginationButtonStyle
        , backgroundColor pink
        , margin4 (rem 0.25) (rem 0) (rem 0.25) (rem 0.25)
        , paddingLeft (rem 0.5)
        , withMediaSmallDesktopUp [ display none ]
        , withMediaTabletLandscapeUp
            [ padding2 (rem 0) (rem 0.5), margin2 (rem 0.25) (rem 0.75) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 0.25) (rem 0) (rem 0.25) (rem 0.5) ]
        ]


paginationArrowStyle : Style
paginationArrowStyle =
    batch
        [ width (px 13)
        , height (px 11)
        , withMediaTabletPortraitUp [ width (px 18), height (px 15) ]
        ]


paginationRightArrowStyle : Style
paginationRightArrowStyle =
    batch
        [ paginationArrowStyle
        , transform (rotate (deg 180))
        ]


buttonListStyle : Style
buttonListStyle =
    batch
        [ displayFlex
        , justifyContent center
        , boxSizing borderBox
        , position relative
        , width (px (buttonWidthMobile * numberOfButtons + buttonMarginMobile * (numberOfButtons * 2)))
        , withMediaTabletLandscapeUp
            [ width (px (buttonWidthFullWidth * numberOfButtons + buttonMarginFullWidth * (numberOfButtons * 2))) ]
        , withMediaTabletPortraitUp
            [ width (px (buttonWidthTablet * numberOfButtons + buttonMarginTablet * (numberOfButtons * 2))) ]
        ]


paginationButtonListStyle : Style
paginationButtonListStyle =
    batch
        [ buttonListStyle
        , flexWrap noWrap
        ]


allEventsButtonListStyle : Style
allEventsButtonListStyle =
    batch
        [ buttonListStyle
        , flexWrap wrap
        ]


paginationButtonListItemStyle : Style
paginationButtonListItemStyle =
    batch
        [ margin2 (rem 0.25) (px buttonMarginMobile)
        , listStyleType none
        , withMediaTabletLandscapeUp [ margin2 (rem 0.25) (rem 0.5) ]
        , withMediaTabletPortraitUp [ margin2 (rem 0.25) (rem 0.375) ]
        ]


allEventsButtonListItemStyle : Style
allEventsButtonListItemStyle =
    batch
        [ listStyleType none
        , textAlign center
        , margin (rem 0.5)
        ]


paginationButtonListItemButtonStyle : Style
paginationButtonListItemButtonStyle =
    batch
        [ paginationButtonStyle
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , padding4 (rem 0.2) (rem 0.2) (rem 0.3) (rem 0.2)
        , width (px buttonWidthMobile)
        , backgroundColor darkBlue
        , withMediaTabletLandscapeUp [ width (px buttonWidthFullWidth), fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ width (px buttonWidthTablet), fontSize (rem 1) ]
        ]


paginationButtonListItemButtonActiveStyle : Style
paginationButtonListItemButtonActiveStyle =
    batch
        [ paginationButtonStyle
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , padding4 (rem 0.2) (rem 0.2) (rem 0.3) (rem 0.2)
        , width (px buttonWidthMobile)
        , backgroundColor pink
        , color darkBlue
        , withMediaTabletLandscapeUp [ width (px buttonWidthFullWidth), fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ width (px buttonWidthTablet), fontSize (rem 1) ]
        ]
