

# **Lecture 5**

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
zipWith (x:xs) (y:ys) = f x y : zipWith f xs ys
zipWith _ _ _ = []
```

We can also define zip using zipWith

```Haskell
zip xs ys = zipWith (\x y -> (x,y)) xs ys

--or even we could write more concisely:
zip = zipWith(\x y -> (x,y))
```



### Comma operator

```Haskell
(,) :: a -> b -> (a,b)
(,) x y = (x,y)
```


### Unzip function

```Haskell
unzip :: [(a,b)] -> ([a],[b])
unzip [] = ([],[])
unzip ((x,y): xys) = (x:xs, y:ys)
      where 
          (xs,ys) = unzip(x,y)
```




## Concat

Another useful function on lists is the concat function (name is slightly misleading from other languages! we just squash everything into one 1D list)

```Haskell
concat :: [[a]] -> [a]
concat [] = []
concat (xs:xss) = xs ++ concat xss
```



## Fold function

A lot fo these functions we have looked at cn actually be implemented with fold functions, where you have to go from left to right or vice versa, performing an operation iteratively.

```Haskell
sum :: [Int] -> Int
sum [] = []
sum (x:xs) = x + sum xs

--here all the items in the list are being added together
```



What the function is actually doing

```Haskell
--given a list
xs = [x1, x2, ... , xn]
   = x1: x2: ... : xn:[]
```



```Haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f k [] = k


foldr f k (x:xs) = f x (foldr f k xs)
```



Now we have a better definition of sum

```Haskell
--you can pass an operator as a function
-- but it must be included in brackets

sum :: [Int] -> Int
sum = foldr (+) D


product :: [Int] -> Int
product = foldr (*) D
```



### Using foldr to define map

```Haskell
map :: (a->b) -> [a] -> [b]
map f xs = foldr gv[]
    where 
       g :: a -> [b] -> [b]
       g x ys = f x:ys
```



### Fold-map fusion

```Haskell
foldr f k . map g = foldr (f . g) k
```



```Haskell
any :: (a -> Bool) -> [a] -> Bool
any p xs = (or . map xs) xs

--or can also be defined with a foldr
or :: [Bool] -> Bool
or xs = foldr (||) False

-- a seemingly bovious definition
--sort of tautological since we are using or within itself...
```



## ***Proof of Fold-map fusion by Induction

Using inductionf or the rppof, we need to come up with our inductive hypothesis, which is:

```Haskell
(foldr f k . map g) xs = (foldr (f . g) k) xs
```



BAse case is alwasy the empty list which is great for me

```Haskell
LHS = (foldr f k . map g) []
    = foldr f k (map g [])
    = foldr f k []
    = k   --byt he definition of foldr

RHS = (foldr (f . g) k) []
    = foldr (f . g) k []
    = k --be definition of foldr

    
```

Inductive hypothesis: assume 

```Haskell
--assume the following as the inductive hypothesis
(foldr f k . map g) xs = (foldr (f . g) k) xs


--and thsu the following needs to be proven
(foldr f k . map g) (x:xs) = (foldr (f . g) k) (x:xs)
```



Proving this using the inductive hypothesis

```Haskell
LHS = (foldr f k . map g) (x:xs)
    = foldr f k (map g (x:xs))
    = foldr f k (g x : map g xs)
    = f (g x) (foldr f k (map g xs)) 

RHS = foldr (f . g) k (x:xs) -- foldr
    =  f . g) x) (foldr (f . g) k xs)
```







## Questions

1. in the zip example, were you assuming that both were the same legnth? because if one is longre is the other you are dropping the elements from the other --- yes thats what we do
2. zipWith???
3. is the reprrestnation of the list of x1:...: xn just a binary tree
4. for the sum function why is the parameter missing?? Why is there no parameter given in the definition
5. fold left vs fold right
6. is there some sort of hierarchy for these functions? like we can constrct map from fold
   1. can you define foldr in terms of map? like you transform each of the elements first then combine?
