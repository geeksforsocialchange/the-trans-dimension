module Data.PlaceCal.Partners exposing (Address, Contact, Geo, Partner, PartnershipTag, ServiceArea, filterFromQueryString, getTagInfoById, partnerFromSlug, partnerNamesFromIds, partnersData, partnersFromRegionId, partnershipTagIdList, partnershipTagList)

import BackendTask
import BackendTask.Custom
import Constants
import Data.PlaceCal.Api
import FatalError
import Json.Decode
import Json.Decode.Pipeline
import Json.Encode


type alias Partner =
    { id : String
    , partnershipTagId : Int
    , name : String
    , summary : String
    , description : String
    , maybeUrl : Maybe String
    , maybeInstagramUrl : Maybe String
    , maybeContactDetails : Maybe Contact
    , maybeAddress : Maybe Address
    , areasServed : List ServiceArea
    , maybeGeo : Maybe Geo
    , maybeLogo : Maybe String
    }


type alias Address =
    { streetAddress : String
    , addressRegion : String
    , postalCode : String
    }


type alias Contact =
    { email : String
    , telephone : String
    }


type alias Geo =
    -- Bug: We expect if there is a postcode in the address, these exist.
    -- But, in practice, sometimes they don't see:
    -- https://github.com/geeksforsocialchange/PlaceCal/issues/1639
    { latitude : Maybe String
    , longitude : Maybe String
    }


type alias ServiceArea =
    { name : String
    , abbreviatedName : Maybe String
    }


emptyPartner : Partner
emptyPartner =
    { id = ""
    , partnershipTagId = 0
    , name = ""
    , summary = ""
    , description = ""
    , maybeUrl = Nothing
    , maybeInstagramUrl = Nothing
    , maybeContactDetails = Nothing
    , maybeAddress = Nothing
    , areasServed = []
    , maybeGeo = Nothing
    , maybeLogo = Nothing
    }



----------------------------
-- DataSource query & decode
----------------------------


type alias AllPartnersResponse =
    { allPartners : List Partner }


type alias PartnershipTag =
    { id : Int
    , name : String
    }


partnershipTagList : List PartnershipTag
partnershipTagList =
    String.split "," Constants.partnershipTagList
        |> List.map
            (\tagInfo ->
                { id = partnershipTagId tagInfo
                , name = partnershipTagName tagInfo
                }
            )


partnershipTagIdList : List Int
partnershipTagIdList =
    partnershipTagList
        |> List.map .id


partnershipTagId : String -> Int
partnershipTagId tagInfo =
    List.head (String.split "|" tagInfo)
        |> Maybe.withDefault ""
        |> String.toInt
        |> Maybe.withDefault 0


partnershipTagName : String -> String
partnershipTagName tagInfo =
    List.head
        (List.reverse (String.split "|" tagInfo))
        |> Maybe.withDefault ""


filterFromQueryString : String -> Maybe Int
filterFromQueryString queryString =
    partnershipTagList
        |> List.filter (\tagInfo -> String.toLower tagInfo.name == String.toLower queryString)
        |> Maybe.withDefault List.head Nothing
        |> maybeMatchTagId


maybeMatchTagId : Maybe PartnershipTag -> Maybe Int
maybeMatchTagId maybeTagInfo =
    case maybeTagInfo of
        Just tagInfo ->
            Just tagInfo.id

        Nothing ->
            Nothing


getTagInfoById : Int -> Maybe PartnershipTag
getTagInfoById tagId =
    partnershipTagList
        |> List.filter (\tagInfo -> tagInfo.id == tagId)
        |> List.head


partnersData : BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Custom.Error } AllPartnersResponse
partnersData =
    BackendTask.combine
        (List.map
            (\partnershipTagInt ->
                Data.PlaceCal.Api.fetchAndCachePlaceCalData
                    ("partners-" ++ String.fromInt partnershipTagInt)
                    (allPartnersQuery (String.fromInt partnershipTagInt))
                    (partnersDecoder partnershipTagInt)
            )
            partnershipTagIdList
        )
        |> BackendTask.map (List.map .allPartners)
        |> BackendTask.map List.concat
        |> BackendTask.map (\partnerList -> { allPartners = partnerList })


singlePartnerData : String -> BackendTask.BackendTask { fatal : FatalError.FatalError, recoverable : BackendTask.Custom.Error } Partner
singlePartnerData partnerId =
    Data.PlaceCal.Api.fetchSinglePlaceCalData
        partnerId
        (singlePartnerQuery partnerId)
        (singlePartnerDecoder 0)


allPartnersQuery : String -> Json.Encode.Value
allPartnersQuery partnershipTag =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string
                ("query { partnersByTag(tagId: "
                    ++ partnershipTag
                    ++ """
                ) {
                  id
                  name
                  description
                  summary
                  contact { email, telephone }
                  url
                  instagramUrl
                  address { streetAddress, postalCode, addressRegion, geo { latitude, longitude } }
                  areasServed { name abbreviatedName }
                  logo
                } }
          """
                )
          )
        ]


singlePartnerQuery : String -> Json.Encode.Value
singlePartnerQuery partnerId =
    Json.Encode.object
        [ ( "query"
          , Json.Encode.string
                """
                query Partner($id: ID!) {
                  partner(id: $id) {
                    id
                    name
                    description
                    summary
                    contact { email, telephone }
                    url
                    instagramUrl
                    address { streetAddress, postalCode, addressRegion, geo { latitude, longitude } }
                    areasServed { name abbreviatedName }
                    logo
                  }
                }
                """
          )
        , ( "variables"
          , Json.Encode.object
                [ ( "id", Json.Encode.string partnerId ) ]
          )
        ]


partnersDecoder : Int -> Json.Decode.Decoder AllPartnersResponse
partnersDecoder partnershipTagInt =
    Json.Decode.succeed AllPartnersResponse
        |> Json.Decode.Pipeline.requiredAt [ "data", "partnersByTag" ] (Json.Decode.list (decodePartner partnershipTagInt))


singlePartnerDecoder : Int -> Json.Decode.Decoder Partner
singlePartnerDecoder partnershipTagInt =
    Json.Decode.at [ "data", "partner" ] (decodePartner partnershipTagInt)


decodePartner : Int -> Json.Decode.Decoder Partner
decodePartner partnershipTagInt =
    Json.Decode.succeed Partner
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.Pipeline.optional "partnershipTagId" (Json.Decode.succeed partnershipTagInt) partnershipTagInt
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.optional "summary" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "description" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "url" (Json.Decode.map Just Json.Decode.string) Nothing
        |> Json.Decode.Pipeline.optional "instagramUrl" (Json.Decode.map Just Json.Decode.string) Nothing
        |> Json.Decode.Pipeline.optional "contact" (Json.Decode.map Just contactDecoder) Nothing
        |> Json.Decode.Pipeline.optional "address" (Json.Decode.map Just addressDecoder) Nothing
        |> Json.Decode.Pipeline.required "areasServed" (Json.Decode.list serviceAreaDecoder)
        |> Json.Decode.Pipeline.optionalAt [ "address", "geo" ] (Json.Decode.map Just geoDecoder) Nothing
        |> Json.Decode.Pipeline.optional "logo" (Json.Decode.nullable Json.Decode.string) Nothing


geoDecoder : Json.Decode.Decoder Geo
geoDecoder =
    Json.Decode.succeed Geo
        |> Json.Decode.Pipeline.optional "latitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing
        |> Json.Decode.Pipeline.optional "longitude"
            (Json.Decode.nullable Json.Decode.string)
            Nothing


contactDecoder : Json.Decode.Decoder Contact
contactDecoder =
    Json.Decode.succeed Contact
        |> Json.Decode.Pipeline.optional "email" Json.Decode.string ""
        |> Json.Decode.Pipeline.optional "telephone" Json.Decode.string ""


addressDecoder : Json.Decode.Decoder Address
addressDecoder =
    Json.Decode.succeed Address
        |> Json.Decode.Pipeline.required "streetAddress" Json.Decode.string
        |> Json.Decode.Pipeline.required "addressRegion" Json.Decode.string
        |> Json.Decode.Pipeline.required "postalCode" Json.Decode.string


serviceAreaDecoder : Json.Decode.Decoder ServiceArea
serviceAreaDecoder =
    Json.Decode.succeed ServiceArea
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.optional "abbreviatedName"
            (Json.Decode.map Just Json.Decode.string)
            Nothing


partnerFromSlug : List Partner -> String -> Partner
partnerFromSlug partnerList id =
    List.filter (\partner -> partner.id == id) partnerList
        |> List.head
        |> Maybe.withDefault emptyPartner


partnerNamesFromIds : List Partner -> List String -> List String
partnerNamesFromIds partnerList idList =
    -- If the partner isn't in our sites partners, it won't be in the list
    List.filter (\partner -> List.member partner.id idList) partnerList
        |> List.map (\partner -> partner.name)


partnersFromRegionId : List Partner -> Int -> List Partner
partnersFromRegionId partnerList regionId =
    -- Region 0 is everywhere
    if regionId == 0 then
        List.sortBy .name partnerList

    else
        List.filter (\partner -> partner.partnershipTagId == regionId) partnerList
