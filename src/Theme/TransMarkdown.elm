module Theme.TransMarkdown exposing (fromResult, markdownBlocksToHtml, markdownToBlocks, markdownToHtml)

import Css exposing (Style, absolute, batch, before, center, color, decimal, em, firstChild, fontSize, fontWeight, int, left, lineHeight, listStyle, listStyleType, marginBlockEnd, marginBlockStart, none, paddingLeft, position, property, relative, rem, textAlign, top)
import Html.Styled as Html
import Html.Styled.Attributes as Attr exposing (class, css)
import Json.Decode
import Markdown.Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Skin.Global exposing (colorSecondary, linkStyle)
import Theme.GlobalLayout exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp)


fromResult : Result String value -> Json.Decode.Decoder value
fromResult result =
    case result of
        Ok okValue ->
            Json.Decode.succeed okValue

        Err error ->
            Json.Decode.fail error


markdownToHtml : String -> List (Html.Html msg)
markdownToHtml markdown =
    case markdownToView markdown of
        Ok html ->
            html

        Err _ ->
            []


markdownBlocksToHtml : List Markdown.Block.Block -> List (Html.Html msg)
markdownBlocksToHtml markdownBlocks =
    case markdownBlocksToView markdownBlocks of
        Ok html ->
            html

        Err _ ->
            []


markdownToBlocks : String -> Result String (List Markdown.Block.Block)
markdownToBlocks markdownString =
    markdownString
        |> Markdown.Parser.parse
        |> Result.mapError (\_ -> "Markdown error.")


markdownBlocksToView : List Markdown.Block.Block -> Result String (List (Html.Html msg))
markdownBlocksToView markdownBlocks =
    Markdown.Renderer.render
        transHtmlRenderer
        markdownBlocks


markdownToView : String -> Result String (List (Html.Html msg))
markdownToView markdownString =
    markdownToBlocks markdownString
        |> Result.andThen
            (\blocks ->
                Markdown.Renderer.render
                    transHtmlRenderer
                    blocks
            )


transHtmlRenderer : Markdown.Renderer.Renderer (Html.Html msg)
transHtmlRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Markdown.Block.H1 ->
                    Html.h1 [ css [ headerStyle ] ] children

                Markdown.Block.H2 ->
                    Html.h2 [ css [ headerStyle, h2Style ] ] children

                Markdown.Block.H3 ->
                    Html.h3 [ css [ headerStyle ] ] children

                Markdown.Block.H4 ->
                    Html.h4 [ css [ headerStyle ] ] children

                Markdown.Block.H5 ->
                    Html.h5 [ css [ headerStyle ] ] children

                Markdown.Block.H6 ->
                    Html.h6 [ css [ headerStyle ] ] children
    , paragraph = Html.p [ css [ paragraphStyle ] ]
    , hardLineBreak = Html.br [] []
    , strikethrough =
        \children -> Html.s [] children
    , blockQuote = Html.blockquote []
    , strong =
        \children -> Html.strong [] children
    , emphasis =
        \children -> Html.em [] children
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Attr.href link.destination
                        , Attr.title title
                        , css [ linkStyle ]
                        ]
                        content

                Nothing ->
                    Html.a [ Attr.href link.destination, css [ linkStyle ] ] content
    , image =
        \imageInfo ->
            case imageInfo.title of
                Just title ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        , Attr.title title
                        ]
                        []

                Nothing ->
                    Html.img
                        [ Attr.src imageInfo.src
                        , Attr.alt imageInfo.alt
                        ]
                        []
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul [ css [ ulStyle ] ]
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Markdown.Block.ListItem task children ->
                                    let
                                        checkbox : Html.Html msg
                                        checkbox =
                                            case task of
                                                Markdown.Block.NoTask ->
                                                    Html.text ""

                                                Markdown.Block.IncompleteTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Markdown.Block.CompletedTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [ css [ ulLiStyle ] ] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex, css [ olStyle ] ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li [ css [ olLiStyle ] ]
                                itemBlocks
                        )
                )
    , html = Markdown.Html.oneOf []
    , codeBlock =
        \{ body, language } ->
            Html.pre []
                [ Html.code
                    [ class
                        (case language of
                            Just languageName ->
                                "language-" ++ languageName

                            Nothing ->
                                ""
                        )
                    ]
                    [ Html.text body
                    ]
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs : List (Html.Attribute msg)
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Markdown.Block.AlignLeft ->
                                        "left"

                                    Markdown.Block.AlignCenter ->
                                        "center"

                                    Markdown.Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell =
        \maybeAlignment ->
            let
                attrs : List (Html.Attribute msg)
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Markdown.Block.AlignLeft ->
                                        "left"

                                    Markdown.Block.AlignCenter ->
                                        "center"

                                    Markdown.Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.td attrs
    }


headerStyle : Style
headerStyle =
    batch
        [ marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , color colorSecondary
        , lineHeight (em 1.2)
        ]


h2Style : Style
h2Style =
    batch
        [ textAlign center
        , marginBlockStart (em 2)
        ]


paragraphStyle : Style
paragraphStyle =
    batch
        [ marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , withMediaSmallDesktopUp
            [ fontSize (rem 1.2) ]
        , firstChild
            [ fontSize (rem 1.2)
            , marginBlockEnd (em 2)
            , withMediaTabletLandscapeUp [ fontSize (rem 1.825), lineHeight (em 1.35) ]
            ]
        ]


ulStyle : Style
ulStyle =
    batch
        [ listStyle none
        , marginBlockStart (em 2)
        , marginBlockEnd (em 2)
        ]


olStyle : Style
olStyle =
    batch
        [ listStyleType decimal
        , marginBlockStart (em 1)
        , marginBlockEnd (em 1)
        , paddingLeft (em 2)
        ]


ulLiStyle : Style
ulLiStyle =
    batch
        [ paddingLeft (rem 1.5)
        , position relative
        , fontWeight (int 600)
        , withMediaSmallDesktopUp
            [ fontSize (rem 1.2) ]
        , withMediaTabletLandscapeUp
            [ marginBlockStart (em 0.5)
            , marginBlockEnd (em 0.5)
            ]
        , before
            [ property "content" "\"\\25A0\""
            , color colorSecondary
            , fontSize (em 1.5)
            , position absolute
            , left (rem 0)
            , top (em -0.25)
            ]
        ]


olLiStyle : Style
olLiStyle =
    batch
        [ paddingLeft (em 1)
        , withMediaSmallDesktopUp
            [ fontSize (rem 1.2) ]
        ]
