module ErrorPage exposing (ErrorPage(..), Model, Msg, init, internalError, notFound, statusCode, update, view)

import Effect exposing (Effect)
import Html.Styled as Html
import View exposing (View)


type Msg
    = NoOp


type alias Model =
    {}


init : ErrorPage -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )


update : ErrorPage -> Msg -> Model -> ( Model, Effect Msg )
update _ msg model =
    case msg of
        NoOp ->
            ( model, Effect.none )


type ErrorPage
    = NotFound
    | InternalError String


notFound : ErrorPage
notFound =
    NotFound


internalError : String -> ErrorPage
internalError =
    InternalError


view : ErrorPage -> Model -> View Msg
view error _ =
    { body =
        [ Html.div []
            [ Html.p []
                [ Html.text <|
                    case error of
                        NotFound ->
                            "Page not found. Maybe try another URL?"

                        InternalError string ->
                            "Something went wrong.\n" ++ string
                ]
            ]
        ]
    , title =
        case error of
            NotFound ->
                "Page Not Found"

            InternalError _ ->
                "Unexpected Error"
    }


statusCode : ErrorPage -> number
statusCode error =
    case error of
        NotFound ->
            404

        InternalError _ ->
            500
