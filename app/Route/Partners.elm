module Route.Partners exposing (Model, Msg, RouteParams, route, Data, ActionData)

{-|

@docs Model, Msg, RouteParams, route, Data, ActionData

-}

import BackendTask
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Effect
import FatalError
import Head
import Html.Styled
import Messages exposing (Msg(..))
import PagesMsg
import RouteBuilder
import Shared
import Theme.Page.Partners
import Theme.PageTemplate
import Theme.RegionSelector exposing (Msg(..))
import UrlPath
import View


type alias Model =
    { filterByRegion : Int }


type alias Msg =
    Theme.RegionSelector.Msg


type alias RouteParams =
    {}


init :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> ( Model, Effect.Effect Msg )
init _ shared =
    ( { filterByRegion = Maybe.withDefault 0 shared.filterParam }
    , Effect.none
    )


update :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg, Maybe Shared.Msg )
update app _ msg model =
    case msg of
        ClickedSelector tagId ->
            ( { model
                | filterByRegion = tagId
              }
            , Effect.none
            , Just (SetRegion tagId)
            )


subscriptions : RouteParams -> UrlPath.UrlPath -> Shared.Model -> Model -> Sub Msg
subscriptions _ _ _ _ =
    Sub.none


route : RouteBuilder.StatefulRoute RouteParams Data ActionData Model Msg
route =
    RouteBuilder.single
        { data = data, head = head }
        |> RouteBuilder.buildWithSharedState
            { init = init
            , view = view
            , update = update
            , subscriptions = subscriptions
            }


type alias Data =
    ()


type alias ActionData =
    BackendTask.BackendTask FatalError.FatalError (List RouteParams)


data : BackendTask.BackendTask FatalError.FatalError Data
data =
    BackendTask.succeed ()


head : RouteBuilder.App Data ActionData RouteParams -> List Head.Tag
head _ =
    Theme.PageTemplate.pageMetaTags
        { title = PartnersTitle
        , description = PartnersMetaDescription
        , imageSrc = Nothing
        }


view :
    RouteBuilder.App Data ActionData RouteParams
    -> Shared.Model
    -> Model
    -> View.View (PagesMsg.PagesMsg Msg)
view app _ model =
    { title = t (PageMetaTitle (t PartnersTitle))
    , body =
        [ Theme.PageTemplate.view
            { headerType = Just "secondary"
            , title = t PartnersTitle
            , bigText = { text = t PartnersIntroSummary, node = "p" }
            , smallText = Just [ t PartnersIntroDescription ]
            , innerContent =
                Just
                    (Theme.Page.Partners.viewPartners app.sharedData.partners model
                        |> Html.Styled.map PagesMsg.fromMsg
                    )
            , outerContent = Nothing
            }
        ]
    }
