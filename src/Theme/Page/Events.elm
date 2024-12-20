module Theme.Page.Events exposing (Msg(..), fromPaginatorMsg, fromRegionSelectorMsg, viewEvents, viewEventsList)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, calc, center, color, column, display, displayFlex, em, firstChild, flexDirection, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, hover, important, int, italic, justifyContent, lastChild, letterSpacing, lineHeight, margin, margin2, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, maxWidth, minus, none, paddingBottom, pct, px, rem, row, rowReverse, solid, spaceBetween, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Events
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h4, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Theme.Global exposing (borderTransition, colorTransition, introTextLargeStyle, pink, white, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.Paginator
import Theme.RegionSelector
import Time


type Msg
    = PaginatorMsg Theme.Paginator.Msg
    | RegionSelectorMsg Theme.RegionSelector.Msg


fromPaginatorMsg : Theme.Paginator.Msg -> Msg
fromPaginatorMsg msg =
    PaginatorMsg msg


fromRegionSelectorMsg : Theme.RegionSelector.Msg -> Msg
fromRegionSelectorMsg msg =
    RegionSelectorMsg msg


viewEvents :
    List Data.PlaceCal.Events.Event
    ->
        { localModel
            | filterByDate : Theme.Paginator.Filter
            , filterByRegion : Int
            , nowTime : Time.Posix
        }
    -> Html Msg
viewEvents eventsList model =
    section [ css [ eventsContainerStyle ] ]
        [ Theme.RegionSelector.viewRegionSelector { filterBy = model.filterByRegion } |> Html.Styled.map fromRegionSelectorMsg
        , Theme.Paginator.viewPagination model |> Html.Styled.map fromPaginatorMsg
        , viewEventsList model eventsList Nothing |> Html.Styled.map fromPaginatorMsg
        ]


viewEventsList :
    { localModel
        | filterByDate : Theme.Paginator.Filter
        , filterByRegion : Int
        , nowTime : Time.Posix
    }
    -> List Data.PlaceCal.Events.Event
    -> Maybe Int
    -> Html msg
viewEventsList localModel eventsList maybeListLength =
    let
        allEventsInRegion : List Data.PlaceCal.Events.Event
        allEventsInRegion =
            Data.PlaceCal.Events.eventsFromRegionId eventsList localModel.filterByRegion

        paginatedEventsInRegion : List Data.PlaceCal.Events.Event
        paginatedEventsInRegion =
            Theme.Paginator.filterEvents localModel.nowTime localModel.filterByDate allEventsInRegion

        filteredEvents : List Data.PlaceCal.Events.Event
        filteredEvents =
            case maybeListLength of
                Nothing ->
                    paginatedEventsInRegion

                Just numberOfEvents ->
                    Data.PlaceCal.Events.nextNEvents numberOfEvents paginatedEventsInRegion localModel.nowTime
    in
    div []
        [ if List.length filteredEvents > 0 then
            ul [ css [ eventsListStyle ] ]
                (List.map (\event -> viewEvent event) filteredEvents)

          else
            p [ css [ introTextLargeStyle, color pink, important (maxWidth (px 636)) ] ]
                [ text
                    (case localModel.filterByDate of
                        Theme.Paginator.Day _ ->
                            t EventsEmptyText

                        Theme.Paginator.Past ->
                            t PreviousEventsEmptyTextAll

                        _ ->
                            t EventsEmptyTextAll
                    )
                ]
        ]


viewEvent : Data.PlaceCal.Events.Event -> Html msg
viewEvent event =
    li [ css [ eventsListItemStyle ] ]
        [ a [ css [ eventLinkStyle ], href (TransRoutes.toAbsoluteUrl (Event event.id)) ]
            [ article [ css [ eventStyle ] ]
                [ div [ css [ eventDescriptionStyle ] ]
                    [ h4 [ css [ eventTitleStyle ] ] [ text event.name ]
                    , div []
                        [ p [ css [ eventParagraphStyle ] ]
                            [ time [] [ text (TransDate.humanTimeFromPosix event.startDatetime) ]
                            , span [] [ text " — " ]
                            , time [] [ text (TransDate.humanTimeFromPosix event.endDatetime) ]
                            ]
                        , case event.location of
                            Just aLocation ->
                                if aLocation.postalCode == "" then
                                    text ""

                                else
                                    p [ css [ eventParagraphStyle ] ] [ text aLocation.postalCode ]

                            Nothing ->
                                text ""
                        , case event.partner.name of
                            Just partnerName ->
                                p [ css [ eventParagraphStyle ] ] [ text ("by " ++ partnerName) ]

                            Nothing ->
                                text ""
                        ]
                    ]
                , div []
                    [ time [ css [ eventDateStyle ] ]
                        [ span [ css [ eventDayStyle ] ]
                            [ text (TransDate.humanDayFromPosix event.startDatetime) ]
                        , span [ css [ eventMonthStyle ] ]
                            [ text (TransDate.humanShortMonthFromPosix event.startDatetime) ]
                        ]
                    ]
                ]
            ]
        ]


eventsContainerStyle : Style
eventsContainerStyle =
    batch
        [ margin2 (rem 1) (rem 0)
        , withMediaTabletPortraitUp [ margin2 (rem 1) (rem 0) ]
        ]


eventsListStyle : Style
eventsListStyle =
    batch
        [ displayFlex
        , flexDirection column
        , withMediaSmallDesktopUp [ margin2 (rem 2) (rem -1) ]
        , withMediaTabletLandscapeUp [ flexDirection row, flexWrap wrap, margin2 (rem 1) (rem -1) ]
        ]


eventsListItemStyle : Style
eventsListItemStyle =
    batch
        [ hover
            [ descendants
                [ typeSelector "a" [ color pink ]
                , typeSelector "h4" [ color pink, borderBottomColor white ]
                , typeSelector "span"
                    [ firstChild [ color pink ]
                    , lastChild [ color white ]
                    ]
                ]
            ]
        , withMediaTabletLandscapeUp [ width (calc (pct 50) minus (rem 2)), margin2 (rem 0) (rem 1) ]
        ]


eventStyle : Style
eventStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , flexDirection rowReverse
        , margin2 (rem 1.25) (rem 0.25)
        , withMediaTabletPortraitUp [ margin2 (rem 1.5) (rem 0) ]
        ]


eventDateStyle : Style
eventDateStyle =
    batch
        [ displayFlex
        , flexDirection column
        , alignItems center
        , marginRight (rem 1)
        ]


eventDayStyle : Style
eventDayStyle =
    batch
        [ color white
        , fontSize (rem 2.5)
        , display block
        , lineHeight (em 1)
        , transition [ colorTransition ]
        , withMediaTabletPortraitUp [ fontSize (rem 3.1222), marginTop (rem -0.75) ]
        ]


eventMonthStyle : Style
eventMonthStyle =
    batch
        [ color pink
        , textTransform uppercase
        , fontSize (rem 1.2)
        , fontWeight (int 900)
        , letterSpacing (px 1.9)
        , transition [ colorTransition ]
        ]


eventDescriptionStyle : Style
eventDescriptionStyle =
    batch
        [ flexGrow (int 1) ]


eventTitleStyle : Style
eventTitleStyle =
    batch
        [ color white
        , fontStyle italic
        , fontSize (rem 1.2)
        , fontWeight (int 500)
        , lineHeight (rem 1.25)
        , paddingBottom (rem 0.5)
        , marginBottom (rem 0.5)
        , borderBottomWidth (px 2)
        , borderBottomColor pink
        , borderBottomStyle solid
        , transition [ colorTransition, borderTransition ]
        , withMediaTabletPortraitUp [ fontSize (rem 1.5), lineHeight (rem 1.877) ]
        ]


eventLinkStyle : Style
eventLinkStyle =
    batch
        [ textDecoration none
        , color white
        , transition [ colorTransition ]
        ]


eventParagraphStyle : Style
eventParagraphStyle =
    batch
        [ marginBlockStart (rem 0)
        , marginBlockEnd (rem 0)
        , margin (rem 0)
        , fontSize (rem 0.8777)
        , withMediaTabletPortraitUp [ fontSize (rem 1.2), lineHeight (rem 1.75) ]
        ]
