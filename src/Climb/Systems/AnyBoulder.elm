module Climb.Systems.AnyBoulder exposing (..)

import Climb.Systems.Font as Font
import Climb.Systems.Hueco as Hueco


type Grade
    = Hueco Hueco.Grade
    | Font Font.Grade


map : ( Hueco.Grade -> a, Font.Grade -> a ) -> Grade -> a
map ( f, g ) grade =
    case grade of
        Hueco x ->
            f x

        Font x ->
            g x


mapOut : ( Hueco.Grade -> Hueco.Grade, Font.Grade -> Font.Grade ) -> Grade -> Grade
mapOut ( f, g ) grade =
    case grade of
        Hueco x ->
            Hueco (f x)

        Font x ->
            Font (g x)


show : Grade -> String
show =
    map ( Hueco.show, Font.show )


parse : String -> Maybe Grade
parse st =
    if String.startsWith "V" st then
        Hueco.parse st |> Maybe.map Hueco

    else
        Font.parse st |> Maybe.map Font


simplify : Grade -> Grade
simplify =
    mapOut ( Hueco.simplify, Font.simplify )


fromLinearScale : Float -> Grade
fromLinearScale x =
    Hueco (Hueco.fromLinearScale x)


toLinearScale : Grade -> Float
toLinearScale =
    map ( Hueco.toLinearScale, Font.toLinearScale )


zero : Grade
zero =
    Hueco Hueco.zero


next : Grade -> Grade
next =
    mapOut ( Hueco.next, Font.next )


order : Grade -> Grade -> Order
order a b =
    case ( a, b ) of
        ( Hueco x, Hueco y ) ->
            Hueco.order x y

        ( Font x, Font y ) ->
            Font.order x y

        _ ->
            compare (toLinearScale a) (toLinearScale b)
