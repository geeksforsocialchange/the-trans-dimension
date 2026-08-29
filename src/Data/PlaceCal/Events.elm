module Data.PlaceCal.Events exposing (Event, EventLocation, EventPartner, EventPartnerContact, Geo, afterDate, eventFromSlug, eventPartnerFromId, eventsData, eventsFromRegionId, eventsOnDate, eventsWithPartners, nextEventStartTime, nextNEvents, onOrBeforeDate)

import BackendTask
import BackendTask.Custom
import Constants
import Data.PlaceCal.Api
import Data.PlaceCal.Partners
import FatalError
import Helpers.TransDate as TransDate
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode
import Time


type alias Event =
    { id : String
    , partnershipTagId : Int
    , name : String
    , summary : String
    , description : String
    , startDatetime : Time.Posix
    , endDatetime : Time.Posix
    , maybePublisherUrl : Maybe String
    , location : Maybe EventLocation
    , partner : EventPartner
    , maybeGeo : Maybe Geo
    }


type alias EventPartner =
    { name : Maybe String
    , id : String
    , maybeContactDetails : Maybe EventPartnerContact
    , maybeUrl : Maybe String
    }


type alias EventPartnerContact =
    { email : String
    , telephone : String
    }


type alias EventLocation =
    { streetAddress : String
    , postalCode : String
    }


type alias Geo =
    -- Bug: We expect if there is a postcode in the address, these exist.
    -- But, in practice, sometimes they don't see:
    -- https://github.com/geeksforsocialchange/PlaceCal/issues/1639
    { latitude : Maybe String
    , longitude : Maybe String
    }


emptyEvent : Event
emptyEvent =
    { id = ""
    , partnershipTagId = 0
    , name = ""
    , summary = ""
    , description = ""
    , startDatetime = Time.millisToPosix 0
    , endDatetime = Time.millisToPosix 0
    , maybePublisherUrl = Nothing
    , location = Nothing
    , maybeGeo = Nothing
    , partner =
        { name = Nothing
        , id = ""
        , maybeUrl = Nothing
        , maybeContactDetails = Nothing
        }
    }



--type Realm
--    = Online


eventFromSlug : String -> List Event -> Event
eventFromSlug eventId eventList =
    List.filter (\event -> event.id == eventId) eventList
        |> List.head
        |> Maybe.withDefault emptyEvent


eventsFromRegionId : List Event -> Int -> List Event
eventsFromRegionId eventList regionId =
    -- Region 0 is everywhere
    if regionId == 0 then
        eventList

    else
        List.filter (\event -> event.partnershipTagId == regionId) eventList


eventsOnDate : List Event -> Time.Posix -> List Event
eventsOnDate eventList onDate =
    List.filter
        (\event ->
            TransDate.isSameDay event.startDatetime onDate
        )
        eventList


onOrBeforeDate : List Event -> Time.Posix -> List Event
onOrBeforeDate eventList fromDate =
    List.filter
        (\event ->
            TransDate.isOnOrBeforeDate event.startDatetime fromDate
        )
        eventList


afterDate : List Event -> Time.Posix -> List Event
afterDate eventList fromDate =
    List.filter
        (\event ->
            TransDate.isAfterDate event.startDatetime fromDate
        )
        eventList


nextNEvents : Int -> List Event -> Time.Posix -> List Event
nextNEvents showCount eventList fromTime =
    List.take showCount (afterDate eventList fromTime)


eventPartnerFromId : List Data.PlaceCal.Partners.Partner -> String -> EventPartner
eventPartnerFromId partnerList partnerId =
    List.filter (\partner -> partner.id == partnerId) partnerList
        |> List.map
            (\partner ->
                { name = Just partner.name
                , maybeContactDetails = partner.maybeContactDetails
                , id = partner.id
                , maybeUrl = partner.maybeUrl
                }
            )
        |> List.head
        |> Maybe.withDefault { name = Nothing, maybeContactDetails = Nothing, maybeUrl = Nothing, id = partnerId }


eventsWithPartners : List Event -> List Data.PlaceCal.Partners.Partner -> List Event
eventsWithPartners eventList partnerList =
    List.map
        (\event -> { event | partner = eventPartnerFromId partnerList event.partner.id })
        eventList


nextEventStartTime : List Event -> Int -> Time.Posix -> Maybe Time.Posix
nextEventStartTime eventList tagId nowTime =
    eventsFromRegionId (afterDate eventList nowTime) tagId
        |> List.map (\event -> Time.posixToMillis event.startDatetime)
        |> List.minimum
        |> Maybe.map Time.millisToPosix



----------------------------
-- DataSource query & decode
----------------------------


eventsData : BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Custom.Error } AllEventsResponse
eventsData =
    BackendTask.combine
        (List.map
            (\partnershipTagInt ->
                Data.PlaceCal.Api.fetchAndCachePlaceCalData
                    ("events-" ++ String.fromInt partnershipTagInt)
                    (allEventsQuery (String.fromInt partnershipTagInt))
                    (eventsDecoder partnershipTagInt)
            )
            Data.PlaceCal.Partners.partnershipTagIdList
        )
        |> BackendTask.map (List.map .allEvents)
        |> BackendTask.map List.concat
        |> BackendTask.map sortEventsByDate
        |> BackendTask.map (\eventList -> { allEvents = eventList })


sortEventsByDate : List Event -> List Event
sortEventsByDate events =
    List.sortBy
        (\event -> Time.posixToMillis event.startDatetime)
        events


allEventsQuery : String -> Json.Encode.Value
allEventsQuery partnershipTag =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string
                ("query { eventsByFilter(tagId: "
                    ++ partnershipTag
                    ++ ", fromDate: \""
                    ++ Constants.fromDate
                    ++ "\", toDate: \""
                    ++ Constants.toDate
                    ++ "\") { id name summary description startDate endDate publisherUrl address { streetAddress, postalCode, geo { latitude, longitude } } organizer { id } } }"
                )
          )
        ]


eventsDecoder : Int -> Json.Decode.Decoder AllEventsResponse
eventsDecoder partnershipTagInt =
    Json.Decode.succeed AllEventsResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "eventsByFilter" ] (Json.Decode.list (decodeEvent partnershipTagInt))


decodeEvent : Int -> Json.Decode.Decoder Event
decodeEvent partnershipTagInt =
    Json.Decode.succeed Event
        |> Json.Decode.Pipeline.required "id"
            Json.Decode.string
        |> Json.Decode.Pipeline.optional "partnershipTagId" (Json.Decode.succeed partnershipTagInt) partnershipTagInt
        |> Json.Decode.Pipeline.required "name"
            Json.Decode.string
        |> Json.Decode.Pipeline.optional "summary"
            Json.Decode.string
            ""
        |> Json.Decode.Pipeline.optional "description"
            Json.Decode.string
            ""
        |> Json.Decode.Pipeline.required "startDate"
            TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.required "endDate"
            TransDate.isoDateStringDecoder
        |> Json.Decode.Pipeline.optional "publisherUrl"
            (Json.Decode.nullable Json.Decode.string)
            Nothing
        |> Json.Decode.Pipeline.optional "address" (Json.Decode.map Just eventAddressDecoder) Nothing
        |> Json.Decode.Pipeline.requiredAt [ "organizer", "id" ]
            partnerIdDecoder
        |> Json.Decode.Pipeline.optionalAt [ "address", "geo" ] (Json.Decode.map Just geoDecoder) Nothing


eventAddressDecoder : Json.Decode.Decoder EventLocation
eventAddressDecoder =
    Json.Decode.succeed EventLocation
        |> Json.Decode.Pipeline.required "streetAddress" Json.Decode.string
        |> Json.Decode.Pipeline.required "postalCode" Json.Decode.string


partnerIdDecoder : Json.Decode.Decoder EventPartner
partnerIdDecoder =
    Json.Decode.string
        |> Json.Decode.map (\partnerId -> { name = Nothing, id = partnerId, maybeContactDetails = Nothing, maybeUrl = Nothing })


geoDecoder : Json.Decode.Decoder Geo
geoDecoder =
    Json.Decode.succeed Geo
        |> Json.Decode.Pipeline.optional "latitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing
        |> Json.Decode.Pipeline.optional "longitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing


type alias AllEventsResponse =
    { allEvents : List Event }
