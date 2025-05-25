module Theme.GlobalLayout exposing (backButtonStyle, backgroundColorTransition, baseButtonStyle, borderTransition, buttonFloatingWrapperStyle, colorTransition, containerPage, contentContainerStyle, mapImage, mapImageMulti, maxMobile, maxTabletPortrait, screenReaderOnly, withMediaCanHover, withMediaMediumDesktopUp, withMediaMobileOnly, withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)

import Color
import Css exposing (Color, Style, absolute, active, alignItems, auto, backgroundColor, backgroundImage, backgroundRepeat, backgroundSize, batch, block, borderBottomColor, borderBottomStyle, borderBottomWidth, borderBox, borderColor, borderRadius, borderStyle, borderWidth, bottom, boxSizing, calc, center, color, cursor, display, displayFlex, em, firstChild, fitContent, flexDirection, focus, fontFamilies, fontSize, fontStyle, fontWeight, height, hex, hidden, hover, inlineBlock, int, italic, justifyContent, left, letterSpacing, lineHeight, margin, margin2, margin4, marginBlockEnd, marginBlockStart, marginTop, maxContent, maxWidth, minus, none, outline, overflow, padding, padding2, padding4, paddingBottom, paddingLeft, paddingRight, pct, pointer, position, property, px, relative, rem, repeat, row, sansSerif, solid, textAlign, textDecoration, textTransform, top, uppercase, url, width, zero)
import Css.Global exposing (adjacentSiblings, descendants, global, typeSelector)
import Css.Media as Media exposing (fine, only, screen, withMedia)
import Css.Transitions exposing (Transition, linear, transition)
import Html.Styled exposing (Html, a, div, img, input, label, p, text)
import Html.Styled.Attributes exposing (alt, css, for, href, id, src, type_)
import Html.Styled.Events exposing (onCheck)



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



-- Page Elements


contentContainerStyle : Style
contentContainerStyle =
    batch
        [ margin (rem 0.75)
        , withMediaMediumDesktopUp [ margin (rem 1.5) ]
        , withMediaTabletPortraitUp [ margin2 (rem 0) (rem 2) ]
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
