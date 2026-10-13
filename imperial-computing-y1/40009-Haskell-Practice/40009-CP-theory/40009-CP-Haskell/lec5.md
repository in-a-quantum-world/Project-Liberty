# **Lecture 6**

*"To understand recursion, one must understand recursion"*


## Map Functions

The idea of making a fixed change to each element of a list can be captured byt he map function. The following functions implement a change to each element in the list without using the map function:

```Haskell
ord :: Char -> Int
ord 'a' = 97
ord 'b' = 98

--we coudl use recursion to convert some list of chars to ints

--the following function converts 
--a list of chars to a list of ints
ords :: [Char] -> [Int]
ords [] = []
ords (x:xs) = ord x : ords xs


--the follwoing adds 1 to each integer in a  list
succs :: [Int] -> [Int]
succs [] = []
succs (x:xs) = succ x : succs xs
```

See below the implementation for a caesar cippher

```Haskell

--the following code fails because 
--there is nothing that is done when the string is reduced to just one character
--since xs is 2 or more characters.
encrypt :: String -> String
encrypt xs = map(succ . ord) xs

--consider this
encrypt :: String -> String
encrypt xs = (map chr . map succ . map ord) xs
```


How the map function actually acts:

```Haskell
--map takes a function and a list as an input
map :: (a -> b) -> [a] -> [b]
map f [] = []
map f (x:xs) = f x : map f xs

--really cool function!!!
```


### Map Fusion

Maps have a nice optimisation when using function composition

```Haskell
map g . map f = map (g . f)

--the . operator shows composition. else we would hve to write
map g (map f xs) = map gf xs
    where 
         gf x = g (f x)
```


This is called map fusion and is done by the compiler where it can otpimise the code.


## Filters

The idea of filters has already been seen from list comprehenisons.

```Haskell
[ x | x <- xs, p x]
--this basically says the list contains all x such that the function p(x) is satisfied
-- xs is the list that is being 'comprehended from'
-- i.e. the list from which we are checking each element.
```


We can actually define a filter function

```Haskell
filter :: (a -> Bool) -> [a] -> [a]
-- a -> Bool represents a function ('predicate') whcih will return true or false for each eleemnt

filter p [] = []
filter p (x:xs) 
       | p x = x : filter xs
       | otherwise = filter p xs

```


```Haskell
--this function returns true if even one of the things is satisfied
--else it returns false if none are satisfied

any :: (a -> Bool) -> [a] -> [Bool]

--this will be false ibecause if the program has reached this stage
-- it means all fo the previous elements would have been false
any p [] = False
any p (x:xs)
    | p x = True
    | otherwise = any p xs
```



## Zip function



A zip functions pairs the elements form two lists in order:

```Haskell
zip :: [a] -> [b] -> [(a,b)]

zip (x:xs) (y:ys) = (x,y) : zip xs ys

--if eithre xs or ys or btoh are empty then this means that we 
--need to return empty since one or both have run out of terms
--so we cannot construct any more of the pairs 
zip _ _ = []
--this just stops us from going through aaall the empty versions 

--this is not the same as doing the cartesian product 
```


```Haskell
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith (x:xs) (y:ys) (z:zs) = 9
```

Questions

1. in the zip example, were you assuming that both were the same legnth? because if one is longre is the other you are dropping the elements from the other --- yes thats what we do
2. zipWith???
