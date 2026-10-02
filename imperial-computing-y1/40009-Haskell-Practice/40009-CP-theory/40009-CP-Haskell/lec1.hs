-- module name needs to be capitalised too!
module Intro where 

--importing natural numbes from numeric library
import Numeric.Natural 

--fibonacci numbers 
-- type annotation
fib :: Integer -> Integer

--setting base cases here 
fib 0 = 1
fib 1 = 1

-- using guards 
fib n 
    | n < 0 = undefined 
    | otherwise = fib(n-1) + fib(n-2)



-- a better way of handling negative numbers is to fully rule them out by usinga  more appropriate type
-- we can use Natural instead of integer

fib' :: Natural -> Natural
fib' 0 = 1
fib' 1 = 1

-- again using guards for the patern matching
fib' n
     | n < 0 = undefined
     | otherwise = fib'(n-1) + fib'(n-2)



--generic function practice
-- when calling function you dont need brackets unless the arg is negative OR if you are adding something onto the arg value
square :: Integer -> Integer
square n
       | n < 0 = undefined
       | otherwise = n*n
--when passing stuff into haskell it is worth being aware of how the function is actually evalauted
--haskell will substitute the thing passed immediately into the function in the exact form that it occured in

--eg square(1+2) = (1+2)*(1+2)


add :: Integer -> Integer -> Integer
add x y = x + y

-- be careful as negative exponents are not typically allowed in haskell! at least from what i found. 
power :: Integer -> Integer
power x = x ^ x


basic :: String -> String
basic _ = "Hello World!"

ignore :: Integer -> Integer
ignore _  = 2
--this will take an integer as an input, ignore it entirely and return 2 regardless of the integer input
--obviously you will get a type error if you enter anything that is not an integer


factorial :: Integer -> Integer

factorial 1 = 1
factorial n
          | n < 0 = undefined
          | otherwise = n*factorial(n-1)


