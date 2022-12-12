module Climb.Systems.Font exposing (..)

import Climb.Levels.ABC as ABC
import Climb.Levels.ABCPlus as Lvl
import Climb.Levels.Mod as Mod
import Climb.Systems.Common exposing (..)


type alias Grade =
    { n : Int
    , cat : Lvl.Level
    , mod : Mod.DifficultyMod
    }


show : Grade -> String
show grade =
    if grade.n <= 3 then
        showFrEasy show simplify next grade

    else if grade.n <= 5 then
        showFrPlus show simplify next grade

    else
        showFrFull show simplify next grade


parse : String -> Maybe Grade
parse _ =
    Nothing


simplify : Grade -> Grade
simplify { n, cat } =
    Grade n cat Mod.Base


toLinearScale : Grade -> Float
toLinearScale _ =
    -1.0


fromLinearScale : Float -> Grade
fromLinearScale _ =
    zero


zero : Grade
zero =
    { n = 1, cat = Lvl.A6, mod = Mod.Base }


next : Grade -> Grade
next { n, cat, mod } =
    if n <= 3 then
        Grade (n + 1) Lvl.A6 mod

    else if n <= 5 && Lvl.toABC cat == ABC.A then
        Grade n Lvl.B6 mod

    else if n <= 5 then
        Grade (n + 1) Lvl.A6 mod

    else
        case Lvl.next cat of
            Just lvl ->
                Grade n lvl mod

            Nothing ->
                Grade (n + 1) Lvl.A6 mod


order : Grade -> Grade -> Order
order a b =
    let
        toTuple { n, cat, mod } =
            ( n, Lvl.toLinearScale cat, Mod.toLinearScale mod )
    in
    compare (toTuple a) (toTuple b)
