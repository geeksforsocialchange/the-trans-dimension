module Copy.Text exposing (isValidUrl, t, urlToDisplay)

import Constants exposing (canonicalUrl)
import Copy.Keys exposing (Key(..))
import Url



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "The Trans Dimension"

        SiteStrapline ->
            "Space and spaces for us"

        TransDimensionDescription ->
            -- Note this is also in content/about/main.md
            -- If they should remain in sync, we should remove from there
            "The Trans Dimension is an online community hub connecting trans communities in London and Manchester. We collate news, events and services by and for trans people."

        SiteLogoSrc ->
            canonicalUrl ++ "images/logos/tdd_logo_with_strapline_on_darkBlue.png"

        GeeksForSocialChangeHomeUrl ->
            "https://gfsc.studio/"

        GenderedIntelligenceHomeUrl ->
            "https://genderedintelligence.co.uk/"

        GenderedIntelligenceLogoTxt ->
            "Gendered Intelligence"

        GoogleMapSearchUrl address ->
            "https://www.google.com/maps/search/?api=1&query=" ++ Url.percentEncode address

        SeeOnGoogleMapText ->
            "See on Google map"

        MapImageAltText locationName ->
            "A map showing the location of " ++ locationName

        PageMetaTitle pageTitle ->
            String.join " | " [ pageTitle, t SiteTitle ]

        --- Header
        HeaderMobileMenuButton ->
            "Menu"

        HeaderAskButton ->
            "Donate"

        HeaderAskLink ->
            -- Gendered Intelligence just giving page
            "https://localgiving.org/donation/genderedintelligence?emb=3wLf1uws5L"

        --- Footer
        FooterSocial ->
            "Follow us out there"

        FooterInstaLink ->
            "https://www.instagram.com/genderedintelligence/"

        FooterTwitterLink ->
            "https://twitter.com/genderintell"

        FooterFacebookLink ->
            "https://www.facebook.com/GenderedIntelligence"

        FooterSignupText ->
            "Register for updates"

        FooterSignupEmailPlaceholder ->
            "Your email address"

        FooterSignupButton ->
            "Sign up"

        FooterByLine ->
            "Created by"

        FooterInfoTitle ->
            "The Trans Dimension, c/o Gendered Intelligence"

        FooterInfoCharity ->
            "Gendered Intelligence is a Registered Charity in England and Wales No. 1182558."

        FooterInfoCompany ->
            "Registered as a Company Limited by Guarantee in England and Wales No. 06617608."

        FooterInfoOffice ->
            "Registered office at VAI, 200a Pentonville Road, London N1 9JP."

        FooterCreditTitle ->
            "Credits"

        FooterCredit1Text ->
            "Illustrations by"

        FooterCredit1Name ->
            "Harry Woodgate"

        FooterCredit1Link ->
            "https://www.harrywoodgate.com/"

        FooterCredit2Text ->
            "design by"

        FooterCredit2Name ->
            "Squid"

        FooterCredit2Link ->
            "https://studiosquid.co.uk/"

        FooterCredit3Text ->
            "website by"

        FooterCredit3Name ->
            "GFSC"

        FooterCredit3Link ->
            t GeeksForSocialChangeHomeUrl

        FooterCopyright year ->
            "© " ++ year ++ " Gendered Intelligence. All rights reserved."

        FooterPlaceCal ->
            "Powered by PlaceCal"

        --- Index Page
        IndexTitle ->
            "Home"

        IndexMetaDescription ->
            "An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place. A collaboration between Gendered Intelligence and Geeks for Social Change."

        IndexIntroTitle ->
            "Trusted, accessible, trans-friendly spaces. Always expanding."

        IndexIntroMessage ->
            t TransDimensionDescription

        IndexIntroButtonText ->
            "See what's on"

        IndexFeaturedHeader ->
            "Upcoming Events"

        IndexFeaturedButtonText ->
            "View all events"

        IndexNewsHeader ->
            "Latest news"

        IndexNewsButtonText ->
            "View all news"

        --- About Page (NOTE: also comes from md)
        AboutTitle ->
            "About"

        AboutMetaDescription ->
            t TransDimensionDescription

        --- Events Page
        EventsTitle ->
            "Events"

        EventsMetaDescription ->
            "Events and activities by and for trans communities across the UK."

        EventsSummary ->
            "Upcoming events & activities for you."

        EventsSubHeading ->
            "Upcoming events"

        EventsEmptyTextAll ->
            "There are no upcoming events. Check back for updates!"

        EventsEmptyText ->
            "There are no upcoming events on this date. Check back for updates!"

        PreviousEventsEmptyTextAll ->
            "There have been no events in the recent past."

        EventsFilterLabelToday ->
            "Today"

        EventsFilterLabelTomorrow ->
            "Tomorrow"

        EventsFilterLabelAllPast ->
            "Past events"

        EventsFilterLabelAllFuture ->
            "Future events"

        --- Event Page
        EventTitle eventName ->
            "Event - " ++ eventName

        EventMetaDescription eventName eventSummary ->
            eventName ++ " - " ++ eventSummary

        BackToPartnerEventsLinkText partnerName ->
            "All events by " ++ Maybe.withDefault "this partner" partnerName

        BackToEventsLinkText ->
            "All events"

        EventVisitPublisherUrlText maybePartnerName ->
            "Visit " ++ Maybe.withDefault "Publisher" maybePartnerName ++ "'s site"

        --- Partners Page
        PartnersTitle ->
            "Partners"

        PartnersMetaDescription ->
            "Trans Dimension partners form an online community for connecting trans people across the UK by publishing service information, events and news on PlaceCal."

        PartnersIntroSummary ->
            "The Trans Dimension is a partnership of grassroots groups and charities with a track record of supporting the trans community."

        PartnersIntroDescription ->
            "All of our partners are explicitly trans-friendly organisations. Some are led by trans people, and some led by friends and allies. They put on events, provide services and offer support for members of our community."

        PartnersListEmpty ->
            "There are currently no Trans Dimension partners"

        PartnersMapAltText ->
            "A map showing the locations of all partners with listed addresses"

        --- Partner Page
        PartnerTitle partnerName ->
            "PlaceCal Partner - " ++ partnerName

        PartnerMetaDescription partnerName partnerSummary ->
            partnerName ++ " - " ++ partnerSummary

        PartnerContactsHeading ->
            "Get in touch"

        PartnerContactsEmptyText ->
            "No contact details provided"

        PartnerAddressHeading ->
            "Address"

        PartnerAddressEmptyText ->
            "No address provided"

        PartnerDescriptionText partnerDescription partnerName ->
            if String.isEmpty partnerDescription then
                "Please ask " ++ partnerName ++ " for more information"

            else
                partnerDescription

        PartnerUpcomingEventsText partnerName ->
            "Upcoming events by " ++ partnerName

        PartnerPreviousEventsText partnerName ->
            "Previous events by " ++ partnerName

        PartnerEventsEmptyText partnerName ->
            partnerName ++ " does not have any upcoming events. Check back for updates!"

        BackToPartnersLinkText ->
            "Go to all partners"

        --- Join Us Page
        JoinUsTitle ->
            "Join us"

        JoinUsSubtitle ->
            "Want to be listed on The Trans Dimension?"

        JoinUsMetaDescription ->
            "Want to be listed on The Trans Dimension? Get in touch and learn how you can create space and spaces for us."

        JoinUsDescription ->
            "Get in touch and learn how you can create space and spaces for us."

        JoinUsFormInputNameLabel ->
            "Name"

        JoinUsFormInputEmailLabel ->
            "Email address"

        JoinUsFormInputPhoneLabel ->
            "Phone number"

        JoinUsFormInputJobLabel ->
            "Job title"

        JoinUsFormInputOrgLabel ->
            "Organisation name"

        JoinUsFormInputAddressLabel ->
            "Postcode"

        JoinUsFormCheckboxesLabel ->
            "I'd like:"

        JoinUsFormCheckbox1 ->
            "A ring back"

        JoinUsFormCheckbox2 ->
            "More information"

        JoinUsFormInputMessageLabel ->
            "Your message"

        JoinUsFormInputMessagePlaceholder ->
            "Enter information about your organisation and events here or any questions you may have!"

        JoinUsFormSubmitButton ->
            "Submit"

        --- News Listing Page
        NewsTitle ->
            "News"

        NewsEmptyText ->
            "There is no recent news"

        NewsItemReadMore ->
            "Read the rest"

        NewsDescription ->
            "Updates & articles from our partners."

        --- News Single Article Page
        NewsItemTitle title ->
            "News -" ++ title

        NewsItemMetaDescription title author ->
            title ++ " - by " ++ author ++ " for The Trans Dimension"

        NewsItemReturnButton ->
            "Go back to news"

        --- Privacy Page (note this also comes from markdown)
        PrivacyTitle ->
            "Privacy"

        PrivacyMetaDescription ->
            "Privacy information for The Trans Dimension website."

        --- 404 Page
        ErrorTitle ->
            "Error 404"

        ErrorMessage ->
            "This page could not be found."

        ErrorButtonText ->
            "Back to home"


urlRecombiner : Maybe Url.Url -> String
urlRecombiner urlRecord =
    case urlRecord of
        Just url ->
            url.host ++ url.path ++ Maybe.withDefault "" url.query ++ Maybe.withDefault "" url.fragment

        Nothing ->
            ""


chompTrailingUrlSlash : String -> String
chompTrailingUrlSlash urlString =
    if String.endsWith "/" urlString then
        String.dropRight 1 urlString

    else
        urlString


urlToDisplay : String -> String
urlToDisplay url =
    Url.fromString url |> urlRecombiner |> chompTrailingUrlSlash


isValidUrl : String -> Bool
isValidUrl urlString =
    case Url.fromString urlString of
        Just url ->
            url.protocol == Url.Https

        Nothing ->
            False
