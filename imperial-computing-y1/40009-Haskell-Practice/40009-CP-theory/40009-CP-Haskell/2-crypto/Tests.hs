module Main where

import IC.TestSuite
import Crypto

-- Crypto defines its own gcd, and so does the Prelude, so we have to say
-- which one we mean. This is the same thing the real lab's tests do.
import qualified Prelude
import Prelude hiding (gcd)

-------------------------------------------------------------------------------
-- PART 1

gcdTests :: [TestCase]
gcdTests =
  [ testCase "gcd 0 0"        (Crypto.gcd 0 0        ==> 0)
  , testCase "gcd 0 8"        (Crypto.gcd 0 8        ==> 8)
  , testCase "gcd 8 0"        (Crypto.gcd 8 0        ==> 8)
  , testCase "gcd 3 3"        (Crypto.gcd 3 3        ==> 3)
  , testCase "gcd 12 16"      (Crypto.gcd 12 16      ==> 4)
  , testCase "gcd 16 12"      (Crypto.gcd 16 12      ==> 4)
  , testCase "gcd 65 40"      (Crypto.gcd 65 40      ==> 5)
  , testCase "gcd 735 1239"   (Crypto.gcd 735 1239   ==> 21)
  , testCase "gcd 17 31"      (Crypto.gcd 17 31      ==> 1)
  , testCase "gcd agrees with Prelude.gcd on 1071 462"
      (Crypto.gcd 1071 462 ==> Prelude.gcd 1071 462)
  ]

phiTests :: [TestCase]
phiTests =
  [ testCase "phi 1"   (phi 1   ==> 1)
  , testCase "phi 2"   (phi 2   ==> 1)
  , testCase "phi 6"   (phi 6   ==> 2)
  , testCase "phi 18"  (phi 18  ==> 6)
  , testCase "phi 17"  (phi 17  ==> 16)
  , testCase "phi 31"  (phi 31  ==> 30)
  , testCase "phi 35"  (phi 35  ==> 24)
  , testCase "phi 77"  (phi 77  ==> 60)
  , testCase "phi 100" (phi 100 ==> 40)
  ]

computeCoeffsTests :: [TestCase]
computeCoeffsTests =
  [ testCase "computeCoeffs 0 0"      (computeCoeffs 0 0      ==> (1, 0))
  , testCase "computeCoeffs 0 8"      (computeCoeffs 0 8      ==> (0, 1))
  , testCase "computeCoeffs 12 16"    (computeCoeffs 12 16    ==> (-1, 1))
  , testCase "computeCoeffs 16 12"    (computeCoeffs 16 12    ==> (1, -1))
  , testCase "computeCoeffs 65 40"    (computeCoeffs 65 40    ==> (-3, 5))
  , testCase "computeCoeffs 735 1239" (computeCoeffs 735 1239 ==> (27, -16))
  , testCase "Bezout identity holds for 240 46"
      (let (u, v) = computeCoeffs 240 46 in 240 * u + 46 * v ==> Crypto.gcd 240 46)
  ]

inverseTests :: [TestCase]
inverseTests =
  [ testCase "inverse 11 16" (inverse 11 16 ==> 3)
  , testCase "inverse 4 15"  (inverse 4 15  ==> 4)
  , testCase "inverse 18 35" (inverse 18 35 ==> 2)
  , testCase "inverse 35 18" (inverse 35 18 ==> 17)
  , testCase "inverse 12 91" (inverse 12 91 ==> 38)
  , testCase "inverse 34 91" (inverse 34 91 ==> 83)
  , testCase "inverse 64 91" (inverse 64 91 ==> 64)
  , testCase "inverse 3 7 times 3 is 1 mod 7"
      ((inverse 3 7 * 3) `mod` 7 ==> 1)
  ]

modPowTests :: [TestCase]
modPowTests =
  [ testCase "modPow 0 0 1"                   (modPow 0 0 1                   ==> 0)
  , testCase "modPow 1 1 1"                   (modPow 1 1 1                   ==> 0)
  , testCase "modPow 1 1 2"                   (modPow 1 1 2                   ==> 1)
  , testCase "modPow 13481 11237 6"           (modPow 13481 11237 6           ==> 5)
  , testCase "modPow 8 0 1"                   (modPow 8 0 1                   ==> 0)
  , testCase "modPow 8 0 5"                   (modPow 8 0 5                   ==> 1)
  , testCase "modPow 237 1 1000"              (modPow 237 1 1000              ==> 237)
  , testCase "modPow 859237 1 1000"           (modPow 859237 1 1000           ==> 237)
  , testCase "modPow 33893 2 10000"           (modPow 33893 2 10000           ==> 5449)
  , testCase "modPow 7433893 2 10000"         (modPow 7433893 2 10000         ==> 5449)
  , testCase "modPow 13481503 11237126 46340" (modPow 13481503 11237126 46340 ==> 6629)
  , testCase "modPow 2 10 1000"               (modPow 2 10 1000               ==> 24)
  , testCase "modPow 3 200 13 (naive a^k would overflow)"
      (modPow 3 200 13 ==> 9)
  ]

smallestCoPrimeOfTests :: [TestCase]
smallestCoPrimeOfTests =
  [ testCase "smallestCoPrimeOf 1"   (smallestCoPrimeOf 1   ==> 2)
  , testCase "smallestCoPrimeOf 2"   (smallestCoPrimeOf 2   ==> 3)
  , testCase "smallestCoPrimeOf 12"  (smallestCoPrimeOf 12  ==> 5)
  , testCase "smallestCoPrimeOf 13"  (smallestCoPrimeOf 13  ==> 2)
  , testCase "smallestCoPrimeOf 30"  (smallestCoPrimeOf 30  ==> 7)
  , testCase "smallestCoPrimeOf 210" (smallestCoPrimeOf 210 ==> 11)
  ]

genKeysTests :: [TestCase]
genKeysTests =
  [ testCase "genKeys 2 3"         (genKeys 2 3         ==> ((3, 6), (1, 6)))
  , testCase "genKeys 17 23"       (genKeys 17 23       ==> ((3, 391), (235, 391)))
  , testCase "genKeys 101 83"      (genKeys 101 83      ==> ((3, 8383), (5467, 8383)))
  , testCase "genKeys 401 937"     (genKeys 401 937     ==> ((7, 375737), (213943, 375737)))
  , testCase "genKeys 613 997"     (genKeys 613 997     ==> ((5, 611161), (243821, 611161)))
  , testCase "genKeys 26641 26437" (genKeys 26641 26437 ==> ((7, 704308117), (100607863, 704308117)))
  ]

rsaEncryptTests :: [TestCase]
rsaEncryptTests =
  [ testCase "rsaEncrypt 4321 (3,8383)"           (rsaEncrypt 4321 (3, 8383)           ==> 3694)
  , testCase "rsaEncrypt 324561 (5,611161)"       (rsaEncrypt 324561 (5, 611161)       ==> 133487)
  , testCase "rsaEncrypt 1234 (5,611161)"         (rsaEncrypt 1234 (5, 611161)         ==> 320878)
  , testCase "rsaEncrypt 704308111 (7,704308117)" (rsaEncrypt 704308111 (7, 704308117) ==> 704028181)
  ]

rsaDecryptTests :: [TestCase]
rsaDecryptTests =
  [ testCase "rsaDecrypt 3694 (5467,8383)"                (rsaDecrypt 3694 (5467, 8383)                ==> 4321)
  , testCase "rsaDecrypt 133487 (243821,611161)"          (rsaDecrypt 133487 (243821, 611161)          ==> 324561)
  , testCase "rsaDecrypt 320878 (243821,611161)"          (rsaDecrypt 320878 (243821, 611161)          ==> 1234)
  , testCase "rsaDecrypt 704028181 (100607863,704308117)" (rsaDecrypt 704028181 (100607863, 704308117) ==> 704308111)
  , testCase "RSA round trip with genKeys 101 83"
      (let (pub, priv) = genKeys 101 83 in rsaDecrypt (rsaEncrypt 42 pub) priv ==> 42)
  ]

-------------------------------------------------------------------------------
-- PART 2

toIntTests :: [TestCase]
toIntTests =
  [ testCase "toInt 'a'" (toInt 'a' ==> 0)
  , testCase "toInt 'z'" (toInt 'z' ==> 25)
  , testCase "toInt 'h'" (toInt 'h' ==> 7)
  ]

toCharTests :: [TestCase]
toCharTests =
  [ testCase "toChar 0"  (toChar 0  ==> 'a')
  , testCase "toChar 25" (toChar 25 ==> 'z')
  , testCase "toChar 7"  (toChar 7  ==> 'h')
  ]

addTests :: [TestCase]
addTests =
  [ testCase "add 'a' 'a'" (add 'a' 'a' ==> 'a')
  , testCase "add 'd' 's'" (add 'd' 's' ==> 'v')
  , testCase "add 'w' 't'" (add 'w' 't' ==> 'p')
  , testCase "add 'z' 'b'" (add 'z' 'b' ==> 'a')
  ]

substractTests :: [TestCase]
substractTests =
  [ testCase "substract 'a' 'a'" (substract 'a' 'a' ==> 'a')
  , testCase "substract 'v' 's'" (substract 'v' 's' ==> 'd')
  , testCase "substract 'p' 'w'" (substract 'p' 'w' ==> 't')
  , testCase "substract 'a' 'b' (wraps to z)" (substract 'a' 'b' ==> 'z')
  ]

ecbEncryptTests :: [TestCase]
ecbEncryptTests =
  [ testCase "ecbEncrypt 'w' \"\""        (ecbEncrypt 'w' ""        ==> "")
  , testCase "ecbEncrypt 'd' \"w\""       (ecbEncrypt 'd' "w"       ==> "z")
  , testCase "ecbEncrypt 'x' \"bonjour\"" (ecbEncrypt 'x' "bonjour" ==> "ylkglro")
  , testCase "ecbEncrypt 'k' \"hello\""   (ecbEncrypt 'k' "hello"   ==> "rovvy")
  ]

ecbDecryptTests :: [TestCase]
ecbDecryptTests =
  [ testCase "ecbDecrypt 'w' \"\""        (ecbDecrypt 'w' ""        ==> "")
  , testCase "ecbDecrypt 'd' \"z\""       (ecbDecrypt 'd' "z"       ==> "w")
  , testCase "ecbDecrypt 'x' \"ylkglro\"" (ecbDecrypt 'x' "ylkglro" ==> "bonjour")
  , testCase "ecbDecrypt 'k' \"rovvy\""   (ecbDecrypt 'k' "rovvy"   ==> "hello")
  ]

cbcEncryptTests :: [TestCase]
cbcEncryptTests =
  [ testCase "cbcEncrypt 'w' 'i' \"\""        (cbcEncrypt 'w' 'i' ""        ==> "")
  , testCase "cbcEncrypt 'd' 'i' \"w\""       (cbcEncrypt 'd' 'i' "w"       ==> "h")
  , testCase "cbcEncrypt 'x' 'w' \"bonjour\"" (cbcEncrypt 'x' 'w' "bonjour" ==> "ufpvgxl")
  , testCase "cbcEncrypt 'k' 'q' \"hello\""   (cbcEncrypt 'k' 'q' "hello"   ==> "hvqlj")
  , testCase "cbc differs from ecb on repeated letters"
      (cbcEncrypt 'a' 'b' "aaaa" /= ecbEncrypt 'a' "aaaa" ==> True)
  ]

cbcDecryptTests :: [TestCase]
cbcDecryptTests =
  [ testCase "cbcDecrypt 'w' 'i' \"\""        (cbcDecrypt 'w' 'i' ""        ==> "")
  , testCase "cbcDecrypt 'd' 'i' \"h\""       (cbcDecrypt 'd' 'i' "h"       ==> "w")
  , testCase "cbcDecrypt 'x' 'w' \"ufpvgxl\"" (cbcDecrypt 'x' 'w' "ufpvgxl" ==> "bonjour")
  , testCase "cbcDecrypt 'k' 'q' \"hvqlj\""   (cbcDecrypt 'k' 'q' "hvqlj"   ==> "hello")
  ]

-------------------------------------------------------------------------------
-- EXTENSION

extensionTests :: [TestCase]
extensionTests =
  [ testCase "secret message round-trips through cbc"
      (cbcEncrypt secretKey secretIV (cbcDecrypt secretKey secretIV secretMsg) ==> secretMsg)
  , testCase "secret message decrypts to lower-case letters only"
      (all (`elem` ['a' .. 'z']) (cbcDecrypt secretKey secretIV secretMsg) ==> True)
  , testCase "pairUp [1,2,3]" (pairUp [1, 2, 3] ==> [(1, 2), (2, 3)])
  , testCase "pairUp [7]"     (pairUp [7]       ==> ([] :: [(Int, Int)]))
  , testCase "pairUp []"      (pairUp []        ==> ([] :: [(Int, Int)]))
  -- The next two only compile once pairUp has its polymorphic type.
  -- Uncomment them when you have changed the signature.
  -- , testCase "pairUp \"abc\""   (pairUp "abc"   ==> [('a', 'b'), ('b', 'c')])
  -- , testCase "pairUp [True,False]" (pairUp [True, False] ==> [(True, False)])
  ]

allTests :: [(String, [TestCase])]
allTests =
  [ ("gcd",               gcdTests)
  , ("phi",               phiTests)
  , ("computeCoeffs",     computeCoeffsTests)
  , ("inverse",           inverseTests)
  , ("modPow",            modPowTests)
  , ("smallestCoPrimeOf", smallestCoPrimeOfTests)
  , ("genKeys",           genKeysTests)
  , ("rsaEncrypt",        rsaEncryptTests)
  , ("rsaDecrypt",        rsaDecryptTests)
  , ("toInt",             toIntTests)
  , ("toChar",            toCharTests)
  , ("add",               addTests)
  , ("substract",         substractTests)
  , ("ecbEncrypt",        ecbEncryptTests)
  , ("ecbDecrypt",        ecbDecryptTests)
  , ("cbcEncrypt",        cbcEncryptTests)
  , ("cbcDecrypt",        cbcDecryptTests)
  , ("extension",         extensionTests)
  ]

main :: IO ()
main = runTests allTests
