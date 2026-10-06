module Crypto where

import Data.Char

import Prelude hiding (gcd)

{-
  Haskell Lab 2: Cryptography

  Fill in every function whose body is `undefined`.

  Topics this lab exercises (lectures 1 and 2):
    recursion, tuples, where clauses, list comprehensions, guards,
    tail recursion with an accumulating parameter, parametric
    polymorphism (in the helper at the bottom), Strings as [Char].

  The advantage of symmetric encryption schemes like AES is that they are
  efficient and can encrypt data of arbitrary size. The problem is how to
  share the key. The flaw of RSA is that it is slow and can only encrypt
  data smaller than the modulus n, usually around 1024 bits (64 bits for
  this exercise, since Int is 64 bits).

  In practice a message is encrypted with a symmetric scheme under a key k,
  and only k, which is small, is exchanged using RSA.

  Note: the import of Prelude above hides the built-in gcd, since you are
  writing your own. In ghci, if you want the built-in one for comparison,
  it is available as Prelude.gcd.
-}

-------------------------------------------------------------------------------
-- PART 1 : asymmetric encryption (RSA)

-- Greatest common divisor, by Euclid's algorithm:
--   gcd a 0 = a
--   gcd a b = gcd b (a mod b)
-- Pre: a >= 0, b >= 0
gcd :: Int -> Int -> Int
gcd a b
  | b == 0 = abs a
  | a < 0 || b < 0 = gcd (abs a) (abs b)
  | otherwise = gcd b (a `mod` b)

-- Euler's totient function: the number of integers x with 1 <= x <= m
-- that are coprime with m (i.e. gcd x m == 1).
-- Use a list comprehension and your gcd.
-- Pre: m >= 1. (phi 1 = 1 since gcd 1 1 = 1.)
phi :: Int -> Int
phi m
    | m < 0  = error "prerequisitie that m is less than one not satisfied"
    | otherwise = [x | x <- [1.. m], gcd x m == 1]
    

-- Extended Euclid. Returns the Bezout coefficients (u, v) such that
--   a * u + b * v = gcd a b
-- Hint: by the same recursion as gcd. If computeCoeffs b (a mod b)
-- gives (u', v') with  b*u' + (a mod b)*v' = d, then since
-- a mod b = a - q*b where q = a div b, you can rearrange to find
-- the coefficients of a and b. Use quotRem or divMod to get q and r
-- as a tuple, and a where clause.
-- Base case: computeCoeffs a 0 = (1, 0).
-- Pre: a >= 0, b >= 0
computeCoeffs :: Int -> Int -> (Int, Int)
computeCoeffs a b
              | a < 0 || b < 0 = computeCoeffs (abs a) (abs b)
              | otherwise = 0

-- Inverse of a modulo m: the x in [0, m) with a * x mod m == 1.
-- Use computeCoeffs. Remember u may be negative; `mod` in Haskell
-- always gives a non-negative result for a positive modulus.
-- Pre: gcd a m == 1
inverse :: Int -> Int -> Int
inverse a m
  = undefined

-- Fast modular exponentiation: a^k mod m.
-- Do NOT compute a^k and then reduce: it overflows Int for the test
-- cases. Instead use repeated squaring:
--   if k is even, a^k = (a^2)^(k/2)
--   if k is odd,  a^k = a * a^(k-1)
-- reducing mod m at every step so numbers stay below m^2.
-- Pre: 0 <= a < m, k >= 0, m >= 1
modPow :: Int -> Int -> Int -> Int
modPow a k m
       | (a < 0 || a >= m) || (k < 0) || (m < 1) = error "does not satisyf original constraints"
       | 
       | k `mod` 2 == 0  = 
       | k `mod` 2 == 1  =

-- The smallest integer e >= 2 that is coprime with the argument.
-- Hint: a list comprehension over [2 ..] filtered by gcd, taking the
-- head; or a tail-recursive helper that counts up from 2.
-- Pre: x >= 1
smallestCoPrimeOf :: Int -> Int
smallestCoPrimeOf x
                  | x < 0 = error "prerequisite not satisfied"
                  | otherwise = [y | y <- [2.. x], (y >= 2 && gcd x y == 1)]

-- Generates RSA key pairs (public, private) = ((e, n), (d, n))
-- from two distinct primes p and q:
--   n = p * q
--   e = smallestCoPrimeOf ((p - 1) * (q - 1))
--   d = inverse e ((p - 1) * (q - 1))
genKeys :: Int -> Int -> ((Int, Int), (Int, Int))
genKeys p q
  = undefined

-- RSA encryption: c = x^e mod n, given the public key (e, n)
rsaEncrypt :: Int -> (Int, Int) -> Int
rsaEncrypt x (e, n)
  = undefined

-- RSA decryption: x = c^d mod n, given the private key (d, n)
rsaDecrypt :: Int -> (Int, Int) -> Int
rsaDecrypt c (d, n)
  = undefined

-------------------------------------------------------------------------------
-- PART 2 : symmetric encryption (block ciphers on letters)

-- Position of a lower-case letter in the alphabet: toInt 'a' == 0
toInt :: Char -> Int
toInt c
  = undefined

-- The n-th lower-case letter: toChar 0 == 'a'
-- Pre: 0 <= n <= 25
toChar :: Int -> Char
toChar n
  = undefined

-- "Adds" two letters, wrapping round the alphabet:
--   add 'd' 's' == 'v'   (3 + 18 = 21)
--   add 'w' 't' == 'p'   (22 + 19 = 41, mod 26 = 15)
add :: Char -> Char -> Char
add c1 c2
  = undefined

-- "Subtracts" the second letter from the first, wrapping round.
-- (The spelling 'substract' is the one the lab uses.)
substract :: Char -> Char -> Char
substract c1 c2
  = undefined

-- The next functions give two modes of operation for a block cipher
-- whose block is a single letter and whose encryption function is add.

-- ECB (electronic codebook): every letter is encrypted independently
-- with the key k.
ecbEncrypt :: Char -> String -> String
ecbEncrypt k s
  = undefined

ecbDecrypt :: Char -> String -> String
ecbDecrypt k s
  = undefined

-- CBC (cipher block chaining): each plaintext letter is first added to
-- the PREVIOUS ciphertext letter (or the initialisation vector iv for
-- the first one), then encrypted with k:
--   c_0 = add (add m_0 iv) k
--   c_i = add (add m_i c_(i-1)) k
-- Arguments are key, iv, message.
cbcEncrypt :: Char -> Char -> String -> String
cbcEncrypt k iv s
  = undefined

cbcDecrypt :: Char -> Char -> String -> String
cbcDecrypt k iv s
  = undefined

-------------------------------------------------------------------------------
-- EXTENSION

-- The following was produced with cbcEncrypt using secretKey and
-- secretIV. Recover the plaintext in ghci once cbcDecrypt works:
--
--   ghci> cbcDecrypt secretKey secretIV secretMsg
--
-- Tests.hs only checks that your decryption round-trips, so it will not
-- spoil the answer.
secretKey, secretIV :: Char
secretKey = 'j'
secretIV  = 'm'

secretMsg :: String
secretMsg = "reysebxkknyoxebeudhueebuhdofdtggqkhslwmvmizvkgdikkrgtpcclneappqzsfmnbbytvaxvvmhuveamnawizvkrorrsfznpfsormwjjxuuwdfkh"

-- Polymorphism practice. This function should work for ANY element type:
-- it returns the list of (previous, current) pairs of a list, so
--   pairUp "abc"      == [('a','b'), ('b','c')]
--   pairUp [1, 2, 3]  == [(1, 2), (2, 3)]
--   pairUp "a"        == []
-- Give it the most general type signature you can, replacing the one
-- below. (Hint: it has no constraint at all.) This is the shape of
-- computation that CBC performs when decrypting.
pairUp :: [Int] -> [(Int, Int)]
pairUp xs
  = undefined
