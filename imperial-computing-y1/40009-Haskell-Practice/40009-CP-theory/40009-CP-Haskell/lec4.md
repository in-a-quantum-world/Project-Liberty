
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

head :: [a] -> Bool
head (x:xs) = x  --the front item in the list


tail :: [a] -> [a]
tail (x:xs) = xs  --the rest of the list
```



## Questions

1. pythagorean list comprehesion appears slow but it is an enumeration of an infinite number of values. kind of like infinite for loops.
2. can a type inherit form another type: yes
3. can you createa  primr numer type using int type - very hard



1. <:+>
6. triples and tuples alow differnt types, not lists. lists are homogenous
