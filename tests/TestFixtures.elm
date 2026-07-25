module TestFixtures exposing (events, news)

import Data.PlaceCal.Articles exposing (Article)
import Data.PlaceCal.Events exposing (Event)
import Time


events : List Event
events =
    [ { id = "1"
      , partnershipTagId = 30
      , name = "Event 1 name"
      , summary = "A summary of the first event"
      , description = "Fusce at sodales lacus. Morbi scelerisque lacus leo, ac mattis urna ultrices et. Proin ac eros faucibus, consequat ante vel, vulputate lectus. Nunc dictum pharetra ex, eget vestibulum lacus. Maecenas molestie felis in turpis eleifend, nec accumsan massa sodales. Nulla facilisi. Vivamus id rhoncus nulla. Nunc ultricies lectus et dui tempor sodales. Curabitur interdum lectus ultricies est ultricies, at faucibus nisi semper. Praesent iaculis ornare orci. Sed vel metus pharetra, efficitur leo a, porttitor magna. Curabitur sit amet mollis ex."
      , startDatetime = Time.millisToPosix 1645466400000
      , endDatetime = Time.millisToPosix 1650564000000
      , maybePublisherUrl = Just "https://example.com/publisher/url/1"
      , location = Just { streetAddress = "54 Zoo Lane", postalCode = "M16 7WP" }
      , maybeGeo = Nothing

      --, realm = Online
      , partner = { id = "1", name = Just "Partner one", maybeUrl = Nothing, maybeContactDetails = Nothing }
      }
    , { id = "2"
      , partnershipTagId = 3
      , name = "Event 2 name"
      , summary = "A summary of the second event"
      , description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ut risus placerat, suscipit lacus quis, pretium nisl. Fusce enim erat, fringilla ac auctor scelerisque, scelerisque non ipsum. Vivamus non elit id orci aliquam lobortis at sit amet ligula. Aenean vel massa pellentesque, viverra turpis et, commodo ipsum. Vivamus nunc elit, elementum et ipsum id, rutrum commodo sapien. Integer eget mi eget lacus sagittis molestie feugiat at lacus. Cras ultrices molestie blandit. Suspendisse gravida tortor non risus vestibulum laoreet. Nam nec quam id nisi suscipit consectetur. Aliquam venenatis tortor elit, id suscipit augue feugiat ac."
      , startDatetime = Time.millisToPosix 1645448400000
      , endDatetime = Time.millisToPosix 1658408400000
      , maybePublisherUrl = Just "https://example.com/publisher/url/2"
      , location = Just { streetAddress = "54 Zoo Lane", postalCode = "M16 7WP" }
      , maybeGeo = Nothing

      --, realm = Offline
      , partner = { id = "2", name = Just "Partner two", maybeUrl = Nothing, maybeContactDetails = Nothing }
      }
    ]


news : List Article
news =
    [ { title = "Some news"
      , body = "Integer et nibh porta, pellentesque lacus sit amet, condimentum ligula. Praesent eget lobortis felis, id hendrerit nisl. Vivamus porttitor purus vulputate arcu consequat, vitae condimentum metus molestie. Sed ac consequat eros, vel venenatis metus. Duis laoreet id velit sit amet semper. Nunc placerat risus mi, vitae lacinia lectus rutrum sed. Sed turpis ligula, interdum eu tempor vel, accumsan in arcu. Donec hendrerit molestie sapien, sed suscipit augue. Curabitur eleifend felis magna, nec egestas eros auctor ac. Mauris hendrerit venenatis vestibulum. Aliquam erat volutpat. Aenean commodo gravida est ac dapibus. Vivamus eu lacus sit amet quam sodales consequat. Nullam auctor lacus ac imperdiet fermentum. Pellentesque vel interdum nisi. Aenean malesuada ut nunc eu euismod."
      , publishedDatetime = Time.millisToPosix 1645449400000
      , partnerIds = [ "Article Author1" ]
      , imageSrc = ""
      }
    , { title = "Big news!"
      , body = "Nunc augue erat, ullamcorper et nunc nec, placerat rhoncus nulla. Quisque nec sollicitudin turpis. Etiam risus dolor, ullamcorper vitae consectetur et, faucibus a nunc. Phasellus tempus tellus ligula, dignissim bibendum leo accumsan ac. Phasellus sit amet odio varius augue aliquet venenatis. Vestibulum sit amet mi pulvinar, efficitur tortor non, semper ipsum. In ut faucibus sapien, non pellentesque odio. Morbi orci purus, consequat ut enim non, placerat eleifend neque. Nulla non rhoncus velit. Ut tristique cursus nulla vel consectetur. Fusce in odio vel nunc iaculis pulvinar. Suspendisse a sagittis orci, rutrum mattis justo.\n\n"
      , publishedDatetime = Time.millisToPosix 1645559400000
      , partnerIds = [ "Article Author1", "Article Author2" ]
      , imageSrc = ""
      }
    ]
