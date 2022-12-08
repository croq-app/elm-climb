module RomanTests exposing (..)

import Expect as E
import Fuzz exposing (intRange)
import Test exposing (..)
import Climb.Util.Roman exposing (..)


suite : Test
suite =
    let
        examples =
            [ ( 1, "I" )
            , ( 2, "II" )
            , ( 3, "III" )
            , ( 4, "IV" )
            , ( 10, "X" )
            , ( 50, "L" )
            , ( 42, "XLII" )
            , ( 100, "C" )
            , ( 1912, "MCMXII" )
            , ( 3888, "MMMDCCCLXXXVIII" )
            ]

        extra =
            [ ( 5000, "roman(5000)" )
            , ( 0, "roman(0)" )
            , ( -1, "roman(-1)" )
            ]

        invalidExamples =
            [ "IIII"
            , "IVI"
            , "IVIII"
            , "I+I"
            , " IV "
            , "ABC"
            , "1000"
            ]
    in
    describe "Roman numerals"
        [ describe "Util.Roman.roman" <|
            let
                example ( n, st ) =
                    test ("render " ++ String.fromInt n) <| \_ -> toRoman n |> E.equal st
            in
            List.map example (examples ++ extra)
        , describe "Util.Roman.fromRoman" <|
            let
                valid ( n, st ) =
                    test ("parse " ++ st) <| \_ -> fromRoman st |> E.equal (Just n)

                invalid st =
                    test ("parse " ++ st) <| \_ -> fromRoman st |> E.equal Nothing
            in
            List.map valid examples ++ List.map invalid invalidExamples
        , describe "Decode/encode roundtrip"
            [ fuzz (intRange 1 3999) "roman >> fromRoman = identity (for valid numbers)" <|
                \n -> E.equal (fromRoman (toRoman n)) (Just n)
            ]
        ]
