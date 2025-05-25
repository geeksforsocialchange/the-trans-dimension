module Theme.Page.Event exposing (viewButtons, viewEventInfo)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Copy.Utils exposing (isValidUrl, urlToDisplay)
import Css exposing (Style, auto, batch, calc, center, color, displayFlex, em, fontSize, fontStyle, fontWeight, int, justifyContent, letterSpacing, margin2, margin4, marginBlockEnd, marginBlockStart, marginBottom, marginTop, maxWidth, minus, normal, pct, px, rem, textAlign, textTransform, uppercase, width)
import Data.PlaceCal.Events
import Helpers.TransDate
import Helpers.TransRoutes
import Html.Styled exposing (Html, a, div, h4, hr, p, section, text, time)
import Html.Styled.Attributes exposing (css, href, target)
import Skin.Global exposing (colorSecondary, hrStyle, linkStyle, mapImage, normalFirstParagraphStyle, smallInlineTitleStyle, viewBackButton)
import Theme.GlobalLayout exposing (withMediaMediumDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.TransMarkdown


viewEventInfo : Data.PlaceCal.Events.Event -> Html msg
viewEventInfo event =
    div []
        [ viewDateTimeSection event
        , hr [ css [ hrStyle ] ] []
        , viewInfoSection event
        , hr [ css [ hrStyle, marginTop (rem 2.5) ] ] []
        , viewAddressSection event
        , case event.maybeGeo of
            Just geo ->
                div [ css [ mapContainerStyle ] ]
                    [ p []
                        [ mapImage
                            (t (MapImageAltText event.name))
                            { latitude = geo.latitude, longitude = geo.longitude }
                        ]
                    ]

            Nothing ->
                div [ css [ mapContainerStyle ] ] [ text "" ]
        , publisherUrlSection event
        ]


viewDateTimeSection : Data.PlaceCal.Events.Event -> Html msg
viewDateTimeSection event =
    section [ css [ dateAndTimeStyle ] ]
        [ p [ css [ dateStyle ] ] [ time [] [ text (Helpers.TransDate.humanDateFromPosix event.startDatetime) ] ]
        , p [ css [ timeStyle ] ] [ time [] [ text (Helpers.TransDate.humanTimeFromPosix event.startDatetime), text " - ", text (Helpers.TransDate.humanTimeFromPosix event.endDatetime) ] ]
        ]


viewInfoSection : Data.PlaceCal.Events.Event -> Html msg
viewInfoSection event =
    section [ css [ infoSectionStyle ] ]
        [ div []
            [ case event.partner.name of
                Just name ->
                    p [ css [ eventPartnerStyle ] ] [ a [ css [ linkStyle ], href (Helpers.TransRoutes.toAbsoluteUrl (Helpers.TransRoutes.Partner event.partner.id)) ] [ text ("By " ++ name) ] ]

                Nothing ->
                    text ""
            ]
        , div [ css [ eventDescriptionStyle ] ]
            (Theme.TransMarkdown.markdownToHtml event.description)
        ]


viewAddressSection : Data.PlaceCal.Events.Event -> Html msg
viewAddressSection event =
    section [ css [ addressSectionStyle ] ]
        [ div [ css [ addressItemStyle ] ]
            [ h4 [ css [ addressItemTitleStyle ] ] [ text "Contact Information " ]
            , case event.partner.maybeContactDetails of
                Just contact ->
                    div []
                        [ if contact.telephone /= "" then
                            p [ css [ contactItemStyle ] ] [ text contact.telephone ]

                          else
                            text ""
                        , if contact.email /= "" then
                            p [ css [ contactItemStyle ] ] [ a [ href ("mailto:" ++ contact.email), css [ linkStyle ] ] [ text contact.email ] ]

                          else
                            text ""
                        ]

                Nothing ->
                    text ""
            , case event.partner.maybeUrl of
                Just url ->
                    if isValidUrl url then
                        p [ css [ contactItemStyle ] ]
                            [ a [ href url, target "_blank", css [ linkStyle ] ]
                                [ text (urlToDisplay url) ]
                            ]

                    else
                        text ""

                Nothing ->
                    text ""
            ]
        , div [ css [ addressItemStyle ] ]
            [ h4 [ css [ addressItemTitleStyle ] ] [ text "Event Address" ]
            , case event.location of
                Just aLocation ->
                    if aLocation.streetAddress == "" then
                        text ""

                    else
                        div [] (String.split ", " aLocation.streetAddress |> List.map (\line -> p [ css [ contactItemStyle ] ] [ text line ]))

                Nothing ->
                    text ""
            , case event.location of
                Just aLocation ->
                    if aLocation.postalCode == "" then
                        text ""

                    else
                        p [ css [ contactItemStyle ] ] [ text aLocation.postalCode ]

                Nothing ->
                    text ""
            ]
        ]


viewButtons : Data.PlaceCal.Events.Event -> Html msg
viewButtons event =
    section [ css [ buttonsStyle ] ]
        [ viewBackButton
            (Helpers.TransRoutes.toAbsoluteUrl (Helpers.TransRoutes.Partner event.partner.id) ++ "#events")
            (t (BackToPartnerEventsLinkText event.partner.name))
        , viewBackButton
            (Helpers.TransRoutes.toAbsoluteUrl Helpers.TransRoutes.Events)
            (t BackToEventsLinkText)
        ]


publisherUrlSection : Data.PlaceCal.Events.Event -> Html msg
publisherUrlSection event =
    case event.maybePublisherUrl of
        Just publisherUrl ->
            if isValidUrl publisherUrl then
                div [ css [ publisherSectionStyle ] ]
                    [ hr [ css [ hrStyle, marginTop (rem 2.5) ] ] []
                    , a [ href publisherUrl, css [ linkStyle ] ] [ text (t (EventVisitPublisherUrlText event.partner.name)) ]
                    ]

            else
                text ""

        Nothing ->
            text ""


dateAndTimeStyle : Style
dateAndTimeStyle =
    batch
        [ withMediaTabletPortraitUp
            [ margin2 (rem 2) (rem 0) ]
        , margin4 (rem 2) (rem 0) (rem 1) (rem 0)
        ]


dateStyle : Style
dateStyle =
    batch
        [ fontSize (rem 1.8)
        , textAlign center
        , marginBlockEnd (rem 0)
        , textTransform uppercase
        , fontWeight (int 900)
        , marginBottom (rem -0.5)
        ]


timeStyle : Style
timeStyle =
    batch
        [ fontSize (rem 1.2)
        , fontWeight (int 600)
        , textAlign center
        , textTransform uppercase
        , letterSpacing (px 1.9)
        , color colorSecondary
        , marginBlockStart (em 0)
        ]


infoSectionStyle : Style
infoSectionStyle =
    batch
        [ withMediaTabletLandscapeUp [ maxWidth (px 636), margin2 (rem 0) auto ]
        , withMediaTabletPortraitUp [ margin2 (rem 0) (rem 2) ]
        ]


eventPartnerStyle : Style
eventPartnerStyle =
    batch
        [ fontSize (rem 1.2)
        , textAlign center
        ]


eventDescriptionStyle : Style
eventDescriptionStyle =
    batch
        [ normalFirstParagraphStyle
        , withMediaTabletLandscapeUp
            [ margin2 (rem 2) auto
            , maxWidth (px 636)
            ]
        , withMediaTabletPortraitUp
            [ margin2 (rem 2) (rem 2) ]
        ]


addressSectionStyle : Style
addressSectionStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex ]
        ]


addressItemStyle : Style
addressItemStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 50) ]
        ]


addressItemTitleStyle : Style
addressItemTitleStyle =
    batch
        [ color colorSecondary
        , smallInlineTitleStyle
        , withMediaTabletPortraitUp [ marginTop (rem 1) ]
        ]


contactItemStyle : Style
contactItemStyle =
    batch
        [ textAlign center
        , fontStyle normal
        , marginBlockStart (em 0)
        , marginBlockEnd (em 0)
        ]


buttonsStyle : Style
buttonsStyle =
    batch
        [ withMediaTabletPortraitUp
            [ displayFlex, justifyContent center ]
        ]


mapContainerStyle : Style
mapContainerStyle =
    batch
        [ margin4 (rem 3) (calc (rem -1.1) minus (px 1)) (calc (rem -0.75) minus (px 1)) (calc (rem -1.1) minus (px 1))
        , withMediaMediumDesktopUp
            [ margin4 (rem 3) (calc (rem -1.5) minus (px 1)) (calc (rem -1.5) minus (px 1)) (calc (rem -1.5) minus (px 1)) ]
        , withMediaTabletPortraitUp
            [ margin4 (rem 3) (calc (rem -2) minus (px 1)) (px -1) (calc (rem -2) minus (px 1)) ]
        ]


publisherSectionStyle : Style
publisherSectionStyle =
    batch
        [ textAlign center
        , marginBottom (rem 2)
        ]
