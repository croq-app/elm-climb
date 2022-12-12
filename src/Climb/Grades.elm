module Climb.Grades exposing
    ( System, Boulder, Route, VGrade, Font, Fr, Us, Br
    , boulder, route, vgrade, font, fr, us, br
    , showGrade, toAnyGrade, toFont, toVGrade
    , parseGrade, parseGrade_, fromAnyGrade, fromVGrade, fromFont, toLinearScale, fromLinearScale
    , simplifyGrade, nextGrade
    , zeroGrade, compareGrades
    )

{-| Climbing grades representation and conversion


## Reference

Conversions are based in two tables

  - <https://en.wikipedia.org/wiki/Grade_(bouldering)>
  - <https://en.wikipedia.org/wiki/Grade_(climbing)>


## Types

@docs System, Boulder, Route, VGrade, Font, Fr, Us, Br


## Grading systems

Required as the first argument of may functions in order to specify the desired grading system.

@docs boulder, route, vgrade, font, fr, us, br


## Converting to strings

@docs showGrade, toAnyGrade, toFont, toVGrade


## Parsing and converting

@docs parseGrade, parseGrade_, fromAnyGrade, fromVGrade, fromFont, toLinearScale, fromLinearScale


## Transforming grades

@docs simplifyGrade, nextGrade


## Special methods

@docs zeroGrade, compareGrades

-}

import Climb.Systems.AnyBoulder as Boulder
import Climb.Systems.AnyRoute as Route
import Climb.Systems.Br as Br
import Climb.Systems.Font as Font
import Climb.Systems.Fr as Fr
import Climb.Systems.Hueco as Hueco
import Climb.Systems.Us as Us


{-| Collect methods for a GradeT pseudo-typeclass
-}
type System t
    = System
        { fromLinearScale : Float -> t
        , toLinearScale : t -> Float
        , show : t -> String
        , parse : String -> Maybe t
        , simplify : t -> t
        , zero : t
        , next : t -> t
        , order : t -> t -> Order
        }


{-| Generic Route grade. Sum type of all supported grades
-}
type alias Route =
    Route.Grade


{-| Generic Boulder grade. Sum type of all supported grades
-}
type alias Boulder =
    Boulder.Grade


{-| American V-grades system
-}
type alias VGrade =
    Hueco.Grade


{-| Fontainebleau system
-}
type alias Font =
    Font.Grade


{-| American Decimal system for grading routes
-}
type alias Us =
    Us.Grade


{-| French system for grading routes
-}
type alias Fr =
    Fr.Grade


{-| Brazilian system for grading routes
-}
type alias Br =
    Br.Grade


{-| Generic bouldering grade.
-}
boulder : System Boulder
boulder =
    System
        { fromLinearScale = Boulder.fromLinearScale
        , toLinearScale = Boulder.toLinearScale
        , show = Boulder.show
        , parse = Boulder.parse
        , simplify = Boulder.simplify
        , zero = Boulder.zero
        , next = Boulder.next
        , order = Boulder.order
        }


{-| Generic route grade.
-}
route : System Route
route =
    System
        { fromLinearScale = Route.fromLinearScale
        , toLinearScale = Route.toLinearScale
        , show = Route.show
        , parse = Route.parse
        , simplify = Route.simplify
        , zero = Route.zero
        , next = Route.next
        , order = Route.order
        }


{-| The Hueco/Vermin system used for bouldering in the USA, .i.e., the v-grades.
-}
vgrade : System VGrade
vgrade =
    System
        { fromLinearScale = Hueco.fromLinearScale
        , toLinearScale = Hueco.toLinearScale
        , show = Hueco.show
        , parse = Hueco.parse
        , simplify = Hueco.simplify
        , zero = Hueco.zero
        , next = Hueco.next
        , order = Hueco.order
        }


{-| French Fontainbleau system for bouldering.
-}
font : System Font
font =
    System
        { fromLinearScale = Font.fromLinearScale
        , toLinearScale = Font.toLinearScale
        , show = Font.show
        , parse = Font.parse
        , simplify = Font.simplify
        , zero = Font.zero
        , next = Font.next
        , order = Font.order
        }


{-| The Yosemite Decimal System used in the USA.
-}
us : System Us
us =
    System
        { fromLinearScale = Us.fromLinearScale
        , toLinearScale = Us.toLinearScale
        , show = Us.show
        , parse = Us.parse
        , simplify = Us.simplify
        , zero = Us.zero
        , next = Us.next
        , order = Us.order
        }


{-| The French system.
-}
fr : System Fr
fr =
    System
        { fromLinearScale = Fr.fromLinearScale
        , toLinearScale = Fr.toLinearScale
        , show = Fr.show
        , parse = Fr.parse
        , simplify = Fr.simplify
        , zero = Fr.zero
        , next = Fr.next
        , order = Fr.order
        }


{-| The Brazillian system.
-}
br : System Br
br =
    System
        { fromLinearScale = Br.fromLinearScale
        , toLinearScale = Br.toLinearScale
        , show = Br.show
        , parse = Br.parse
        , simplify = Br.simplify
        , zero = Br.zero
        , next = Br.next
        , order = Br.order
        }



-------------------------------------------------------------------------------
--- Methods
-------------------------------------------------------------------------------


{-| Render grade as a string
-}
showGrade : System a -> a -> String
showGrade (System tt) =
    tt.show


{-| Render Bouldering grade in destT format.

The boolean argument tells if the final grade should be simplified or
not in the final rendering.

-}
toAnyGrade : System a -> System b -> Bool -> b -> String
toAnyGrade ss tt isSimple a =
    a
        |> toLinearScale tt
        |> fromLinearScale ss
        |> askSimplify_ ss isSimple
        |> showGrade ss


{-| Alias to `toGrade vv`
-}
toVGrade : System a -> Bool -> a -> String
toVGrade =
    toAnyGrade vgrade


{-| Alias to `toGrade font`
-}
toFont : System a -> Bool -> a -> String
toFont =
    toAnyGrade font


{-| Convert from the floating point universal scale

For bouldering, the floating point scale is based in the American
Hueco/Vermin system. i.e. `fromLinearScale 10.0` refers to V10,
which is 7c+ in Fontainbleau scale.

-}
fromLinearScale : System a -> Float -> a
fromLinearScale (System tt) x =
    tt.fromLinearScale x


{-| Convert to the floating point universal scale

This is useful to convert to different grading systems or
saving in a database.

    font =
        grade
            |> Font.toLinearScale
            |> Hueco.fromLinearScale

-}
toLinearScale : System a -> a -> Float
toLinearScale (System tt) a =
    tt.toLinearScale a


{-| Try to read string in the src format.
-}
fromAnyGrade : System a -> System b -> String -> Maybe b
fromAnyGrade ss tt st =
    st
        |> parseGrade ss
        |> Maybe.map (\a -> a |> toLinearScale ss |> fromLinearScale tt)


{-| Alias to `fromGrade vv`
-}
fromVGrade : System a -> String -> Maybe a
fromVGrade =
    fromAnyGrade vgrade


{-| Alias to `fromGrade font`
-}
fromFont : System a -> String -> Maybe a
fromFont =
    fromAnyGrade font


{-| Parse string representing grade

    parseGrade vv "V10/11" ==> Just (Grade 10 HalfwayNext)

-}
parseGrade : System a -> String -> Maybe a
parseGrade (System tt) st =
    tt.parse st


{-| Parse string representing grade.

If parsing fails, return the default base/zero grade. This should
never be used to handle user input.

    parse_ vv "V10/11" ==> Grade 10 HalfwayNext

-}
parseGrade_ : System a -> String -> a
parseGrade_ tt st =
    parseGrade tt st |> Maybe.withDefault (zeroGrade tt)


{-| Remove modifiers from grade

    parseGrade_ vv "V10+"
        |> simplify vv
        ==> Grade 10 Base

-}
simplifyGrade : System a -> a -> a
simplifyGrade (System tt) a =
    tt.simplify a


{-| Next full grade ignoring modifiers
-}
nextGrade : System a -> a -> a
nextGrade (System tt) g =
    tt.next g


{-| The lowest grade in the scale

Different scales may start from different levels

-}
zeroGrade : System a -> a
zeroGrade (System tt) =
    tt.zero


{-| Compare two grades

This can be used in sorting algorithms like `List.sortWith`

-}
compareGrades : System a -> a -> a -> Order
compareGrades (System tt) a b =
    tt.order a b



-------------------------------------------------------------------------------
--- Auxiliary functions
-------------------------------------------------------------------------------


askSimplify_ : System c -> Bool -> c -> c
askSimplify_ tt isSimple a =
    if isSimple then
        simplifyGrade tt a

    else
        a
