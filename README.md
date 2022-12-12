# Climbing grades in Elm

`elm-climb` implements parsers, converters and data structures to store climbing grades in Elm.

Currently, it supports the V-scale (Hueco scale) and Fontainbleu for Bouldering and the 
Yosemite Decimal Scale (5.x), French, and Brazillian systems for grading routes.  


# Examples

`elm-climb` uses a pseudo-typeclass API to generalize methods to different styles of climbing grades.

```elm

import Climb.Grades as exposing (..)


fontGrade = 
    parseGrade_ vv "V10"   -- parse a grade in the V-scale 
        |> toGrade font    -- convert to fontainbleau
        |> showGrade font  -- render fontainbleau grade
```

Most methods in the `Climb.Grade` module require a first argument specifying the system used to 
represent the grade. Each system has a corresponding class declared in the module.

* vv: Hueco/Vermin, the v-scale used in boudering. Ex: VB, V0, V11
* font: Fontainbleau scale. Ex: 3, 5a, 7c+
* us: American scale for routes, the Yosemite Decimal System. Ex: 3, 5.9, 5.12d 
* fr: French scale for routes. Similar to Fontainbleau, but not identical. Ex: 4, 5+, 6c, 8a+
* br: Brazillian scale for routes. Somewhat inspired by the French system. Ex: IV, VIsup, 9c