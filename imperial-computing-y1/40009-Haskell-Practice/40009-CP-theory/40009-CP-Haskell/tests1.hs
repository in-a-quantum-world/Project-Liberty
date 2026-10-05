module Main where

import IC.TestSuite
import Sequences

-- The sequence functions return Doubles, so compare with a tolerance
-- rather than exact equality.
approx :: Double -> Double -> Bool
approx x y = abs (x - y) < 1e-9

-- Wraps a Double result so that `==` means "within tolerance".
newtype Approx = Approx Double
instance Eq Approx where
  Approx x == Approx y = approx x y
instance Show Approx where
  show (Approx x) = show x

(~~>) :: Double -> Double -> (String -> TestCase)
actual ~~> expected = Approx actual ==> Approx expected

maxOf2Tests :: [TestCase]
maxOf2Tests =
  [ testCase "maxOf2 1 2"       (maxOf2 1 2       ==> 2)
  , testCase "maxOf2 2 1"       (maxOf2 2 1       ==> 2)
  , testCase "maxOf2 7 7"       (maxOf2 7 7       ==> 7)
  , testCase "maxOf2 (-3) (-5)" (maxOf2 (-3) (-5) ==> (-3))
  , testCase "maxOf2 0 (-1)"    (maxOf2 0 (-1)    ==> 0)
  ]

maxOf3Tests :: [TestCase]
maxOf3Tests =
  [ testCase "maxOf3 1 2 3"          (maxOf3 1 2 3          ==> 3)
  , testCase "maxOf3 3 2 1"          (maxOf3 3 2 1          ==> 3)
  , testCase "maxOf3 1 3 2"          (maxOf3 1 3 2          ==> 3)
  , testCase "maxOf3 5 5 5"          (maxOf3 5 5 5          ==> 5)
  , testCase "maxOf3 (-1) (-2) (-3)" (maxOf3 (-1) (-2) (-3) ==> (-1))
  ]

isADigitTests :: [TestCase]
isADigitTests =
  [ testCase "isADigit '0'" (isADigit '0' ==> True)
  , testCase "isADigit '5'" (isADigit '5' ==> True)
  , testCase "isADigit '9'" (isADigit '9' ==> True)
  , testCase "isADigit 'a'" (isADigit 'a' ==> False)
  , testCase "isADigit ' '" (isADigit ' ' ==> False)
  , testCase "isADigit '/'" (isADigit '/' ==> False)   -- the char just before '0'
  , testCase "isADigit ':'" (isADigit ':' ==> False)   -- the char just after '9'
  ]

isAlphaTests :: [TestCase]
isAlphaTests =
  [ testCase "isAlpha 'a'" (isAlpha 'a' ==> True)
  , testCase "isAlpha 'z'" (isAlpha 'z' ==> True)
  , testCase "isAlpha 'A'" (isAlpha 'A' ==> True)
  , testCase "isAlpha 'Z'" (isAlpha 'Z' ==> True)
  , testCase "isAlpha 'M'" (isAlpha 'M' ==> True)
  , testCase "isAlpha '3'" (isAlpha '3' ==> False)
  , testCase "isAlpha '_'" (isAlpha '_' ==> False)
  , testCase "isAlpha '['" (isAlpha '[' ==> False)     -- between 'Z' and 'a'
  , testCase "isAlpha '`'" (isAlpha '`' ==> False)     -- the char just before 'a'
  ]

digitToIntTests :: [TestCase]
digitToIntTests =
  [ testCase "digitToInt '0'" (digitToInt '0' ==> 0)
  , testCase "digitToInt '1'" (digitToInt '1' ==> 1)
  , testCase "digitToInt '7'" (digitToInt '7' ==> 7)
  , testCase "digitToInt '9'" (digitToInt '9' ==> 9)
  ]

toUpperTests :: [TestCase]
toUpperTests =
  [ testCase "toUpper 'a'" (toUpper 'a' ==> 'A')
  , testCase "toUpper 'z'" (toUpper 'z' ==> 'Z')
  , testCase "toUpper 'q'" (toUpper 'q' ==> 'Q')
  , testCase "toUpper 'A'" (toUpper 'A' ==> 'A')
  , testCase "toUpper '4'" (toUpper '4' ==> '4')
  , testCase "toUpper '!'" (toUpper '!' ==> '!')
  ]

arithmeticSeqTests :: [TestCase]
arithmeticSeqTests =
  [ testCase "arithmeticSeq 0 1 0"     (arithmeticSeq 0 1 0     ~~> 0)
  , testCase "arithmeticSeq 0 1 5"     (arithmeticSeq 0 1 5     ~~> 5)
  , testCase "arithmeticSeq 2 3 4"     (arithmeticSeq 2 3 4     ~~> 14)
  , testCase "arithmeticSeq 10 (-2) 3" (arithmeticSeq 10 (-2) 3 ~~> 4)
  , testCase "arithmeticSeq 1.5 0.5 3" (arithmeticSeq 1.5 0.5 3 ~~> 3)
  ]

geometricSeqTests :: [TestCase]
geometricSeqTests =
  [ testCase "geometricSeq 1 2 0"      (geometricSeq 1 2 0      ~~> 1)
  , testCase "geometricSeq 1 2 10"     (geometricSeq 1 2 10     ~~> 1024)
  , testCase "geometricSeq 3 2 3"      (geometricSeq 3 2 3      ~~> 24)
  , testCase "geometricSeq 2 (-1) 3"   (geometricSeq 2 (-1) 3   ~~> (-2))
  , testCase "geometricSeq 100 0.5 2"  (geometricSeq 100 0.5 2  ~~> 25)
  , testCase "geometricSeq 7 1 50"     (geometricSeq 7 1 50     ~~> 7)
  ]

arithmeticSeriesTests :: [TestCase]
arithmeticSeriesTests =
  [ testCase "arithmeticSeries 0 1 0"     (arithmeticSeries 0 1 0     ~~> 0)
  , testCase "arithmeticSeries 1 1 9"     (arithmeticSeries 1 1 9     ~~> 55)
  , testCase "arithmeticSeries 2 3 4"     (arithmeticSeries 2 3 4     ~~> 40)
  , testCase "arithmeticSeries 10 (-2) 5" (arithmeticSeries 10 (-2) 5 ~~> 30)
  , testCase "arithmeticSeries 0 0 100"   (arithmeticSeries 0 0 100   ~~> 0)
  , testCase "arithmeticSeries 1.5 0.5 3" (arithmeticSeries 1.5 0.5 3 ~~> 9)
  ]

geometricSeriesTests :: [TestCase]
geometricSeriesTests =
  [ testCase "geometricSeries 1 2 0"     (geometricSeries 1 2 0     ~~> 1)
  , testCase "geometricSeries 1 2 3"     (geometricSeries 1 2 3     ~~> 15)
  , testCase "geometricSeries 3 2 3"     (geometricSeries 3 2 3     ~~> 45)
  , testCase "geometricSeries 1 0.5 3"   (geometricSeries 1 0.5 3   ~~> 1.875)
  , testCase "geometricSeries 2 (-1) 3"  (geometricSeries 2 (-1) 3  ~~> 0)
  , testCase "geometricSeries 5 1 9"     (geometricSeries 5 1 9     ~~> 50)   -- r == 1 case
  , testCase "geometricSeries 4 1 0"     (geometricSeries 4 1 0     ~~> 4)    -- r == 1 case
  ]

allTests :: [(String, [TestCase])]
allTests =
  [ ("maxOf2",           maxOf2Tests)
  , ("maxOf3",           maxOf3Tests)
  , ("isADigit",         isADigitTests)
  , ("isAlpha",          isAlphaTests)
  , ("digitToInt",       digitToIntTests)
  , ("toUpper",          toUpperTests)
  , ("arithmeticSeq",    arithmeticSeqTests)
  , ("geometricSeq",     geometricSeqTests)
  , ("arithmeticSeries", arithmeticSeriesTests)
  , ("geometricSeries",  geometricSeriesTests)
  ]

main :: IO ()
main = runTests allTests