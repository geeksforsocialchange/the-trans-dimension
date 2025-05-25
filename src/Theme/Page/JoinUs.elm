module Theme.Page.JoinUs exposing (Checkbox, FormError, FormInput, FormInputField, FormInputType, FormRequired, FormState(..), Model, Msg(..), blankForm, update, view)

import Constants exposing (joinUsFunctionUrl)
import Copy.Keys exposing (Key(..))
import Copy.Text exposing (t)
import Css exposing (Style, alignItems, auto, batch, block, borderBox, boxSizing, calc, center, color, column, display, displayFlex, em, flexDirection, flexShrink, flexWrap, fontSize, fontWeight, height, important, int, justifyContent, letterSpacing, lineHeight, margin, margin2, marginRight, marginTop, maxWidth, minus, padding2, pct, pseudoElement, px, rem, row, spaceBetween, textAlign, textTransform, uppercase, width, wrap)
import Effect exposing (Effect)
import Html.Styled exposing (Html, button, div, form, input, label, p, span, text, textarea)
import Html.Styled.Attributes exposing (css, placeholder, type_, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Http
import Json.Encode
import RouteBuilder
import Shared
import Skin.Global exposing (colorSecondary, colorWhite, secondaryButtonOnDarkBackgroundStyle, textInputErrorStyle, textInputStyle, viewCheckbox)
import Task
import Theme.GlobalLayout exposing (withMediaSmallDesktopUp, withMediaTabletLandscapeUp, withMediaTabletPortraitUp)


type alias Model =
    { userInput : FormInput
    , formState : FormState
    }


type FormInputType
    = Text
    | Email
    | PhoneNumber


type FormRequired
    = Required
    | Optional


type FormError
    = FieldRequired


type alias FormInput =
    { name : FormInputField
    , email : FormInputField
    , phone : FormInputField
    , job : FormInputField
    , org : FormInputField
    , address : FormInputField
    , ringBack : Checkbox
    , moreInfo : Checkbox
    , message : FormInputField
    }


type alias FormInputField =
    { value : String
    , error : Maybe FormError
    , inputType : FormInputType
    , required : FormRequired
    }


type FormState
    = Inputting
    | ValidationError
    | Sending
    | Sent
    | SendingError


type alias Checkbox =
    { value : Bool
    , required : FormRequired
    }


type Msg
    = UpdateName String
    | UpdateEmail String
    | UpdatePhone String
    | UpdateJob String
    | UpdateOrg String
    | UpdateAddress String
    | UpdateRingBack Bool
    | UpdateMoreInfo Bool
    | UpdateMessage String
    | ErrorName FormError
    | ErrorEmail FormError
    | ErrorMessage FormError
    | SetFormState FormState
    | ClickSend
    | SendEmail
    | ReceiveEmailResponse (Result Http.Error ())


validateForm : FormInput -> List Msg
validateForm formData =
    let
        fieldsToError =
            [ { isEmpty = formData.name.value == "", errorCmd = ErrorName FieldRequired }
            , { isEmpty = formData.email.value == "", errorCmd = ErrorEmail FieldRequired }
            , { isEmpty = formData.message.value == "", errorCmd = ErrorMessage FieldRequired }
            ]
                |> List.filter (\field -> field.isEmpty)
                |> List.map (\field -> field.errorCmd)
    in
    if List.isEmpty fieldsToError then
        [ SendEmail, SetFormState Sending ]

    else
        List.append [ SetFormState ValidationError ] fieldsToError


emailPostRequest : Json.Encode.Value -> Cmd Msg
emailPostRequest bodyValue =
    Http.post
        { url = joinUsFunctionUrl
        , body = Http.jsonBody bodyValue
        , expect = Http.expectWhatever ReceiveEmailResponse
        }


emailBody : FormInput -> Json.Encode.Value
emailBody formData =
    Json.Encode.object
        [ ( "formData"
          , Json.Encode.object
                [ ( "name", Json.Encode.string formData.name.value )
                , ( "email", Json.Encode.string formData.email.value )
                , ( "job", Json.Encode.string formData.job.value )
                , ( "organisation", Json.Encode.string formData.org.value )
                , ( "ringBack", Json.Encode.bool formData.ringBack.value )
                , ( "moreInfo", Json.Encode.bool formData.moreInfo.value )
                , ( "message", Json.Encode.string formData.message.value )
                , ( "phone", Json.Encode.string formData.phone.value )
                , ( "postcode", Json.Encode.string formData.address.value )
                ]
          )
        ]


blankForm : FormInput
blankForm =
    { name =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , email =
        { value = ""
        , error = Nothing
        , inputType = Email
        , required = Required
        }
    , phone =
        { value = ""
        , error = Nothing
        , inputType = PhoneNumber
        , required = Required
        }
    , job =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , org =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , address =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    , ringBack =
        { value = False
        , required = Optional
        }
    , moreInfo =
        { value = False
        , required = Optional
        }
    , message =
        { value = ""
        , error = Nothing
        , inputType = Text
        , required = Required
        }
    }


run : Msg -> Effect Msg
run m =
    Task.perform (always m) (Task.succeed ())
        |> Effect.fromCmd


update :
    RouteBuilder.App data actionData routeParams
    -> Shared.Model
    -> Msg
    -> Model
    -> ( Model, Effect.Effect Msg )
update _ _ msg ({ userInput } as model) =
    case msg of
        UpdateName newString ->
            let
                oldField =
                    userInput.name

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | name = newField } }, Effect.none )

        UpdateEmail newString ->
            let
                oldField =
                    model.userInput.email

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | email = newField } }, Effect.none )

        UpdatePhone newString ->
            let
                oldField =
                    userInput.phone

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | phone = newField } }, Effect.none )

        UpdateJob newString ->
            let
                oldField =
                    userInput.job

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | job = newField } }, Effect.none )

        UpdateOrg newString ->
            let
                oldField =
                    userInput.org

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | org = newField } }, Effect.none )

        UpdateAddress newString ->
            let
                oldField =
                    userInput.address

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | address = newField } }, Effect.none )

        UpdateRingBack newBool ->
            let
                oldField =
                    userInput.ringBack

                newField =
                    { oldField | value = newBool }
            in
            ( { model | userInput = { userInput | ringBack = newField } }, Effect.none )

        UpdateMoreInfo newBool ->
            let
                oldField =
                    userInput.moreInfo

                newField =
                    { oldField | value = newBool }
            in
            ( { model | userInput = { userInput | moreInfo = newField } }, Effect.none )

        UpdateMessage newString ->
            let
                oldField =
                    userInput.message

                newField =
                    { oldField | value = newString }
            in
            ( { model | userInput = { userInput | message = newField } }, Effect.none )

        ErrorName errorType ->
            let
                oldField =
                    userInput.name

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | name = newField } }, Effect.none )

        ErrorEmail errorType ->
            let
                oldField =
                    userInput.email

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | email = newField } }, Effect.none )

        ErrorMessage errorType ->
            let
                oldField =
                    userInput.message

                newField =
                    { oldField | error = Just errorType }
            in
            ( { model | userInput = { userInput | message = newField } }, Effect.none )

        ClickSend ->
            ( model, Effect.batch (List.map (\message -> run message) (validateForm model.userInput)) )

        SendEmail ->
            ( model, emailPostRequest (emailBody model.userInput) |> Effect.fromCmd )

        SetFormState newState ->
            ( { model | formState = newState }, Effect.none )

        ReceiveEmailResponse result ->
            case result of
                Ok _ ->
                    ( { userInput = blankForm, formState = Sent }, Effect.none )

                Err _ ->
                    ( { model | formState = SendingError }, Effect.none )


view :
    { model
        | userInput : FormInput
        , formState : FormState
    }
    -> Html Msg
view state =
    form [ css [ formStyle ], onSubmit ClickSend ]
        [ label [ css [ formItemStyle ] ]
            [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputNameLabel) ]
            , input
                [ css
                    [ if state.userInput.name.error == Nothing then
                        textInputStyle

                      else
                        textInputErrorStyle
                    ]
                , value state.userInput.name.value
                , onInput UpdateName
                ]
                []
            ]
        , label [ css [ formItemStyle ] ]
            [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputEmailLabel) ]
            , input
                [ css
                    [ if state.userInput.email.error == Nothing then
                        textInputStyle

                      else
                        textInputErrorStyle
                    ]
                , value state.userInput.email.value
                , onInput UpdateEmail
                ]
                []
            ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputPhoneLabel) ], input [ css [ textInputStyle ], value state.userInput.phone.value, onInput UpdatePhone ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputJobLabel) ], input [ css [ textInputStyle ], value state.userInput.job.value, onInput UpdateJob ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputOrgLabel) ], input [ css [ textInputStyle ], value state.userInput.org.value, onInput UpdateOrg ] [] ]
        , label [ css [ formItemStyle ] ] [ span [ css [ formLabelStyle ] ] [ text (t JoinUsFormInputAddressLabel) ], input [ css [ textInputStyle ], value state.userInput.address.value, onInput UpdateAddress ] [] ]
        , div [ css [ formCheckboxWrapperStyle ] ]
            [ p [ css [ formCheckboxTitleStyle ] ] [ text (t JoinUsFormCheckboxesLabel) ]
            , div [] (viewCheckbox "joinbox1" (t JoinUsFormCheckbox1) state.userInput.ringBack.value UpdateRingBack)
            , div [] (viewCheckbox "joinbox2" (t JoinUsFormCheckbox2) state.userInput.moreInfo.value UpdateMoreInfo)
            ]
        , label [ css [ formTextAreaItemStyle ] ]
            [ span [ css [ formTextAreaLabelStyle ] ] [ text (t JoinUsFormInputMessageLabel) ]
            , textarea
                [ placeholder (t JoinUsFormInputMessagePlaceholder)
                , css
                    [ if state.userInput.name.error == Nothing then
                        textAreaStyle

                      else
                        textAreaErrorStyle
                    ]
                , value state.userInput.message.value
                , onInput UpdateMessage
                ]
                []
            ]
        , div [ css [ buttonWrapperStyle ] ]
            [ button [ css [ formButtonStyle ], type_ "submit" ]
                [ text
                    (if state.formState == Sending then
                        "Sending..."

                     else
                        t JoinUsFormSubmitButton
                    )
                ]
            ]
        , if state.formState == ValidationError then
            p [ css [ formHelperStyle ] ] [ text "Make sure you have filled in the name, email and address fields." ]

          else
            text ""
        , if state.formState == SendingError then
            p [ css [ formHelperStyle ] ] [ text "Your message failed to send. Please try again." ]

          else
            text ""
        , if state.formState == Sent then
            p [ css [ formHelperStyle ] ] [ text "Your message has been sent! We will get back to you as soon as we can." ]

          else
            text ""
        ]


formStyle : Style
formStyle =
    batch
        [ margin2 (rem 2) (rem 0)
        , withMediaSmallDesktopUp [ maxWidth (px 900), margin2 (rem 2) auto ]
        , withMediaTabletLandscapeUp [ fontSize (rem 1.2) ]
        , withMediaTabletPortraitUp
            [ displayFlex
            , flexWrap wrap
            , justifyContent spaceBetween
            ]
        ]


formItemStyle : Style
formItemStyle =
    batch
        [ displayFlex
        , flexDirection column
        , margin2 (rem 1.5) (rem 0)
        , withMediaTabletPortraitUp
            [ width (calc (pct 50) minus (rem 2))
            , margin (rem 0.75)
            ]
        ]


formTextAreaItemStyle : Style
formTextAreaItemStyle =
    batch
        [ formItemStyle
        , withMediaTabletPortraitUp [ important (width (pct 100)), flexDirection row ]
        ]


formLabelStyle : Style
formLabelStyle =
    batch
        [ display block
        , textAlign center
        , margin2 (rem 0.25) (rem 0)
        , textTransform uppercase
        , fontWeight (int 700)
        , letterSpacing (px 1.6)
        ]


formTextAreaLabelStyle : Style
formTextAreaLabelStyle =
    batch
        [ formLabelStyle
        , withMediaTabletPortraitUp
            [ marginRight (rem 2)
            , flexShrink (int 0)
            , marginTop (rem 0.5)
            ]
        ]


formCheckboxTitleStyle : Style
formCheckboxTitleStyle =
    batch
        [ formLabelStyle
        , withMediaTabletPortraitUp [ marginRight (rem 2) ]
        ]


formCheckboxWrapperStyle : Style
formCheckboxWrapperStyle =
    batch
        [ withMediaTabletPortraitUp
            [ width (pct 100)
            , displayFlex
            , justifyContent center
            , alignItems center
            ]
        ]


textAreaStyle : Style
textAreaStyle =
    batch
        [ textInputStyle
        , boxSizing borderBox
        , height (px 140)
        , margin2 (rem 0.5) (rem 0)
        , padding2 (rem 1) (rem 1.5)
        , pseudoElement "placeholder" [ color colorWhite ]
        , width (pct 100)
        , withMediaTabletPortraitUp [ height (px 100) ]
        ]


textAreaErrorStyle : Style
textAreaErrorStyle =
    batch
        [ textInputErrorStyle
        , margin2 (rem 0.5) (rem 0)
        , padding2 (rem 1) (rem 1.5)
        , height (px 140)
        , width (pct 100)
        , boxSizing borderBox
        , withMediaTabletPortraitUp [ height (px 100) ]
        ]


buttonWrapperStyle : Style
buttonWrapperStyle =
    batch
        [ textAlign center
        , withMediaTabletPortraitUp [ width (pct 100) ]
        ]


formHelperStyle : Style
formHelperStyle =
    batch
        [ color colorSecondary
        , fontSize (rem 0.875)
        , fontWeight (int 600)
        , textAlign center
        , width (pct 100)
        , marginTop (rem 1)
        , lineHeight (em 1.3)
        , withMediaTabletPortraitUp [ fontSize (rem 1) ]
        ]


formButtonStyle : Style
formButtonStyle =
    batch
        [ secondaryButtonOnDarkBackgroundStyle
        , padding2 (rem 0.25) (rem 4)
        , withMediaTabletPortraitUp [ marginTop (rem 1) ]
        ]
