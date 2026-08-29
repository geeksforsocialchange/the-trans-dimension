module Helpers.TransDate exposing
    ( humanDateFromPosix
    , humanDayDateMonthFromPosix
    , humanDayFromPosix
    , humanShortMonthFromPosix
    , humanTimeFromPosix
    , humanYearFromPosix
    , isAfterDate
    , isOnOrBeforeDate
    , isSameDay
    , isoDateStringDecoder
    , maybeHumanYearFromPosix
    )

import DateFormat
import Iso8601
import Json.Decode
import Time


defaultPosix : Time.Posix
defaultPosix =
    Time.millisToPosix 0



-----------------
-- Decode helpers
-----------------


isoDateStringDecoder : Json.Decode.Decoder Time.Posix
isoDateStringDecoder =
    Json.Decode.string
        |> Json.Decode.map
            (\isoString ->
                case Iso8601.toTime isoString of
                    Err _ ->
                        defaultPosix

                    Ok posix ->
                        posix
            )


convertedIsoDateZone : Time.Zone
convertedIsoDateZone =
    -- Iso8601.toTime normalizes times from timestamps to UTC, so we follow suit
    Time.utc



---------------------
-- Comparison helpers
---------------------


isSameDay : Time.Posix -> Time.Posix -> Bool
isSameDay aDay anotherDay =
    Time.toDay Time.utc aDay
        == Time.toDay Time.utc anotherDay
        && Time.toMonth Time.utc aDay
        == Time.toMonth Time.utc anotherDay
        && Time.toYear Time.utc aDay
        == Time.toYear Time.utc anotherDay


isSameYear : Time.Posix -> Time.Posix -> Bool
isSameYear aDay anotherDay =
    Time.toYear convertedIsoDateZone aDay
        == Time.toYear convertedIsoDateZone anotherDay


isOnOrBeforeDate : Time.Posix -> Time.Posix -> Bool
isOnOrBeforeDate aDay anotherDay =
    Time.posixToMillis aDay <= Time.posixToMillis anotherDay


isAfterDate : Time.Posix -> Time.Posix -> Bool
isAfterDate aDay anotherDay =
    Time.posixToMillis aDay > Time.posixToMillis anotherDay



------------------
-- Display helpers
------------------


humanDateFromPosix : Time.Posix -> String
humanDateFromPosix timestamp =
    -- We might want to change this to a Maybe in decoder
    -- For now - render a placeholder if value is the default
    if timestamp == defaultPosix then
        "Invalid date"

    else
        DateFormat.format
            [ DateFormat.dayOfMonthSuffix
            , DateFormat.text " "
            , DateFormat.monthNameFull
            , DateFormat.text " "
            , DateFormat.yearNumber
            ]
            convertedIsoDateZone
            timestamp


humanDayDateMonthFromPosix : Time.Posix -> String
humanDayDateMonthFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid day"

    else
        DateFormat.format
            [ DateFormat.dayOfWeekNameAbbreviated
            , DateFormat.text " "
            , DateFormat.dayOfMonthFixed
            , DateFormat.text " "
            , DateFormat.monthNameAbbreviated
            ]
            convertedIsoDateZone
            timestamp


humanDayFromPosix : Time.Posix -> String
humanDayFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid day"

    else
        DateFormat.format
            -- Do we want the ordinal number here? This is plain.
            [ DateFormat.dayOfMonthFixed ]
            convertedIsoDateZone
            timestamp


humanShortMonthFromPosix : Time.Posix -> String
humanShortMonthFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid month"

    else
        DateFormat.format
            [ DateFormat.monthNameAbbreviated ]
            convertedIsoDateZone
            timestamp


humanTimeFromPosix : Time.Posix -> Time.Zone -> String
humanTimeFromPosix timestamp timezone =
    if timestamp == defaultPosix then
        "Invalid time"

    else
        DateFormat.format
            [ DateFormat.hourNumber
            , DateFormat.text ":"
            , DateFormat.minuteFixed
            , DateFormat.amPmLowercase
            ]
            timezone
            timestamp


maybeHumanYearFromPosix : Time.Posix -> Time.Posix -> Maybe String
maybeHumanYearFromPosix nowTime timestamp =
    -- Only worth showing the year if it isn't the year we are currently in
    if timestamp == defaultPosix || isSameYear nowTime timestamp then
        Nothing

    else
        Just (humanYearFromPosix timestamp)


humanYearFromPosix : Time.Posix -> String
humanYearFromPosix timestamp =
    if timestamp == defaultPosix then
        "Invalid year"

    else
        DateFormat.format
            [ DateFormat.yearNumber ]
            convertedIsoDateZone
            timestamp
