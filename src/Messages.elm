module Messages exposing (Msg(..), SharedMsg(..))

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
    | SharedMsg SharedMsg
    | SetRegion Int
    | UrlChanged String


type SharedMsg
    = NoOp
