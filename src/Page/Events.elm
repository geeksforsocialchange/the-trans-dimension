module Page.Events exposing (Data, Model, Msg, addPartnerNamesToEvents, page, view, viewEventsList)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, backgroundColor, batch, block, bold, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderRadius, boxSizing, calc, center, color, column, display, displayFlex, em, firstChild, flexDirection, flexGrow, flexWrap, fontSize, fontStyle, fontWeight, hover, int, italic, justifyContent, lastChild, letterSpacing, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginRight, marginTop, minus, none, padding2, padding4, paddingBottom, pct, px, rem, row, rowReverse, solid, spaceBetween, sub, textAlign, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (font, transition)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Helpers.TransDate as TransDate
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, article, div, h2, h3, h4, li, p, section, span, text, time, ul)
import Html.Styled.Attributes exposing (css, href)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Theme.Global exposing (blue, darkBlue, darkPurple, pink, purple, white, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.PageTemplate as PageTemplate
import Time
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    List Data.PlaceCal.Events.Event


data : DataSource (List Data.PlaceCal.Events.Event)
data =
    DataSource.map2
        (\eventData partnerData -> addPartnerNamesToEvents eventData.allEvents partnerData.allPartners)
        Data.PlaceCal.Events.eventsData
        Data.PlaceCal.Partners.partnersData


addPartnerNamesToEvents : List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Partners.Partner -> List Data.PlaceCal.Events.Event
addPartnerNamesToEvents events partners =
    List.map
        (\event ->
            { event
                | partner =
                    setPartnerName event.partner (Data.PlaceCal.Partners.partnerNameFromId partners event.partner.id)
            }
        )
        events


setPartnerName : Data.PlaceCal.Events.EventPartner -> Maybe String -> Data.PlaceCal.Events.EventPartner
setPartnerName oldEventPartner partnerName =
    { oldEventPartner | name = partnerName }


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = t SiteTitle
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = t EventsMetaDescription
        , locale = Nothing
        , title = t EventsTitle
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload (List Data.PlaceCal.Events.Event) RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = t EventsTitle
    , body =
        [ PageTemplate.view
            { headerType = Just "pink"
            , title = t EventsTitle
            , bigText = { text = t EventsSummary, node = "h3" }
            , smallText = Nothing
            , innerContent = Just (viewEvents static)
            , outerContent = Just viewSubscribe
            }
        ]
    }


viewEvents : StaticPayload (List Data.PlaceCal.Events.Event) RouteParams -> Html msg
viewEvents events =
    section []
        [ viewEventsFilters
        , viewPagination
        , viewEventsList events.data
        ]


viewEventsFilters : Html msg
viewEventsFilters =
    div [ css [ featurePlaceholderStyle ] ]
        [ text "[fFf] Event filters"
        ]


viewPagination : Html msg
viewPagination =
    div [ css [ featurePlaceholderStyle ] ] [ text "[fFf] Pagination by day/week" ]



-- We might want to move this into theme since it is also used by Partner page


viewEventsList : List Data.PlaceCal.Events.Event -> Html msg
viewEventsList events =
    div []
        [ if List.length events > 0 then
            ul [ css [ eventListStyle ] ] (List.map (\event -> viewEvent event) events)

          else
            text ""
        ]


viewEvent : Data.PlaceCal.Events.Event -> Html msg
viewEvent event =
    li [ css [ eventListItemStyle ] ]
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

                        --, p [ css [ eventParagraphStyle ] ] [ text (Data.PlaceCal.Events.realmToString event.realm) ]
                        , p [ css [ eventParagraphStyle ] ] [ text event.location ]
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


viewSubscribe : Html msg
viewSubscribe =
    div
        [ css [ subscribeBoxStyle ] ]
        [ p
            [ css [ subscribeTextStyle ] ]
            [ a [ css [ subscribeLinkStyle ] ] [ text (t EventsSubscribeText) ] ]

        -- [fFf]
        ]


eventListStyle : Style
eventListStyle =
    batch
        [ displayFlex
        , flexDirection column
        , padding2 (rem 2) (rem 0)
        , withMediaTabletLandscapeUp [ flexDirection row, flexWrap wrap, margin2 (rem 0) (rem -1) ]
        ]


eventListItemStyle : Style
eventListItemStyle =
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
        , transition [ Css.Transitions.color 500 ]
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
        , transition [ Css.Transitions.color 500 ]
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
        , transition [ Css.Transitions.color 500, Css.Transitions.border 500 ]
        , withMediaTabletPortraitUp [ fontSize (rem 1.5), lineHeight (rem 1.877) ]
        ]


eventLinkStyle : Style
eventLinkStyle =
    batch
        [ textDecoration none
        , color white
        , transition [ Css.Transitions.color 500 ]
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


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , backgroundColor darkPurple
        ]


subscribeBoxStyle : Style
subscribeBoxStyle =
    batch
        [ padding2 (rem 0.75) (rem 1.5)
        , backgroundColor darkPurple
        , borderRadius (rem 0.3)
        , margin2 (rem 1.5) (rem 0)
        ]


subscribeTextStyle : Style
subscribeTextStyle =
    batch
        [ textTransform uppercase
        , color pink
        , textAlign center
        , fontSize (rem 1.1)
        , letterSpacing (px 1.9)
        , fontWeight (int 700)
        ]


subscribeLinkStyle : Style
subscribeLinkStyle =
    batch
        [ color pink, textDecoration none ]
