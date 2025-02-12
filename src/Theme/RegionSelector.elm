module Theme.RegionSelector exposing (Msg(..), viewRegionSelector)

import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, active, auto, backgroundColor, batch, borderBox, borderColor, borderRadius, borderStyle, borderWidth, boxSizing, center, color, cursor, displayFlex, fitContent, flexWrap, focus, fontSize, fontWeight, hover, int, justifyContent, listStyleType, margin2, margin4, maxWidth, none, padding4, pointer, position, property, px, relative, rem, solid, textAlign, width, wrap)
import Css.Global exposing (descendants, typeSelector)
import Css.Transitions exposing (transition)
import Data.PlaceCal.Partners
import Html.Styled exposing (Html, button, div, li, text, ul)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events
import Theme.Global exposing (backgroundColorTransition, borderTransition, colorTransition, darkBlue, darkPurple, white, withMediaCanHover, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)


type Msg
    = ClickedSelector Int


viewRegionSelector :
    { localModel
        | filterBy : Int
    }
    -> Html Msg
viewRegionSelector localModel =
    div [ css [ regionSelectorWrapper ] ]
        [ div [ css [ regionSelectorContainer ] ]
            [ ul [ css [ regionSelectorButtonListStyle ] ]
                (List.map
                    (\tagInfo -> viewButton tagInfo (tagInfo.id == localModel.filterBy))
                    ({ id = 0, name = t AllRegionSelectorLabel }
                        :: Data.PlaceCal.Partners.partnershipTagList
                    )
                )
            ]
        ]


viewButton : { id : Int, name : String } -> Bool -> Html Msg
viewButton tagInfo isActive =
    li [ css [ regionSelectorButtonListItemStyle ] ]
        [ button
            [ css
                [ if isActive then
                    regionSelectorButtonListItemButtonActiveStyle

                  else
                    regionSelectorButtonListItemButtonStyle
                ]
            , Html.Styled.Events.onClick (ClickedSelector tagInfo.id)
            ]
            [ text tagInfo.name ]
        ]



-- Styles


numberOfButtons : Float
numberOfButtons =
    List.length Data.PlaceCal.Partners.partnershipTagList
        + 1
        |> toFloat


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
    140


buttonMarginFullWidth : Float
buttonMarginFullWidth =
    8


regionSelectorWrapper : Style
regionSelectorWrapper =
    batch
        [ margin2 (rem 0) (rem -0.5)
        , withMediaSmallDesktopUp [ margin4 (rem 2) (rem -1) (rem 3) (rem -1) ]
        , withMediaTabletLandscapeUp [ margin2 (rem 2) (rem -1) ]
        ]


regionSelectorContainer : Style
regionSelectorContainer =
    batch
        [ displayFlex
        , maxWidth fitContent
        , margin4 (rem 0) auto (rem 0.5) auto
        , withMediaSmallDesktopUp [ margin2 (rem 0) auto ]
        , withMediaTabletLandscapeUp [ margin2 (rem 0) auto ]
        ]


regionSelectorButtonStyle : Style
regionSelectorButtonStyle =
    batch
        [ borderStyle solid
        , borderColor white
        , borderWidth (px 2)
        , color white
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


buttonListStyle : Style
buttonListStyle =
    batch
        [ displayFlex
        , justifyContent center
        , boxSizing borderBox
        , position relative
        , width (px (buttonWidthMobile * numberOfButtons + buttonMarginMobile * (numberOfButtons * 2)))
        , withMediaTabletLandscapeUp
            [ width (px (buttonWidthFullWidth * numberOfButtons + buttonMarginFullWidth * (numberOfButtons * 5))) ]
        , withMediaTabletPortraitUp
            [ width (px (buttonWidthTablet * numberOfButtons + buttonMarginTablet * (numberOfButtons * 2))) ]
        ]


regionSelectorButtonListStyle : Style
regionSelectorButtonListStyle =
    batch
        [ buttonListStyle
        , flexWrap wrap
        ]


regionSelectorButtonListItemStyle : Style
regionSelectorButtonListItemStyle =
    batch
        [ margin2 (rem 0.25) (px buttonMarginMobile)
        , listStyleType none
        , withMediaTabletLandscapeUp [ margin2 (rem 0.25) (rem 0.5) ]
        , withMediaTabletPortraitUp [ margin2 (rem 0.25) (rem 0.375) ]
        ]


regionSelectorButtonListItemButtonStyle : Style
regionSelectorButtonListItemButtonStyle =
    batch
        [ regionSelectorButtonStyle
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , padding4 (rem 0.2) (rem 0.2) (rem 0.3) (rem 0.2)
        , width (px buttonWidthMobile)
        , backgroundColor darkBlue
        , withMediaTabletLandscapeUp [ width (px buttonWidthFullWidth), fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ width (px buttonWidthTablet), fontSize (rem 1) ]
        ]


regionSelectorButtonListItemButtonActiveStyle : Style
regionSelectorButtonListItemButtonActiveStyle =
    batch
        [ regionSelectorButtonStyle
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , padding4 (rem 0.2) (rem 0.2) (rem 0.3) (rem 0.2)
        , width (px buttonWidthMobile)
        , backgroundColor white
        , color darkBlue
        , withMediaTabletLandscapeUp [ width (px buttonWidthFullWidth), fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp [ width (px buttonWidthTablet), fontSize (rem 1) ]
        ]
