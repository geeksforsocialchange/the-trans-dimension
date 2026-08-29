module Helpers.TransDateTests exposing (..)

import Expect
import Helpers.TransDate as TransDate
import Test exposing (Test, describe, test)
import Time


nowTime : Time.Posix
nowTime =
    -- 21 Feb 2022
    Time.millisToPosix 1645449400000


suite : Test
suite =
    describe "Helpers.TransDate.maybeHumanYearFromPosix"
        [ test "Shows no year for an event in the current year" <|
            \_ ->
                -- 25 Dec 2022
                TransDate.maybeHumanYearFromPosix nowTime (Time.millisToPosix 1671926400000)
                    |> Expect.equal Nothing
        , test "Shows no year for an event at the same moment as now" <|
            \_ ->
                TransDate.maybeHumanYearFromPosix nowTime nowTime
                    |> Expect.equal Nothing
        , test "Shows the year for an event in a past year" <|
            \_ ->
                -- 25 Dec 2021
                TransDate.maybeHumanYearFromPosix nowTime (Time.millisToPosix 1640390400000)
                    |> Expect.equal (Just "2021")
        , test "Shows the year for an event in a future year" <|
            \_ ->
                -- 1 Jan 2023
                TransDate.maybeHumanYearFromPosix nowTime (Time.millisToPosix 1672531200000)
                    |> Expect.equal (Just "2023")
        , test "Shows no year for an invalid date" <|
            \_ ->
                TransDate.maybeHumanYearFromPosix nowTime (Time.millisToPosix 0)
                    |> Expect.equal Nothing
        ]
