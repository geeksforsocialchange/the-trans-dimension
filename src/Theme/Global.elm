module Theme.Global exposing (backgroundColorTransition, borderTransition, buttonFloatingWrapperStyle, colorTransition, containerPage, contentContainerStyle, contentWrapperStyle, darkBlue, darkBlueBackgroundStyle, darkBlueButtonStyle, darkBlueRgbColor, darkPurple, globalStyles, hrStyle, introTextLargeStyle, introTextSmallStyle, linkStyle, mapImage, mapImageMulti, maxMobile, maxTabletPortrait, normalFirstParagraphStyle, pink, pinkBackgroundStyle, pinkButtonOnDarkBackgroundStyle, pinkButtonOnLightBackgroundStyle, pinkRgbColor, purple, screenReaderOnly, smallFloatingTitleStyle, smallInlineTitleStyle, textBoxInvisibleStyle, textBoxPinkStyle, textInputErrorStyle, textInputStyle, viewBackButton, viewCheckbox, white, whiteButtonStyle, withMediaCanHover, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)

import Color
import Css exposing (Color, Style, absolute, active, alignItems, auto, backgroundColor, backgroundImage, backgroundRepeat, backgroundSize, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderColor, borderRadius, borderStyle, borderWidth, bottom, boxSizing, calc, center, color, cursor, display, displayFlex, em, firstChild, fitContent, flexDirection, focus, fontFamilies, fontSize, fontStyle, fontWeight, height, hex, hidden, hover, inlineBlock, int, italic, justifyContent, left, letterSpacing, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginTop, maxContent, maxWidth, minus, none, outline, overflow, padding, padding2, padding4, paddingBottom, paddingLeft, paddingRight, pct, pointer, position, property, px, relative, rem, repeat, row, sansSerif, solid, textAlign, textDecoration, textTransform, top, uppercase, url, width, zero)
import Css.Global exposing (adjacentSiblings, descendants, global, typeSelector)
import Css.Media as Media exposing (fine, only, screen, withMedia)
import Css.Transitions exposing (Transition, linear, transition)
import Html.Styled exposing (Html, a, div, img, input, label, p, text)
import Html.Styled.Attributes exposing (alt, css, for, href, id, src, type_)
import Html.Styled.Events exposing (onCheck)



-- Brand colours


darkBlueRgbColor : Color.Color
darkBlueRgbColor =
    Color.rgb255 4 15 57


pinkRgbColor : Color.Color
pinkRgbColor =
    Color.rgb255 255 122 167


darkBlue : Color
darkBlue =
    hex "040F39"


pink : Color
pink =
    hex "FF7AA7"


lightPink : Color
lightPink =
    hex "FFBCD3"


purple : Color
purple =
    hex "814470"


darkPurple : Color
darkPurple =
    hex "432955"


white : Color
white =
    hex "FFFFFF"



-- Accent colours
-- Text and background colours
-- Breakpoints


maxMobile : Float
maxMobile =
    600


withMediaMobileOnly : List Style -> Style
withMediaMobileOnly =
    withMedia [ only screen [ Media.maxWidth (px (maxMobile - 1)) ] ]


withMediaTabletPortraitUp : List Style -> Style
withMediaTabletPortraitUp =
    withMedia [ only screen [ Media.minWidth (px maxMobile) ] ]


maxTabletPortrait : Float
maxTabletPortrait =
    900


withMediaTabletLandscapeUp : List Style -> Style
withMediaTabletLandscapeUp =
    withMedia [ only screen [ Media.minWidth (px maxTabletPortrait) ] ]


maxTabletLandscape : Float
maxTabletLandscape =
    1200


withMediaSmallDesktopUp : List Style -> Style
withMediaSmallDesktopUp =
    withMedia [ only screen [ Media.minWidth (px maxTabletLandscape) ] ]


maxSmallDesktop : Float
maxSmallDesktop =
    1500


withMediaMediumDesktopUp : List Style -> Style
withMediaMediumDesktopUp =
    withMedia [ only screen [ Media.minWidth (px maxSmallDesktop) ] ]


withMediaCanHover : List Style -> Style
withMediaCanHover =
    withMedia [ only screen [ Media.hover Media.canHover, Media.pointer fine ] ]



-- Transitions


borderTransition : Transition
borderTransition =
    Css.Transitions.border3 500 0 linear


colorTransition : Transition
colorTransition =
    Css.Transitions.color3 500 0 linear


backgroundColorTransition : Transition
backgroundColorTransition =
    Css.Transitions.backgroundColor3 500 0 linear



-- Buttons (components)


viewBackButton : String -> String -> Html msg
viewBackButton link buttonText =
    p [ css [ backButtonStyle ] ]
        [ a [ href link, css [ darkBlueButtonStyle ] ] [ text buttonText ] ]



-- Buttons (styles)


buttonFloatingWrapperStyle : Style
buttonFloatingWrapperStyle =
    batch
        [ margin2 (rem 1) auto
        , display block
        , position absolute
        , bottom (rem -2)
        , textAlign center
        , width (pct 100)
        ]


whiteButtonStyle : Style
whiteButtonStyle =
    batch
        [ baseButtonStyle
        , backgroundColor white
        , color darkBlue
        , borderColor white
        , withMediaCanHover [ hover [ backgroundColor purple, color white ] ]
        , active [ backgroundColor darkBlue, color white ]
        , focus [ backgroundColor darkBlue, color white ]
        ]


darkBlueButtonStyle : Style
darkBlueButtonStyle =
    batch
        [ baseButtonStyle
        , backgroundColor darkBlue
        , color white
        , borderColor pink
        , withMediaCanHover [ hover [ backgroundColor purple, color white, borderColor white ] ]
        , active [ backgroundColor pink, color darkBlue, borderColor white ]
        , focus [ backgroundColor pink, color darkBlue, borderColor white ]
        ]


pinkButtonOnDarkBackgroundStyle : Style
pinkButtonOnDarkBackgroundStyle =
    batch
        [ baseButtonStyle
        , backgroundColor pink
        , color darkBlue
        , borderColor pink
        , withMediaCanHover [ hover [ backgroundColor lightPink, borderColor lightPink ] ]
        , active [ backgroundColor white, borderColor white ]
        , focus [ backgroundColor white, borderColor white ]
        ]


pinkButtonOnLightBackgroundStyle : Style
pinkButtonOnLightBackgroundStyle =
    batch
        [ baseButtonStyle
        , backgroundColor pink
        , color darkBlue
        , borderColor pink
        , withMediaCanHover [ hover [ backgroundColor purple, borderColor white, color white ] ]
        , active [ backgroundColor darkBlue, borderColor white, color white ]
        , focus [ backgroundColor darkBlue, borderColor white, color white ]
        ]


baseButtonStyle : Style
baseButtonStyle =
    batch
        [ textDecoration none
        , padding4 (rem 0.375) (rem 1.25) (rem 0.5) (rem 1.25)
        , borderRadius (rem 0.3)
        , fontWeight (int 600)
        , fontSize (rem 1.2)
        , display block
        , textAlign center
        , maxWidth maxContent
        , margin2 (rem 0) auto
        , borderWidth (rem 0.2)
        , borderStyle solid
        , transition [ backgroundColorTransition, borderTransition, colorTransition ]
        ]


backButtonStyle : Style
backButtonStyle =
    batch
        [ textAlign center
        , margin4 (rem 3) (rem 2) (rem 0) (rem 2)
        ]


pinkBackgroundStyle : Style
pinkBackgroundStyle =
    backgroundColor pink


darkBlueBackgroundStyle : Style
darkBlueBackgroundStyle =
    batch
        [ backgroundColor darkBlue
        , borderColor pink
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
        , color white
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


textBoxStyle : Style
textBoxStyle =
    batch
        [ borderRadius (rem 0.3)
        , boxSizing borderBox
        , padding2 (rem 1) (rem 0.75)
        , withMediaMediumDesktopUp
            [ paddingBottom (rem 2) ]
        , withMediaTabletPortraitUp
            [ paddingLeft (rem 1.5), paddingRight (rem 1.5) ]
        ]


textBoxPinkStyle : Style
textBoxPinkStyle =
    batch
        [ textBoxStyle
        , backgroundColor pink
        , color darkBlue
        ]


textBoxInvisibleStyle : Style
textBoxInvisibleStyle =
    batch
        [ backgroundColor darkBlue
        , color pink
        , textBoxStyle
        , paddingBottom (rem 0)
        , descendants
            [ typeSelector "h3" [ batch [ color pink, withMediaTabletLandscapeUp [ margin4 (rem 2) auto (rem 0) auto ] ] ]
            , typeSelector "p" [ batch [ color pink, withMediaTabletLandscapeUp [ margin4 (rem 2) auto (rem 0) auto ] ] ]
            ]
        ]


contentWrapperStyle : Style
contentWrapperStyle =
    batch
        [ borderRadius (rem 0.3)
        , backgroundColor darkBlue
        , borderColor pink
        , borderStyle solid
        , borderWidth (px 1)
        ]


contentContainerStyle : Style
contentContainerStyle =
    batch
        [ margin (rem 0.75)
        , withMediaMediumDesktopUp [ margin (rem 1.5) ]
        , withMediaTabletPortraitUp [ margin2 (rem 0) (rem 2) ]
        ]


hrStyle : Style
hrStyle =
    batch
        [ borderColor pink
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
        , withMediaTabletLandscapeUp
            [ fontSize (rem 2.5), lineHeight (rem 3.1), maxWidth (px 838), margin2 (rem 3) auto ]
        , withMediaTabletPortraitUp
            [ fontSize (rem 1.9), lineHeight (rem 2.1), margin2 (rem 1) (rem 1.5) ]
        ]


introTextSmallStyle : Style
introTextSmallStyle =
    batch
        [ textAlign center
        , margin2 (rem 1.5) (rem 0)
        , withMediaTabletLandscapeUp
            [ fontSize (rem 1.2), margin2 (rem 1.5) (rem 6.5) ]
        , withMediaTabletPortraitUp
            [ margin2 (rem 1.5) (rem 3.5) ]
        ]


linkStyle : Style
linkStyle =
    batch
        [ color white
        , borderBottomColor pink
        , borderBottomStyle solid
        , borderBottomWidth (px 1)
        , textDecoration none
        , withMediaCanHover [ hover [ color pink, borderBottomColor white ] ]
        , transition [ borderTransition, colorTransition ]
        ]


screenReaderOnly : Style
screenReaderOnly =
    batch
        [ position absolute
        , left (px -10000)
        , top auto
        , width (px 1)
        , height (px 1)
        , overflow hidden
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
                        , withMediaSmallDesktopUp [ fontSize (rem 1.2) ]
                        , withMediaTabletPortraitUp [ marginBlockStart (em 0) ]
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
        [ backgroundColor darkBlue
        , borderColor pink
        , borderWidth (px 2)
        , borderStyle solid
        , borderRadius (rem 0.3)
        , padding2 (rem 0.5) (rem 1)
        , color white
        , outline none
        , focus [ borderColor white ]
        ]


textInputErrorStyle : Style
textInputErrorStyle =
    batch
        [ textInputStyle
        , backgroundColor pink
        , color darkBlue
        , borderColor white
        ]


checkboxLabelStyle : Style
checkboxLabelStyle =
    batch
        [ color pink
        , fontWeight (int 500)
        , displayFlex
        , flexDirection row
        , alignItems center
        , justifyContent center
        , margin2 (rem 0) auto
        , position relative
        , cursor pointer
        , maxWidth fitContent
        , withMediaTabletPortraitUp [ maxWidth (pct 100) ]
        , focus [ color white ]
        ]


checkboxLabelCheckedStyle : Style
checkboxLabelCheckedStyle =
    batch
        [ checkboxLabelStyle
        , color white
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
        , backgroundColor darkBlue
        , borderColor pink
        , borderWidth (px 2)
        , borderStyle solid
        , cursor pointer
        , Css.checked
            [ backgroundColor pink
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
            [ backgroundColor darkBlue
            , color white
            , fontFamilies [ "covik-sans", sansSerif.value ]
            , fontWeight (int 400)
            , backgroundImage (url "/images/backgrounds/starfield-small-800.png")
            , backgroundRepeat repeat
            , backgroundSize (px 800)
            , withMediaMediumDesktopUp [ backgroundImage (url "/images/backgrounds/starfield-largest-1920.png"), backgroundSize (px 1920) ]
            , withMediaTabletLandscapeUp [ backgroundImage (url "/images/backgrounds/starfield-medium-1080.png"), backgroundSize (px 1080) ]
            ]
        , typeSelector "h1"
            [ color darkBlue
            ]
        , typeSelector "h2"
            [ color darkBlue
            ]
        , typeSelector "h3"
            [ color darkBlue
            ]
        , typeSelector "h4"
            [ color darkBlue
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
        , withMediaTabletLandscapeUp [ height (px 400) ]
        , borderRadius (rem 0.3)
        ]
