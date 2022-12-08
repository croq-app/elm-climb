module ListTests exposing (..)

import Climb.Util.List exposing (..)
import Expect as E
import Test exposing (..)


lt3 x =
    x < 3


lst15 =
    [ 1, 2, 3, 4, 5 ]


suite : Test
suite =
    describe "List Utilities"
        [ describe "Util.List.partitionWhile"
            [ test "example" <|
                \_ -> E.equal (partitionWhile lt3 [ 1, 2, 3, 4, 5 ]) ( [ 1, 2 ], [ 3, 4, 5 ] )
            , test "empty list" <|
                \_ -> E.equal (partitionWhile lt3 []) ( [], [] )
            , test "start refusing" <|
                \_ -> E.equal (partitionWhile lt3 [ 3, 4, 5 ]) ( [], [ 3, 4, 5 ] )
            , test "never refuse" <|
                \_ -> E.equal (partitionWhile lt3 [ 0, 1, 2 ]) ( [ 0, 1, 2 ], [] )
            ]
        , describe "Util.List.repeats"
            [ test "example" <|
                \_ -> E.equal (repeats [ 1, 1, 2, 3, 3, 3 ]) [ ( 1, 2 ), ( 2, 1 ), ( 3, 3 ) ]
            , test "non-continguous" <|
                \_ -> E.equal (repeats [ 1, 1, 2, 1, 1, 1 ]) [ ( 1, 2 ), ( 2, 1 ), ( 1, 3 ) ]
            , test "single" <|
                \_ -> E.equal (repeats [ 1, 2, 3 ]) [ ( 1, 1 ), ( 2, 1 ), ( 3, 1 ) ]
            ]
        , describe "Util.List.iterate"
            [ test "example" <|
                \_ -> E.equal (iterate (\x -> 2 * x) 1 5) [ 1, 2, 4, 8, 16, 32 ]
            ]
        ]
