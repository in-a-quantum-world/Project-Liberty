module Sequences where

import Data.Char (ord, chr)

-- =====================================================================
--  Haskell Lab 1: Sequences
--
--  Fill in every function whose body is currently `undefined`.
--  Only use what was covered in Lecture 1: type signatures, pattern
--  matching, guards, if/then/else, and simple arithmetic. The only
--  library functions you need are `ord` and `chr` (imported above),
--  which convert between a Char and its Unicode code point.
--
--  Load this file in ghci with      ghci Sequences.hs
--  and run the tests with           ghci Tests.hs      then type  main
-- =====================================================================


-- ---------------------------------------------------------------------
--  Part I: simple functions
-- ---------------------------------------------------------------------

-- Returns the larger of two integers.
maxOf2 :: Int -> Int -> Int
maxOf2 x y
       | x > y  = x
       | otherwise = y

-- Returns the largest of three integers. Do not use a built-in max;
-- build it out of maxOf2.
maxOf3 :: Int -> Int -> Int -> Int
maxOf3 x y z
       | maxOf2 x y > z = maxOf2 x y
       | otherwise = z

-- True iff the character is one of '0' .. '9'.
-- Hint: characters can be compared with <= directly, or use ord.
isADigit :: Char -> Bool
isADigit c = '0' <= c && c <= '9'

-- True iff the character is a letter 'a'..'z' or 'A'..'Z'.
isAlpha :: Char -> Bool
isAlpha c
        | ('a' <= c && c <= 'z') || ('A' <= c && c <= 'Z') = True
        | otherwise = False

-- Converts a digit character to the integer it denotes,
-- e.g. digitToInt '7' == 7. You may assume the input is a digit.
-- Hint: look at ord '0'.
digitToInt :: Char -> Int
digitToInt c = ord c - ord '0'

-- Converts a lower-case letter to upper case. Any other character
-- is returned unchanged.
-- Hint: ord 'a' - ord 'A' is a constant.
toUpper :: Char -> Char
toUpper c 
        | 'a' <= c && c <= 'z' = chr(ord c - (ord 'a' - ord 'A'))
        | otherwise = c


-- ---------------------------------------------------------------------
--  Part II: arithmetic and geometric sequences
--
--  An arithmetic sequence with first term a and common difference d is
--      a, a + d, a + 2d, a + 3d, ...
--  A geometric sequence with first term a and common ratio r is
--      a, a*r, a*r^2, a*r^3, ...
--  Terms are numbered from 0, so term 0 is a itself.
-- ---------------------------------------------------------------------

-- The nth term (n >= 0) of the arithmetic sequence a, a+d, a+2d, ...
arithmeticSeq :: Double -> Double -> Int -> Double
arithmeticSeq a d n = a + (fromIntegral n)*d

-- The nth term (n >= 0) of the geometric sequence a, a*r, a*r^2, ...
geometricSeq :: Double -> Double -> Int -> Double
geometricSeq a r n = a * r^(fromIntegral n)

-- The sum of the first n + 1 terms (terms 0 .. n) of the arithmetic
-- sequence. Use the closed-form formula, not a loop or recursion.
arithmeticSeries :: Double -> Double -> Int -> Double
arithmeticSeries a d n = (fromIntegral n + 1) * (2 * a + d*fromIntegral n) / 2

-- The sum of the first n + 1 terms (terms 0 .. n) of the geometric
-- sequence. Use the closed-form formula. Careful: the usual formula
-- divides by (r - 1), so the case r == 1 needs separate treatment.
geometricSeries :: Double -> Double -> Int -> Double
geometricSeries a r n 
                | r==1 = a * (fromIntegral n + 1)
                | otherwise =   a * (r^(n+1) - 1) / (r-1)