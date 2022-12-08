module App exposing (main, update, view)

import Climb.Grades
import Browser
import Html exposing (..)
import Html.Attributes as A exposing (..)
import Html.Events exposing (..)


type Msg
    = SetNum String


type alias Model =
    { boulder : Float
    , route : Float 
    }


update : Msg -> Model -> Model
update msg m =
    case msg of
        SetNum num ->
            case String.toFloat num of
                Just x ->
                    { m | boulder = x }

                _ ->
                    m


main =
    Browser.sandbox
        { init = { boulder = 5.0, route = 5.0 }
        , update = update
        , view = view
        }


view : Model -> Html Msg
view { boulder } =
    let
        grade =
            _Boulder.construct boulder
    in
    div []
        [ h1 [] [ text "Bouldering Grades" ]
        , input [ value (String.fromFloat boulder), onInput SetNum, type_ "range", A.min "-1", A.max "20", step "0.05", style "width" "50rem" ] []
        , table []
            [ tr [] [ th [] [], th [] [ text "Full" ], th [] [ text "Simplified" ] ]
            , tr [] [ td [] [ text "US" ], td [] [ text <| _Boulder.showUS grade ], td [] [ text <| _Boulder.showUS (_Boulder.simplifyUS grade) ] ]
            , tr [] [ td [] [ text "FR" ], td [] [ text <| _Boulder.showFR grade ], td [] [ text <| _Boulder.showFR (_Boulder.simplifyFR grade) ] ]
            , tr [] [ td [] [ text "N" ], td [] [ text <| String.fromFloat boulder ], td [] [] ]
            ]
        , viewConversionTable
        ]


viewConversionTable =
    let
        viewRow i =
            let
                grade =
                    _Boulder.construct (toFloat i)
            in
            tr []
                [ td [] [ text <| _Boulder.showUS grade ]
                , td [] [ text <| _Boulder.showFR grade ]
                ]
    in
    table []
        (tr [] [ th [] [ text "US" ], th [] [ text "FR" ] ]
            :: List.map viewRow (List.range -1 17)
        )
