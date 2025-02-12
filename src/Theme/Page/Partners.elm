module Theme.Page.Partners exposing (viewPartners)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, backgroundColor, batch, bold, borderBottomColor, borderBottomStyle, borderBottomWidth, borderRadius, calc, center, color, display, displayFlex, flexEnd, flexWrap, fontSize, fontStyle, fontWeight, hover, inlineBlock, int, italic, justifyContent, letterSpacing, margin2, marginBottom, marginLeft, marginRight, minus, none, padding, padding2, pct, px, rem, solid, spaceBetween, textAlign, textDecoration, textTransform, uppercase, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Partners
import Helpers.TransRoutes as TransRoutes exposing (Route(..))
import Html.Styled exposing (Html, a, div, h3, h4, li, p, section, span, styled, text, ul)
import Html.Styled.Attributes exposing (css, href)
import Theme.Global as Theme exposing (darkPurple, pink, purple, white, withMediaCanHover, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)
import Theme.RegionSelector


viewPartners :
    List Data.PlaceCal.Partners.Partner
    -> { localModel | filterByRegion : Int }
    -> Html Theme.RegionSelector.Msg
viewPartners partnerList model =
    let
        filteredPartnerList =
            Data.PlaceCal.Partners.partnersFromRegionId partnerList model.filterByRegion
    in
    section []
        [ h3 [ css [ partnersListTitleStyle ] ] [ text (t PartnersListHeading) ]
        , if List.length Data.PlaceCal.Partners.partnershipTagList > 1 then
            Theme.RegionSelector.viewRegionSelector { filterBy = model.filterByRegion }

          else
            text ""
        , viewPartnerList filteredPartnerList
        , viewMap filteredPartnerList
        ]


viewPartnerList : List Data.PlaceCal.Partners.Partner -> Html msg
viewPartnerList partners =
    if List.length partners > 0 then
        ul [ css [ listStyle ] ] (List.map (\partner -> viewPartner partner) partners)

    else
        p [] [ text (t PartnersListEmpty) ]


viewPartner : Data.PlaceCal.Partners.Partner -> Html msg
viewPartner partner =
    li [ css [ listItemStyle ] ]
        [ a
            [ href (TransRoutes.toAbsoluteUrl (Partner partner.id))
            , css [ partnerLink ]
            ]
            [ div [ css [ partnerTopRowStyle ] ]
                [ h4 [ css [ partnerNameStyle ] ] [ text partner.name ]
                , viewAreaTag partner.areasServed partner.maybeAddress
                ]
            , div [ css [ partnerBottomRowStyle ] ]
                [ p [ css [ partnerDescriptionStyle ] ]
                    [ text partner.summary
                    ]
                ]
            ]
        ]


viewMap : List Data.PlaceCal.Partners.Partner -> Html msg
viewMap partnerList =
    let
        allowOnlyPartnersWithLocation partner =
            List.isEmpty partner.areasServed && (partner.maybeGeo /= Nothing)

        partnerToGeo partner =
            case partner.maybeGeo of
                Just geo ->
                    geo

                Nothing ->
                    { latitude = Nothing
                    , longitude = Nothing
                    }
    in
    div [ css [ featurePlaceholderStyle ] ]
        [ Theme.mapImageMulti
            (t PartnersMapAltText)
            (List.filter allowOnlyPartnersWithLocation partnerList
                |> List.map partnerToGeo
            )
        ]


viewAreaTag :
    List Data.PlaceCal.Partners.ServiceArea
    -> Maybe Data.PlaceCal.Partners.Address
    -> Html msg
viewAreaTag serviceAreas maybeAddress =
    if List.length serviceAreas > 0 then
        ul [ css [ areaTagStyle ] ]
            (List.map
                (\area ->
                    li []
                        [ partnerAreaTagSpan [] [ text (areaNameString area) ]
                        ]
                )
                serviceAreas
            )

    else
        viewMaybePostalCode maybeAddress


areaNameString : Data.PlaceCal.Partners.ServiceArea -> String
areaNameString serviceArea =
    case serviceArea.abbreviatedName of
        Just shortName ->
            shortName

        Nothing ->
            serviceArea.name


viewMaybePostalCode : Maybe Data.PlaceCal.Partners.Address -> Html msg
viewMaybePostalCode maybeAddress =
    case maybeAddress of
        Just address ->
            partnerAreaTagSpan []
                [ text (areaDistrictString address)
                ]

        Nothing ->
            text ""


areaDistrictString : Data.PlaceCal.Partners.Address -> String
areaDistrictString address =
    String.split " " address.postalCode
        |> List.head
        |> Maybe.withDefault ""



--------------
-- With Styles
--------------


partnerAreaTagSpan : List (Html.Styled.Attribute msg) -> List (Html msg) -> Html msg
partnerAreaTagSpan =
    styled span
        [ backgroundColor darkPurple
        , color pink
        , display inlineBlock
        , marginLeft (rem 0.5)
        , padding2 (rem 0.25) (rem 0.5)
        , borderRadius (rem 0.3)
        , fontWeight (int 600)
        , fontSize (rem 0.877777)
        ]



---------
-- Styles
---------


partnersListTitleStyle : Style
partnersListTitleStyle =
    batch
        [ color white
        , textTransform uppercase
        , fontSize (rem 1.2)
        , letterSpacing (px 1.9)
        , textAlign center
        , margin2 (rem 2) (rem 1)
        , withMediaTabletLandscapeUp [ marginBottom (rem 0) ]
        ]


listStyle : Style
listStyle =
    batch
        [ padding2 (rem 0) (rem 0.5)
        , withMediaSmallDesktopUp [ padding (rem 0) ]
        , withMediaTabletLandscapeUp [ displayFlex, flexWrap wrap, padding2 (rem 0) (rem 2) ]
        ]


listItemStyle : Style
listItemStyle =
    batch
        [ withMediaCanHover
            [ hover
                [ descendants
                    [ typeSelector "a" [ color pink ]
                    , typeSelector "h4" [ color pink ]
                    , typeSelector "div" [ borderBottomColor white ]
                    ]
                ]
            ]
        , withMediaTabletLandscapeUp [ width (calc (pct 50) minus (rem 2)) ]
        , withMediaTabletPortraitUp [ margin2 (rem 1.5) (rem 1) ]
        ]


partnerTopRowStyle : Style
partnerTopRowStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , alignItems flexEnd
        , padding2 (rem 0.5) (rem 0)
        , borderBottomColor pink
        , borderBottomWidth (px 2)
        , borderBottomStyle solid
        , withMediaTabletLandscapeUp [ padding2 (rem 0.75) (rem 0) ]
        , transition [ Theme.borderTransition ]
        ]


partnerBottomRowStyle : Style
partnerBottomRowStyle =
    batch
        [ displayFlex
        , justifyContent spaceBetween
        , padding2 (rem 0.5) (rem 0)
        , withMediaTabletLandscapeUp [ padding2 (rem 0.75) (rem 0) ]
        ]


partnerLink : Style
partnerLink =
    batch
        [ textDecoration none
        , color white
        , transition [ Theme.colorTransition ]
        ]


partnerNameStyle : Style
partnerNameStyle =
    batch
        [ fontSize (rem 1.2)
        , fontStyle italic
        , color white
        , transition [ Theme.colorTransition ]
        , withMediaTabletPortraitUp [ fontSize (rem 1.5) ]
        ]


partnerDescriptionStyle : Style
partnerDescriptionStyle =
    batch
        [ fontSize (rem 0.8777)
        , marginRight (rem 1)
        , withMediaTabletPortraitUp [ fontSize (rem 1.2) ]
        ]


areaTagStyle : Style
areaTagStyle =
    batch
        [ displayFlex
        ]


featurePlaceholderStyle : Style
featurePlaceholderStyle =
    batch
        [ textAlign center
        , fontWeight bold
        , marginBottom (rem 2)
        , backgroundColor purple
        ]
