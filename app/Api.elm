module Api exposing (routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import Constants
import FatalError exposing (FatalError)
import Html exposing (Html)
import Pages.Manifest
import Route exposing (Route)
import Site


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    -- Pages.Manifest.generator emits /manifest.json and adds the
    -- <link rel="manifest"> global head tag for us.
    [ Pages.Manifest.generator Constants.canonicalUrl
        (BackendTask.succeed Site.manifest)
    ]
