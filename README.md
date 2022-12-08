# Climbing grades in Elm

`elm-climb` implements parsers, converters and data structures to store climbing grades in Elm.

Currently, it supports the V-scale (Hueco scale) and Fontainbleu for Bouldering and the 
Yosemite Decimal Scale (5.x), French, Brazillian systems for grading routes.  


# Examples

`elm-climb` uses a pseudo-typeclass API to generalize methods to different styles of climbing grades.

```elm

import Climb.Grades as exposing (..)



```