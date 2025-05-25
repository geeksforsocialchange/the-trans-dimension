module Skin.Global exposing (colorAccent, colorAccentDark, colorPrimary, colorPrimaryRgb, colorSecondary, colorSecondaryHexString, colorSecondaryRgb, colorWhite, contentWrapperStyle, globalStyles, hrStyle, introTextLargeStyle, introTextSmallStyle, linkStyle, mapImage, mapImageMulti, normalFirstParagraphStyle, primaryBackgroundStyle, primaryButtonStyle, secondaryBackgroundStyle, secondaryButtonOnDarkBackgroundStyle, secondaryButtonOnLightBackgroundStyle, smallFloatingTitleStyle, smallInlineTitleStyle, textBoxInvisibleStyle, textBoxSecondaryStyle, textInputErrorStyle, textInputStyle, viewBackButton, viewCheckbox, whiteButtonStyle)

import Color
import Css exposing (Color, Style, absolute, active, alignItems, auto, backgroundColor, backgroundImage, backgroundRepeat, backgroundSize, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderColor, borderRadius, borderStyle, borderWidth, bottom, boxSizing, calc, center, color, cursor, display, displayFlex, em, firstChild, fitContent, flexDirection, focus, fontFamilies, fontSize, fontStyle, fontWeight, height, hex, hidden, hover, inlineBlock, int, italic, justifyContent, left, letterSpacing, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginTop, maxContent, maxWidth, minus, none, outline, overflow, padding, padding2, padding4, paddingBottom, paddingLeft, paddingRight, pct, pointer, position, property, px, relative, rem, repeat, row, sansSerif, solid, textAlign, textDecoration, textTransform, top, uppercase, url, width, zero)
import Css.Global exposing (adjacentSiblings, descendants, global, typeSelector)
import Css.Transitions exposing (Transition, linear, transition)
import Html.Styled exposing (Html, a, div, img, input, label, p, text)
import Html.Styled.Attributes exposing (alt, css, for, href, id, src, type_)
import Html.Styled.Events exposing (onCheck)
import Theme.GlobalLayout exposing (withMediaCanHover, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp)



-- Brand colours
-- Primary and Secondary are used as text and background colours on each other.
-- White is also used as text and background
-- So make sure there is sufficient contrast between the three in all combinations.
-- Supply both RGB and Hex values for primary and secondary


colorPrimaryRgb : Color.Color
colorPrimaryRgb =
    Color.rgb255 97 97 97


colorSecondaryRgb : Color.Color
colorSecondaryRgb =
    Color.rgb255 229 229 229


colorSecondaryHexString : String
colorSecondaryHexString =
    "E5E5E5"


colorPrimary : Color
colorPrimary =
    hex "616161"


colorSecondary : Color
colorSecondary =
    hex colorSecondaryHexString


colorSecondaryLight : Color
colorSecondaryLight =
    hex "EFEFEF"


colorAccent : Color
colorAccent =
    hex "C0C2CE"


colorAccentDark : Color
colorAccentDark =
    hex "B2B4C3"


colorWhite : Color
colorWhite =
    hex "FFFFFF"



-- Buttons


viewBackButton : String -> String -> Html msg
viewBackButton link buttonText =
    p [ css [ Theme.GlobalLayout.backButtonStyle ] ]
        [ a [ href link, css [ primaryButtonStyle ] ] [ text buttonText ] ]


whiteButtonStyle : Style
whiteButtonStyle =
    batch
        [ Theme.GlobalLayout.baseButtonStyle
        , backgroundColor colorWhite
        , color colorPrimary
        , borderColor colorWhite
        , withMediaCanHover [ hover [ backgroundColor colorAccent, color colorWhite ] ]
        , active [ backgroundColor colorPrimary, color colorWhite ]
        , focus [ backgroundColor colorPrimary, color colorWhite ]
        ]


primaryButtonStyle : Style
primaryButtonStyle =
    batch
        [ Theme.GlobalLayout.baseButtonStyle
        , backgroundColor colorPrimary
        , color colorWhite
        , borderColor colorSecondary
        , Theme.GlobalLayout.withMediaCanHover [ hover [ backgroundColor colorAccent, color colorWhite, borderColor colorWhite ] ]
        , active [ backgroundColor colorSecondary, color colorPrimary, borderColor colorWhite ]
        , focus [ backgroundColor colorSecondary, color colorPrimary, borderColor colorWhite ]
        ]


secondaryButtonOnDarkBackgroundStyle : Style
secondaryButtonOnDarkBackgroundStyle =
    batch
        [ Theme.GlobalLayout.baseButtonStyle
        , backgroundColor colorSecondary
        , color colorPrimary
        , borderColor colorSecondary
        , withMediaCanHover [ hover [ backgroundColor colorSecondaryLight, borderColor colorSecondaryLight ] ]
        , active [ backgroundColor colorWhite, borderColor colorWhite ]
        , focus [ backgroundColor colorWhite, borderColor colorWhite ]
        ]


secondaryButtonOnLightBackgroundStyle : Style
secondaryButtonOnLightBackgroundStyle =
    batch
        [ Theme.GlobalLayout.baseButtonStyle
        , backgroundColor colorSecondary
        , color colorPrimary
        , borderColor colorSecondary
        , withMediaCanHover [ hover [ backgroundColor colorAccent, borderColor colorWhite, color colorWhite ] ]
        , active [ backgroundColor colorPrimary, borderColor colorWhite, color colorWhite ]
        , focus [ backgroundColor colorPrimary, borderColor colorWhite, color colorWhite ]
        ]


secondaryBackgroundStyle : Style
secondaryBackgroundStyle =
    backgroundColor colorSecondary


primaryBackgroundStyle : Style
primaryBackgroundStyle =
    batch
        [ backgroundColor colorPrimary
        , borderColor colorSecondary
        , borderStyle solid
        , borderWidth (px 1)
        ]



-- Titles


smallTitleStyle : Style
smallTitleStyle =
    batch
        [ textTransform uppercase
        , textAlign center
        , letterSpacing (px 1.9)
        , fontWeight (int 700)
        ]


smallFloatingTitleStyle : Style
smallFloatingTitleStyle =
    batch
        [ smallTitleStyle
        , position absolute
        , top (rem -3)
        , width (calc (pct 100) minus (rem 2))
        , left (rem 1)
        , fontSize (rem 1.2)
        , color colorWhite
        ]


smallInlineTitleStyle : Style
smallInlineTitleStyle =
    batch
        [ smallTitleStyle
        , fontSize (rem 1)
        , marginBlockStart (em 2)
        , marginBlockEnd (em 1.6)
        ]



-- Page Elements


contentWrapperStyle : Style
contentWrapperStyle =
    batch
        [ borderRadius (rem 0.3)
        , backgroundColor colorPrimary
        , borderColor colorSecondary
        , borderStyle solid
        , borderWidth (px 1)
        ]


textBoxStyle : Style
textBoxStyle =
    batch
        [ borderRadius (rem 0.3)
        , boxSizing borderBox
        , padding2 (rem 1) (rem 0.75)
        , withMediaMediumDesktopUp
            [ paddingBottom (rem 2) ]
        , Theme.GlobalLayout.withMediaTabletPortraitUp
            [ paddingLeft (rem 1.5), paddingRight (rem 1.5) ]
        ]


textBoxSecondaryStyle : Style
textBoxSecondaryStyle =
    batch
        [ textBoxStyle
        , backgroundColor colorSecondary
        , color colorPrimary
        ]


textBoxInvisibleStyle : Style
textBoxInvisibleStyle =
    batch
        [ backgroundColor colorPrimary
        , color colorSecondary
        , textBoxStyle
        , paddingBottom (rem 0)
        , descendants
            [ typeSelector "h3" [ batch [ color colorSecondary, Theme.GlobalLayout.withMediaTabletLandscapeUp [ margin4 (rem 2) auto (rem 0) auto ] ] ]
            , typeSelector "p" [ batch [ color colorSecondary, Theme.GlobalLayout.withMediaTabletLandscapeUp [ margin4 (rem 2) auto (rem 0) auto ] ] ]
            ]
        ]


hrStyle : Style
hrStyle =
    batch
        [ borderColor colorSecondary
        , borderStyle solid
        , borderWidth (px 0.5)
        , margin2 (rem 2) (rem 0)
        ]



-- Text styles


introTextLargeStyle : Style
introTextLargeStyle =
    batch
        [ textAlign center
        , fontSize (rem 1.6)
        , lineHeight (rem 2)
        , fontStyle italic
        , fontWeight (int 500)
        , margin2 (rem 1) (rem 0.5)
        , Theme.GlobalLayout.withMediaTabletLandscapeUp
            [ fontSize (rem 2.5), lineHeight (rem 3.1), maxWidth (px 838), margin2 (rem 3) auto ]
        , Theme.GlobalLayout.withMediaTabletPortraitUp
            [ fontSize (rem 1.9), lineHeight (rem 2.1), margin2 (rem 1) (rem 1.5) ]
        ]


introTextSmallStyle : Style
introTextSmallStyle =
    batch
        [ textAlign center
        , margin2 (rem 1.5) (rem 0)
        , Theme.GlobalLayout.withMediaTabletLandscapeUp
            [ fontSize (rem 1.2), margin2 (rem 1.5) (rem 6.5) ]
        , Theme.GlobalLayout.withMediaTabletPortraitUp
            [ margin2 (rem 1.5) (rem 3.5) ]
        ]


linkStyle : Style
linkStyle =
    batch
        [ color colorWhite
        , borderBottomColor colorSecondary
        , borderBottomStyle solid
        , borderBottomWidth (px 1)
        , textDecoration none
        , withMediaCanHover [ hover [ color colorSecondary, borderBottomColor colorWhite ] ]
        , transition [ Theme.GlobalLayout.borderTransition, Theme.GlobalLayout.colorTransition ]
        ]



--- For overriding the markdown style when we don't want it...


normalFirstParagraphStyle : Style
normalFirstParagraphStyle =
    batch
        [ descendants
            [ typeSelector "p"
                [ batch
                    [ firstChild
                        [ fontSize (rem 1)
                        , marginBlockEnd (em 1)
                        , lineHeight (em 1.5)
                        , Theme.GlobalLayout.withMediaSmallDesktopUp [ fontSize (rem 1.2) ]
                        , Theme.GlobalLayout.withMediaTabletPortraitUp [ marginBlockStart (em 0) ]
                        ]
                    ]
                ]
            ]
        ]



-- Form field components


viewCheckbox : String -> String -> Bool -> (Bool -> msg) -> List (Html msg)
viewCheckbox boxId labelText checkedValue update =
    [ label
        [ css
            [ if checkedValue then
                checkboxLabelCheckedStyle

              else
                checkboxLabelStyle
            ]
        , for boxId
        ]
        [ text labelText
        , input [ css [ checkboxStyle ], type_ "checkbox", id boxId, Html.Styled.Attributes.checked checkedValue, onCheck update ] []
        ]
    ]



-- Form field styles


textInputStyle : Style
textInputStyle =
    batch
        [ backgroundColor colorPrimary
        , borderColor colorSecondary
        , borderWidth (px 2)
        , borderStyle solid
        , borderRadius (rem 0.3)
        , padding2 (rem 0.5) (rem 1)
        , color colorWhite
        , outline none
        , focus [ borderColor colorWhite ]
        ]


textInputErrorStyle : Style
textInputErrorStyle =
    batch
        [ textInputStyle
        , backgroundColor colorSecondary
        , color colorPrimary
        , borderColor colorWhite
        ]


checkboxLabelStyle : Style
checkboxLabelStyle =
    batch
        [ color colorSecondary
        , fontWeight (int 500)
        , displayFlex
        , flexDirection row
        , alignItems center
        , justifyContent center
        , margin2 (rem 0) auto
        , position relative
        , cursor pointer
        , maxWidth fitContent
        , Theme.GlobalLayout.withMediaTabletPortraitUp [ maxWidth (pct 100) ]
        , focus [ color colorWhite ]
        ]


checkboxLabelCheckedStyle : Style
checkboxLabelCheckedStyle =
    batch
        [ checkboxLabelStyle
        , color colorWhite
        ]


checkboxStyle : Style
checkboxStyle =
    batch
        [ display inlineBlock
        , property "-webkit-appearance" "none"
        , property "appearance" "none"
        , width (em 1.25)
        , height (em 1.25)
        , margin (em 0.75)
        , padding (em 0.75)
        , backgroundColor colorPrimary
        , borderColor colorSecondary
        , borderWidth (px 2)
        , borderStyle solid
        , cursor pointer
        , Css.checked
            [ backgroundColor colorSecondary
            , borderRadius (em 1)
            ]
        ]



-- Global


{-| Injects a <style> tag into the body, and can target element or
class selectors anywhere, including outside the Elm app.
-}
globalStyles : Html msg
globalStyles =
    global
        [ typeSelector "body"
            [ backgroundColor colorPrimary
            , color colorWhite
            , fontFamilies [ "covik-sans", sansSerif.value ]
            , fontWeight (int 400)
            , backgroundImage (url "/images/backgrounds/background-small-800.png")
            , backgroundRepeat repeat
            , backgroundSize (px 800)
            , Theme.GlobalLayout.withMediaMediumDesktopUp [ backgroundImage (url "/images/backgrounds/background-largest-1920.png"), backgroundSize (px 1920) ]
            , Theme.GlobalLayout.withMediaTabletLandscapeUp [ backgroundImage (url "/images/backgrounds/background-medium-1080.png"), backgroundSize (px 1080) ]
            ]
        , typeSelector "h1"
            [ color colorPrimary
            ]
        , typeSelector "h2"
            [ color colorPrimary
            ]
        , typeSelector "h3"
            [ color colorPrimary
            ]
        , typeSelector "h4"
            [ color colorPrimary
            ]
        , typeSelector "b"
            [ fontWeight (int 700)
            ]
        , typeSelector "p"
            [ adjacentSiblings
                [ typeSelector "p"
                    [ marginTop (rem 1)
                    ]
                ]
            ]
        , typeSelector "blockquote"
            [ adjacentSiblings
                [ typeSelector "blockquote"
                    [ marginTop (rem 1)
                    ]
                ]
            ]
        ]


containerPage : String -> List (Html msg) -> Html msg
containerPage pageTitle content =
    div
        [ id ("page-" ++ generateId pageTitle)
        , css [ margin2 zero auto, width (pct 100), overflow hidden ]
        ]
        content



-- Helpers


generateId : String -> String
generateId input =
    String.trim (String.replace " " "-" (String.toLower input))



-- Map


mapImageMulti :
    String
    -> List { latitude : Maybe String, longitude : Maybe String }
    -> Html msg
mapImageMulti altText markerList =
    img
        [ src
            ("https://api.mapbox.com/styles/v1/studiosquid/cl082tq5a001o14mgaatx9fze/static/"
                ++ String.join ","
                    (List.map (\marker -> "pin-l+ffffff(" ++ marker.longitude ++ "," ++ marker.latitude ++ ")") (removeNullCoords markerList))
                ++ "/auto/1140x400@2x?access_token=pk.eyJ1Ijoic3R1ZGlvc3F1aWQiLCJhIjoiY2o5bzZmNzhvMWI2dTJ3bnQ1aHFnd3loYSJ9.NC3T07dEr_Aw7wo1O8aF-g"
            )
        , alt altText
        , css [ mapStyle ]
        ]
        []


mapImage :
    String
    -> { latitude : Maybe String, longitude : Maybe String }
    -> Html msg
mapImage altText geo =
    if not (markerHasLatAndLong geo) then
        text ""

    else
        mapImageHtml
            ( altText
            , maybeLatLongToLatLongWithDefault0 geo
            )


mapImageHtml : ( String, { latitude : String, longitude : String } ) -> Html msg
mapImageHtml ( altText, geo ) =
    img
        [ src ("https://api.mapbox.com/styles/v1/studiosquid/cl082tq5a001o14mgaatx9fze/static/pin-l+ffffff(" ++ geo.longitude ++ "," ++ geo.latitude ++ ")/" ++ geo.longitude ++ "," ++ geo.latitude ++ ",15,0/1140x400@2x?access_token=pk.eyJ1Ijoic3R1ZGlvc3F1aWQiLCJhIjoiY2o5bzZmNzhvMWI2dTJ3bnQ1aHFnd3loYSJ9.NC3T07dEr_Aw7wo1O8aF-g")
        , alt altText
        , css [ mapStyle ]
        ]
        []


removeNullCoords :
    List { latitude : Maybe String, longitude : Maybe String }
    -> List { latitude : String, longitude : String }
removeNullCoords markerList =
    List.filter (\marker -> markerHasLatAndLong marker) markerList
        |> List.map maybeLatLongToLatLongWithDefault0


markerHasLatAndLong : { latitude : Maybe String, longitude : Maybe String } -> Bool
markerHasLatAndLong markerData =
    not (markerData.latitude == Nothing || markerData.longitude == Nothing)


maybeLatLongToLatLongWithDefault0 :
    { latitude : Maybe String, longitude : Maybe String }
    -> { latitude : String, longitude : String }
maybeLatLongToLatLongWithDefault0 { latitude, longitude } =
    -- Return 0, 0 as coords if there is no data
    { latitude = Maybe.withDefault "0" latitude
    , longitude = Maybe.withDefault "0" longitude
    }


mapStyle : Style
mapStyle =
    batch
        [ height (px 318)
        , width (pct 100)
        , property "object-fit" "cover"
        , Theme.GlobalLayout.withMediaTabletLandscapeUp [ height (px 400) ]
        , borderRadius (rem 0.3)
        ]
