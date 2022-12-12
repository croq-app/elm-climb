module Climb.Systems.Us exposing (..)

import Climb.Levels.Mod as Mod


type Grade
    = Grade Int Mod.DifficultyMod


show : Grade -> String
show _ =
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
    0.0


zero : Grade
zero =
    Grade 0 Mod.Base


next : Grade -> Grade
next grade =
    grade


order : Grade -> Grade -> Order
order (Grade a moda) (Grade b modb) =
    compare ( a, Mod.toLinearScale moda ) ( b, Mod.toLinearScale modb )
