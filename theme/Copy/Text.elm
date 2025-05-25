module Copy.Text exposing (t)

import Constants exposing (canonicalUrl)
import Copy.Keys exposing (Key(..), Prefix(..))
import Url



-- The translate function


t : Key -> String
t key =
    case key of
        SiteTitle ->
            "[Site title]"

        SiteStrapline ->
            "[Site strapline] Lorem ipsum dolor sit amet consectetur adipiscing elit."

        PartnershipDescription ->
            -- Note this is also in content/about/main.md
            -- If they should remain in sync, we should remove from there
            "[Partnership despription] Lorem ipsum dolor sit amet consectetur adipiscing elit. Dolor sit amet consectetur adipiscing elit quisque faucibus."

        PartnerOrganisationHomeUrl ->
            "[Partnership Organisation website] https://example.co.uk/"

        PartnerOrganisationLogoTxt ->
            "[Partnership Organisation logo text]"

        --- Header
        HeaderMobileMenuButton ->
            "Menu"

        HeaderAskButton ->
            "Donate"

        HeaderAskLink ->
            -- f you don't have a donation link, you can retain ours for the money will go towards maintaining this template
            "https://donorbox.org/the-trans-dimension"

        --- Footer
        FooterSocial ->
            "Follow us out there"

        FooterInstaLink ->
            "https://www.instagram.com/[Instagram handle]"

        FooterTwitterLink ->
            "https://twitter.com/[Twitter X handle]"

        FooterFacebookLink ->
            "https://www.facebook.com/[Facebook handle]"

        FooterSignupText ->
            "Register for updates"

        FooterSignupEmailPlaceholder ->
            "Your email address"

        FooterSignupButton ->
            "Sign up"

        FooterByLine ->
            "Created by"

        FooterInfoTitle ->
            "[Partnership orgnaisation], c/o GFSC Community CIC"

        FooterInfoCharity ->
            "[Partnership organisation charity reg. or blank]"

        FooterInfoCompany ->
            "[Partnership organisation company reg. or blank]"

        FooterInfoOffice ->
            "[Partnership organisation registered office]"

        FooterCreditTitle ->
            "[Credits or blank]"

        FooterCredit1Text ->
            "[e.g. Illustrations by]"

        FooterCredit1Name ->
            "[Illustrator name]"

        FooterCredit1Link ->
            "https://[illustrator.example.com]"

        FooterCredit2Text ->
            "[Credit 2]"

        FooterCredit2Name ->
            "[Credit 2 name]"

        FooterCredit2Link ->
            "https://[credit2.example.com]"

        FooterCredit3Text ->
            "website by"

        FooterCredit3Name ->
            "GFSC"

        FooterCredit3Link ->
            t GeeksForSocialChangeHomeUrl

        FooterCopyright year ->
            "© " ++ year ++ " [Partnership organisation] All rights reserved."

        --- Index Page
        IndexTitle ->
            "Home"

        IndexMetaDescription ->
            "[Home page meta description] Ex sapien vitae pellentesque sem placerat in id. Placerat in id cursus mi pretium tellus duis. Pretium tellus duis convallis tempus leo eu aenean. "

        IndexIntroTitle ->
            "[Home page intro text] Placerat in id cursus.Pretium tellus duis. Convallis tempus leo eu aenean. "

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
            t PartnershipDescription

        --- Events Page
        EventsTitle ->
            "Events"

        EventsMetaDescription ->
            "Events and activities by and for [who? where?]."

        EventsSummary ->
            "Upcoming events & activities"

        EventsSubHeading ->
            "Upcoming events"

        EventsEmptyTextAll ->
            "There are no upcoming events. Check back for updates!"

        EventsEmptyText ->
            "There are no upcoming events on this date."

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

        GoToNextEvent ->
            "Go to next event"

        --- Event Page
        EventTitle prefix eventName ->
            case prefix of
                Prefixed ->
                    "Event - " ++ eventName

                NoPrefix ->
                    eventName

        EventMetaDescription eventDescription ->
            eventDescription

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
            "[Partner listing meta description] Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos."

        PartnersIntroSummary ->
            "[Partner listing intro summary] Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu."

        PartnersIntroDescription ->
            "[Partner listing intro description] Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos."

        PartnersListHeading ->
            "All partners"

        PartnersListEmpty ->
            "There are currently no [Partnership name] partners"

        PartnersMapAltText ->
            "A map showing the locations of all partners with listed addresses"

        --- Partner Page
        PartnerTitle partnerName ->
            "PlaceCal Partner - " ++ partnerName

        PartnerContactsHeading ->
            "Get in touch"

        PartnerContactsEmptyText ->
            "No contact details provided"

        PartnerAddressHeading ->
            "Address"

        PartnerAddressEmptyText ->
            "No address provided"

        PartnerDescriptionEmptyText partnerName ->
            "Please ask " ++ partnerName ++ " for more information"

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
            "Want to be listed on" ++ t SiteTitle ++ "?"

        JoinUsMetaDescription ->
            "[Join Us page meta description] Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas."

        JoinUsDescription ->
            "[Join Us description]Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas."

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
        NewsItemTitle prefix title ->
            case prefix of
                Prefixed ->
                    "News - " ++ title

                NoPrefix ->
                    title

        NewsItemMetaDescription title author ->
            title ++ " - by " ++ author

        NewsItemReturnButton ->
            "Go back to news"

        --- Privacy Page (note this also comes from markdown)
        PrivacyTitle ->
            "Privacy"

        PrivacyMetaDescription ->
            "Privacy information for " ++ t SiteTitle

        --- 404 Page
        ErrorTitle ->
            "Error 404"

        ErrorMessage ->
            "This page could not be found."

        ErrorButtonText ->
            "Back to home"

        ---
        -- Core text that probably does not need editing
        ---
        SiteLogoSrc ->
            canonicalUrl ++ "images/logos/site_logo_on_primary_background.png"

        GeeksForSocialChangeHomeUrl ->
            "https://gfsc.studio/"

        GoogleMapSearchUrl address ->
            "https://www.google.com/maps/search/?api=1&query=" ++ Url.percentEncode address

        SeeOnGoogleMapText ->
            "See on Google map"

        MapImageAltText locationName ->
            "A map showing the location of " ++ locationName

        PageMetaTitle pageTitle ->
            String.join " | " [ pageTitle, t SiteTitle ]

        FooterPlaceCal ->
            "Powered by PlaceCal"

        AllRegionSelectorLabel ->
            "Everywhere"

        IndexIntroMessage ->
            t PartnershipDescription

        PartnerMetaDescription partnerName partnerSummary ->
            partnerName ++ " - " ++ partnerSummary
