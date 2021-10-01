module Main exposing (main)

import Browser
import Browser.Dom
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)
import Task


type alias Model =
    { searchString : String
    , latestResult : String
    }


initialModel : Model
initialModel =
    { searchString = ""
    , latestResult = ""
    }


type Msg
    = SearchStringChanged String
    | SearchPressed
    | SearchForElement (Result Browser.Dom.Error Browser.Dom.Element)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchStringChanged newString ->
            ( { model | searchString = newString }, Cmd.none )

        SearchPressed ->
            ( model
            , Task.attempt SearchForElement (Browser.Dom.getElement model.searchString)
            )

        SearchForElement result ->
            case result of
                Ok _ ->
                    ( { model | latestResult = "found" }, Cmd.none )

                Err _ ->
                    ( { model | latestResult = "not found" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ Html.input
            [ Html.Events.onInput SearchStringChanged
            , Html.Attributes.value model.searchString
            ]
            []
        , button [ onClick SearchPressed ] [ text "search" ]
        , text model.latestResult
        , div [ id "inside" ] []
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
