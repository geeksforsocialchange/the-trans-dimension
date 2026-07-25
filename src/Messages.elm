module Messages exposing (Msg(..))

import Time
import UrlPath exposing (UrlPath)


type Msg
    = OnPageChange
        { path : UrlPath
        , query : Maybe String
        , fragment : Maybe String
        }
      -- Header
    | ToggleMenu
      -- Shared
    | SetRegion Int
    | UrlChanged String
    | GetTimeZone Time.Zone
