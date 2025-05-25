module Route.Partners.Partner_ exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Browser.Dom
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Data.PlaceCal.Events
import Data.PlaceCal.Partners
import Effect
import FatalError
import Head
import Helpers.TransRoutes exposing (Route(..))
import Html.Styled
import PagesMsg
import RouteBuilder
import Shared
import Skin.Global
import Task
import Theme.Page.Events
import Theme.Page.Partner
import Theme.PageTemplate
import Theme.Paginator exposing (Msg(..))
import Time
import UrlPath
import View


type alias Model =
    { filterByDate : Theme.Paginator.Filter
    , filterByRegion : Int
    , nowTime : Time.Posix
    , viewportWidth : Float
    , urlFragment : Maybe String
    }


type alias Msg =
    Theme.Page.Events.Msg


type alias RouteParams =
    { partner : String }


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.preRender
        { data = data
        , pages = pages
        , head = head
        }
        |> RouteBuilder.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions = subscriptions
            }


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init app _ =
    let
        urlFragment : Maybe String
        urlFragment =
            Maybe.andThen .fragment app.url

        tasks : List (Effect.Effect Msg)
        tasks =
            [ Task.perform GetTime Time.now
                |> Cmd.map Theme.Page.Events.fromPaginatorMsg
                |> Effect.fromCmd
            , Task.perform GotViewport Browser.Dom.getViewport
                |> Cmd.map Theme.Page.Events.fromPaginatorMsg
                |> Effect.fromCmd
            ]
    in
    ( { filterByDate = Theme.Paginator.None
      , filterByRegion = 0
      , nowTime = Time.millisToPosix 0
      , viewportWidth = 320
      , urlFragment = urlFragment
      }
    , Effect.batch
        (case urlFragment of
            Just fragment ->
                tasks
                    ++ [ Browser.Dom.getElement fragment
                            |> Task.andThen (\element -> Browser.Dom.setViewport 0 element.element.y)
                            |> Task.attempt (\_ -> NoOp)
                            |> Cmd.map Theme.Page.Events.fromPaginatorMsg
                            |> Effect.fromCmd
                       ]

            Nothing ->
                tasks
        )
    )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg )
update app _ msg model =
    case msg of
        Theme.Page.Events.PaginatorMsg submsg ->
            case submsg of
                Theme.Paginator.ClickedDay posix ->
                    ( { model
                        | filterByDate = Theme.Paginator.Day posix
                      }
                    , Effect.none
                    )

                Theme.Paginator.ClickedAllPastEvents ->
                    ( { model
                        | filterByDate = Theme.Paginator.Past
                      }
                    , Effect.none
                    )

                Theme.Paginator.ClickedAllFutureEvents ->
                    ( { model
                        | filterByDate = Theme.Paginator.Future
                      }
                    , Effect.none
                    )

                Theme.Paginator.GetTime newTime ->
                    ( { model
                        | filterByDate = Theme.Paginator.Day newTime
                        , nowTime = newTime
                      }
                    , Effect.none
                    )

                Theme.Paginator.ScrollRight ->
                    ( model
                    , Task.attempt (\_ -> NoOp)
                        (Theme.Paginator.scrollPagination Theme.Paginator.Right model.viewportWidth)
                        |> Cmd.map Theme.Page.Events.fromPaginatorMsg
                        |> Effect.fromCmd
                    )

                Theme.Paginator.ScrollLeft ->
                    ( model
                    , Task.attempt (\_ -> NoOp)
                        (Theme.Paginator.scrollPagination Theme.Paginator.Left model.viewportWidth)
                        |> Cmd.map Theme.Page.Events.fromPaginatorMsg
                        |> Effect.fromCmd
                    )

                Theme.Paginator.GotViewport viewport ->
                    ( { model | viewportWidth = viewport.scene.width }, Effect.none )

                Theme.Paginator.NoOp ->
                    ( model, Effect.none )

        Theme.Page.Events.RegionSelectorMsg _ ->
            -- We do not include Region Selector on individual Partner pages
            -- But may  in future if some partners have events in multiple regions
            ( model, Effect.none )

        Theme.Page.Events.ClickedGoToNextEvent nextEventTime ->
            ( { model | filterByDate = Theme.Paginator.Day nextEventTime }, Effect.none )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


type alias Data =
    { events : List Data.PlaceCal.Events.Event
    }


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : RouteParams -> BackendTask.BackendTask FatalError.FatalError Data
data _ =
    BackendTask.map Data
        (BackendTask.map (\eventsData -> eventsData.allEvents) Data.PlaceCal.Events.eventsData)
        |> BackendTask.allowFatal


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head app =
    let
        partner =
            Data.PlaceCal.Partners.partnerFromSlug app.sharedData.partners app.routeParams.partner
    in
    Theme.PageTemplate.pageMetaTags
        { title = PartnerTitle partner.name
        , description = PartnerMetaDescription partner.name partner.summary
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app _ model =
    let
        aPartner =
            Data.PlaceCal.Partners.partnerFromSlug app.sharedData.partners app.routeParams.partner
    in
    { title = t (PageMetaTitle aPartner.name)
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "secondary"
            , title = t PartnersTitle
            , bigText = { text = aPartner.name, node = "h3" }
            , smallText = Nothing
            , innerContent =
                Just
                    (Theme.Page.Partner.viewInfo model
                        { partner = aPartner
                        , events = eventsFromPartnerId aPartner.id app.data.events
                        }
                    )
            , outerContent = Just (Skin.Global.viewBackButton (Helpers.TransRoutes.toAbsoluteUrl Partners) (t BackToPartnersLinkText))
            }
            |> Html.Styled.map PagesMsg.fromMsg
        ]
    }


pages : BackendTask.BackendTask FatalError.FatalError (List RouteParams)
pages =
    BackendTask.map
        (\partnerData ->
            partnerData.allPartners
                |> List.map (\partner -> { partner = partner.id })
        )
        Data.PlaceCal.Partners.partnersData
        |> BackendTask.allowFatal


eventsFromPartnerId : String -> List Data.PlaceCal.Events.Event -> List Data.PlaceCal.Events.Event
eventsFromPartnerId partnerId eventList =
    List.filter (\event -> partnerId == event.partner.id) eventList
