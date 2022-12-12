module Climb.Systems.Fr exposing (..)

import Climb.Levels.ABC as ABC
import Climb.Levels.ABCPlus as Lvl exposing (..)
import Climb.Levels.Mod as Mod


type alias Grade =
    { n : Int
    , cat : Lvl.Level
    , mod : Mod.DifficultyMod
    }


show : Grade -> String
show grade =
    let
        { n, cat, mod } =
            grade
    in
    if n <= 3 then
        -- Easy grades 1 to 3 ignore category
        case Mod.showModSoftHard mod of
            Just suffix ->
                String.fromInt n ++ suffix

            Nothing ->
                String.fromInt n ++ "/" ++ show (grade |> simplify |> next)

    else if n <= 5 then
        -- Intermediate grades 4 and 5 ignore the plus modifier
        case ( Mod.showModSoftHard mod, Lvl.toABC cat ) of
            ( Just suffix, lvl ) ->
                String.fromInt n ++ ABC.show lvl ++ suffix

            ( Nothing, lvl ) ->
                case ABC.showHalfWay lvl of
                    Just suffix ->
                        String.fromInt n ++ suffix

                    Nothing ->
                        show (simplify grade) ++ "/" ++ show (simplify grade |> next)

    else
        "#todo"


parse : String -> Maybe Grade
parse _ =
    Nothing


simplify : Grade -> Grade
simplify g =
    g


fromLinearScale : Float -> Grade
fromLinearScale _ =
    zero


toLinearScale : Grade -> Float
toLinearScale _ =
    -1.0


zero : Grade
zero =
    Grade 1 A6 Mod.Base


next : Grade -> Grade
next { n, cat, mod } =
    if n <= 3 then
        Grade (n + 1) A6 mod

    else if n <= 5 && Lvl.toABC cat == ABC.A then
        Grade n B6 mod

    else if n <= 5 && Lvl.toABC cat == ABC.B then
        Grade n C6 mod

    else if n <= 5 && Lvl.toABC cat == ABC.C then
        Grade (n + 1) A6 mod

    else if cat == A6 then
        Grade n A6Plus mod

    else if cat == A6Plus then
        Grade n B6 mod

    else if cat == B6 then
        Grade n B6Plus mod

    else if cat == B6Plus then
        Grade n C6 mod

    else if cat == C6 then
        Grade n C6Plus mod

    else
        Grade (n + 1) A6 mod


order : Grade -> Grade -> Order
order a b =
    let
        toTuple { n, cat, mod } =
            ( n, Lvl.toLinearScale cat, Mod.toLinearScale mod )
    in
    compare (toTuple a) (toTuple b)
