module Climb.Systems.AnyRoute exposing (..)

import Climb.Systems.Br as Br
import Climb.Systems.Fr as Fr
import Climb.Systems.Us as Us


type Grade
    = Us Us.Grade
    | Fr Fr.Grade
    | Br Br.Grade


map : ( Us.Grade -> a, Fr.Grade -> a, Br.Grade -> a ) -> Grade -> a
map ( f, g, h ) grade =
    case grade of
        Us x ->
            f x

        Fr x ->
            g x

        Br x ->
            h x


mapOut : ( Us.Grade -> Us.Grade, Fr.Grade -> Fr.Grade, Br.Grade -> Br.Grade ) -> Grade -> Grade
mapOut ( f, g, h ) grade =
    case grade of
        Us x ->
            Us (f x)

        Fr x ->
            Fr (g x)

        Br x ->
            Br (h x)


show : Grade -> String
show =
    map
        ( Us.show
        , Fr.show
        , Br.show >> (\x -> x ++ " BR")
        )


parse : String -> Maybe Grade
parse st =
    if String.endsWith "BR" st then
        st
            |> String.dropRight 2
            |> String.trim
            |> Br.parse
            |> Maybe.map Br

    else if String.startsWith "5." st then
        Us.parse st |> Maybe.map Us

    else
        Fr.parse st |> Maybe.map Fr


simplify : Grade -> Grade
simplify =
    mapOut ( Us.simplify, Fr.simplify, Br.simplify )


fromLinearScale : Float -> Grade
fromLinearScale x =
    Us (Us.fromLinearScale x)


toLinearScale : Grade -> Float
toLinearScale =
    map ( Us.toLinearScale, Fr.toLinearScale, Br.toLinearScale )


zero : Grade
zero =
    Us Us.zero


next : Grade -> Grade
next =
    mapOut ( Us.next, Fr.next, Br.next )


order : Grade -> Grade -> Order
order a b =
    case ( a, b ) of
        ( Us x, Us y ) ->
            Us.order x y

        ( Fr x, Fr y ) ->
            Fr.order x y

        ( Br x, Br y ) ->
            Br.order x y

        _ ->
            compare (toLinearScale a) (toLinearScale b)
