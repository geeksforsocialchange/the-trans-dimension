module Theme.Page.Partner exposing (viewInfo)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Copy.Utils exposing (urlToDisplay)
import Css exposing (Style, auto, batch, calc, center, color, displayFlex, fontStyle, important, margin2, margin4, marginBlockEnd, marginBlockStart, marginTop, maxWidth, minus, normal, pct, px, rem, textAlign, width)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Html.Styled exposing (Html, a, address, div, h3, hr, p, section, span, text)
import Html.Styled.Attributes exposing (css, href, id, target)
import Skin.Global exposing (colorSecondary, colorWhite, hrStyle, introTextLargeStyle, linkStyle, mapImage, normalFirstParagraphStyle, smallInlineTitleStyle)
import Theme.GlobalLayout
    exposing
        ( withMediaMediumDesktopUp
        , withMediaTabletLandscapeUp
        , withMediaTabletPortraitUp
        )
import Theme.Page.Events
import Theme.Paginator
import Theme.TransMarkdown
import Time


viewInfo :
    { a
        | filterByDate : Theme.Paginator.Filter
        , filterByRegion : Int
        , nowTime : Time.Posix
    }
    ->
        { partner : Data.PlaceCal.Partners.Partner
        , events : List Data.PlaceCal.Events.Event
        }
    -> Html Theme.Page.Events.Msg
viewInfo localModel { partner, events } =
    section [ css [ margin2 (rem 0) (rem 0.35) ] ]
        [ text ""
        , div [ css [ descriptionStyle ] ]
            (viewPartnerDescription partner.name partner.description partner.summary)
        , hr [ css [ hrStyle ] ] []
        , section [ css [ contactWrapperStyle ] ]
            [ div [ css [ contactSectionStyle ] ]
                [ h3 [ css [ contactHeadingStyle, smallInlineTitleStyle ] ] [ text (t PartnerContactsHeading) ]
                , viewContactDetails partner.maybeUrl partner.maybeContactDetails partner.maybeInstagramUrl
                ]
            , div [ css [ contactSectionStyle ] ]
                [ h3 [ css [ contactHeadingStyle, smallInlineTitleStyle ] ] [ text (t PartnerAddressHeading) ]
                , viewAddress partner.maybeAddress
                ]
            ]
        , hr [ css [ hrStyle ] ] []
        , viewPartnerEvents events localModel partner
        , case partner.maybeGeo of
            Just geo ->
                div [ css [ mapContainerStyle ] ]
                    [ p []
                        [ mapImage
                            (t (MapImageAltText partner.name))
                            { latitude = geo.latitude, longitude = geo.longitude }
                        ]
                    ]

            Nothing ->
                text ""
        ]


viewPartnerEvents :
    List Data.PlaceCal.Events.Event
    ->
        { a
            | filterByDate : Theme.Paginator.Filter
            , filterByRegion : Int
            , nowTime : Time.Posix
        }
    -> Data.PlaceCal.Partners.Partner
    -> Html Theme.Page.Events.Msg
viewPartnerEvents events localModel partner =
    let
        eventAreaTitle =
            h3 [ css [ smallInlineTitleStyle, color colorWhite ] ] [ text (t (PartnerUpcomingEventsText partner.name)) ]

        futureEvents =
            Data.PlaceCal.Events.afterDate events localModel.nowTime
    in
    section [ id "events" ]
        (if List.length futureEvents > 0 then
            -- If we have more than 40 future events paginate
            if List.length futureEvents > 40 then
                [ eventAreaTitle
                , Theme.Paginator.viewPagination localModel |> Html.Styled.map Theme.Page.Events.fromPaginatorMsg
                , Theme.Page.Events.viewEventsList localModel events Nothing
                ]

            else
                -- Otherwise show them all
                [ div []
                    [ Theme.Page.Events.viewEventsList { localModel | filterByDate = Theme.Paginator.Future } events Nothing
                    ]
                ]

         else
            let
                pastEvents =
                    Data.PlaceCal.Events.onOrBeforeDate events localModel.nowTime
            in
            if List.length pastEvents > 0 then
                -- If there are no future events but there were in the past, show them
                [ div []
                    [ h3 [ css [ smallInlineTitleStyle, color colorWhite ] ] [ text (t (PartnerPreviousEventsText partner.name)) ]
                    , Theme.Page.Events.viewEventsList { localModel | filterByDate = Theme.Paginator.None } pastEvents Nothing
                    ]
                ]

            else
                -- This partner has never had events
                [ eventAreaTitle
                , p [ css [ introTextLargeStyle, color colorSecondary, important (maxWidth (px 636)) ] ] [ text (t (PartnerEventsEmptyText partner.name)) ]
                ]
        )


viewContactDetails : Maybe String -> Maybe Data.PlaceCal.Partners.Contact -> Maybe String -> Html msg
viewContactDetails maybeUrl maybeContactDetails maybeInstagramUrl =
    if maybeUrl == Nothing && maybeContactDetails == Nothing && maybeInstagramUrl == Nothing then
        p [ css [ contactItemStyle ] ] [ text (t PartnerContactsEmptyText) ]

    else
        address []
            [ case maybeContactDetails of
                Just contactDetails ->
                    span []
                        [ if String.length contactDetails.telephone > 0 then
                            p [ css [ contactItemStyle ] ] [ text contactDetails.telephone ]

                          else
                            text ""
                        , if String.length contactDetails.email > 0 then
                            p
                                [ css [ contactItemStyle ] ]
                                [ a
                                    [ href ("mailto:" ++ contactDetails.email)
                                    , css [ linkStyle ]
                                    ]
                                    [ text contactDetails.email
                                    ]
                                ]

                          else
                            text ""
                        ]

                Nothing ->
                    text ""
            , case maybeUrl of
                Just url ->
                    p [ css [ contactItemStyle ] ] [ a [ href url, target "_blank", css [ linkStyle ] ] [ text (urlToDisplay url) ] ]

                Nothing ->
                    text ""
            , case maybeInstagramUrl of
                Just url ->
                    p [ css [ contactItemStyle ] ] [ a [ href url, target "_blank", css [ linkStyle ] ] [ text (urlToDisplay url) ] ]

                Nothing ->
                    text ""
            ]


viewAddress : Maybe Data.PlaceCal.Partners.Address -> Html msg
viewAddress maybeAddress =
    case maybeAddress of
        Just addressFields ->
            address []
                [ div [] (String.split ", " addressFields.streetAddress |> List.map (\line -> p [ css [ contactItemStyle ] ] [ text line ]))
                , p [ css [ contactItemStyle ] ]
                    [ text addressFields.postalCode
                    ]
                , p [ css [ contactItemStyle ] ]
                    [ a [ href (t (GoogleMapSearchUrl addressFields.streetAddress)), css [ linkStyle ], target "_blank" ] [ text (t SeeOnGoogleMapText) ] ]
                ]

        Nothing ->
            p [ css [ contactItemStyle ] ] [ text (t PartnerAddressEmptyText) ]


viewPartnerDescription : String -> String -> String -> List (Html msg)
viewPartnerDescription partnerName partnerDescription partnerSummary =
    case ( partnerDescription, partnerSummary ) of
        ( "", "" ) ->
            [ div [] (Theme.TransMarkdown.markdownToHtml (t (PartnerDescriptionEmptyText partnerName))) ]

        ( "", s ) ->
            [ div [] (Theme.TransMarkdown.markdownToHtml s) ]

        ( d, "" ) ->
            [ div [] (Theme.TransMarkdown.markdownToHtml d) ]

        ( d, s ) ->
            [ div [] (Theme.TransMarkdown.markdownToHtml s)
            , div [] (Theme.TransMarkdown.markdownToHtml d)
            ]



---------
-- Styles
---------


descriptionStyle : Style
descriptionStyle =
    batch
        [ normalFirstParagraphStyle
        , withMediaTabletLandscapeUp
            [ margin2 (rem 2) auto
            , maxWidth (px 636)
            ]
        , withMediaTabletPortraitUp
            [ margin2 (rem 2) (rem 2) ]
        ]


contactWrapperStyle : Style
contactWrapperStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex ]
        ]


contactSectionStyle : Style
contactSectionStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 50), marginTop (rem -2) ]
        ]


contactHeadingStyle : Style
contactHeadingStyle =
    batch [ color colorSecondary ]


contactItemStyle : Style
contactItemStyle =
    batch
        [ textAlign center
        , fontStyle normal
        , marginBlockStart (rem 0)
        , marginBlockEnd (rem 0)
        ]


mapContainerStyle : Style
mapContainerStyle =
    batch
        [ margin4 (rem 3) (calc (rem -1.1) minus (px 1)) (calc (rem -0.75) minus (px 1)) (calc (rem -1.1) minus (px 1))
        , withMediaMediumDesktopUp
            [ margin4 (rem 3) (calc (rem -1.85) minus (px 1)) (calc (rem -1.85) minus (px 1)) (calc (rem -1.85) minus (px 1)) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 3) (calc (rem -2.35) minus (px 1)) (px -1) (calc (rem -2.35) minus (px 1)) ]
        ]
