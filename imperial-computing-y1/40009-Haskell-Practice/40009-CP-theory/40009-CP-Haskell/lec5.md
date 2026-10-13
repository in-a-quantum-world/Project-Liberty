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
