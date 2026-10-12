
# **Lecture 4**

Monomorphic lists (not very useful)

```Haskell
data ListInt where 
     Empty :: ListInt --empty list
     Cons :: Int -> ListInt -> ListInt --list of length int 

--exampple
Cons 3 (Cons 5 Empty) :: ListInt
```

ideally we want lists to be poolymorphic to any type.

The followng code can be used to cosntuct a list of 'a's

```Haskell
data [a] where --this is a new type, this is what it meas to be a list of 'a's
     [] :: [a] --this is the empty list
     (:) :: a -> [a] -> [a]  --definition of Cons (like cosnectuve element)
```

## Anatomy of list

[3,4,5] :: [Int] is th same as

3 : (4 : (5 : [ ]]))     (liek saying 3 attached to 4 attached to 5 attached to empty list)

So we could write: 3 : 4 : 5 : [ ]  =  3 : 4 : [5]  =  3 : [4,5]   =  [3,4,5]

To generate functions you nee to be able to pattern match on lists.

### Head, Tail

```Haskell
--apaprently these are not valid ways of deconstructing a list 
--because.... whyb do they return integers??
-- recommedned to use isempty() function instead 

head :: [a] -> Bool
head (x:xs) = x  --the front item in the list


tail :: [a] -> [a]
tail (x:xs) = xs  --the rest of the list
```

These are dangerous because head[ ] and tail[ ] applied to the emtpy list causes an error

```Haskell
isEmpty :: [a] -> Bool
isEmpty [] = True
isEmpty _ = False

--you could use pattern matching with guards instead
```

```Haskell
isSingle :: [a] -> Bool

--oyu can use pattern matching directy 
--since
isSingle[x] = True
isSingle _ = False


--not a well defined function since no mapping for empty list, one element list 
second :: [a] -> a
--extract th second value of the list
--deep pattern match
second[x,y] = y
second[x:y:zs] = y
```

### Empty List

Every type actually has an empty list.

```Haskell
[] :: [Int]
[] :: [Bool]
[] :: [Float]

--and so on.
```

## Recursion over Lists

```Haskell
sum :: [Int] -> Int
sum [] = 0
sum (x:xs) = x + sum xs


--lengt of list
--polymorphic and works for any type!
length :: [a] -> Int
length [] = 0
length(x:xs) = 1 + length xs
```

## Append function

```Haskell
--this is defining an operator
--thus when pattern amthcing it appears in the middle and not at the front
--since it is an operator and the inputs need to be operated upon!

(++) :: [a] -> [a] -> [a]
[] ++ ys = ys
(x:xs) ++ ys = x:(xs ++ ys)


--alternative where you list out all cases
-- but you only need two pattersn actaully
--first pattern is covered in the last one
-- and middle two are equicalent??
[] ++ [] = []
(x:xs) ++ [] = x:xs
[] ++ (y:ys) = y:ys
(x:xs) ++ (y:ys) = x:(xs ++ (y:ys))
```

## Take, Drop

Take will take the first n elements of the list, drop will remove the first n elements of the list.

```Haskell
take 3 [0,1,2,3,4] = [0,1,2]
drop 3 [0,1,2,3,4] = [3,4]

take :: Int -> [a] -> [a]
take 0 xs = []
take n [] = []
take n (x:xs) = x : take (n-1) xs



drop :: Int -> [a] -> [a]
drop 0 xs = xs
drop n [] = []
drop n (x:xs) = drop (n-1) xs
```



## The BangBang function

Extracts an element from a lsit. Writen as !!

```Haskell
[3,1,4,1,5] !! 0 = 3
[3,1,4,1,5] !! 2 = 4
--this function is highly dangerous since you can bangbang a number which is larger than length of list

(!!) [a] -> Int -> a
[] !! _ = error "the list is empty "
(x:xs) !! 0 = x
(x:xs) !! n = xs !! (n-1)
```



## Questions

1. pythagorean list comprehesion appears slow but it is an enumeration of an infinite number of values. kind of like infinite for loops.
2. can a type inherit form another type: yes
3. can you createa  primr numer type using int type - very hard
4. the second[x:y:zs], does zsx alsways indictae many other items follow? like any type name ending in a s does this??? so what about just the type name 's'
5. <:+>
6. triples and tuples alow differnt types, not lists. lists are homogenous
7. why does list comrehension not really work on floats?
8. for defining the ++ operator, and doingnthe base case withthe empty set, is [ ] ++ ys = ys the same as ys ++ [ ] = ys
   1. so when we are defining the oeprator how do we define its commutativity???
9. when defining take can you do x ++ take n-1 xs isntead of x : take n-1 xs
