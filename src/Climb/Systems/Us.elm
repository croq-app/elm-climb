module Climb.Systems.Us exposing (..)

import Climb.Levels.Mod exposing (..)


type Grade
    = Grade Int DifficultyMod


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
    Grade 0 Base


next : Grade -> Grade
next grade =
    grade
