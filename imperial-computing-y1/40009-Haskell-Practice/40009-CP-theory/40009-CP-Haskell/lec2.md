# **Lecture 2 - Recursion**

```Haskell
fact :: Integer -> Integer
fact 0 = 1
fact n = n * fact(n-1) -- is the order in which i write this significant?
```

Haskell has no problem dealing with infinite numbers, but your computer simply cannot compute it. I.e. if you added one to the definition of infinity voer and over again. haskell itself as a language doesn't havea  problem with it, but you cannot reach an end value for this - it is infinitely running.

```Haskell
infinity :: Integer 
infinity = infinity + 1
```



## Evaluation

Evaluation is the process of generating/reducing to a value of from an expression. ***Infininty does not give you such a value.** *

Any expression will boil down to a value or a function applied to a value

- **Normal evaluation**:
  - First the function is evalauted, then x is evalauted, if need be.
  - Looks up definition of the function before it proceeds.
  - Haskell typically uses this
- **Applicative (strict) evaluation**: .
  - Argument x is evaluated first then f is applied to the result.
  - May be seemingly faster as it takes fewer steps (in this example)



```Haskell
square :: Integer -> Integer
square x = x * x

--APPLICATIVE EVALUATION
square(1+2) --evaluate 1+2
= square(3) --evaluate 3. this is already evaluated so go straight to function square

--by definition of square:
= 3 * 3 --fucntion of multiplication aplied to left and right hand side 
-- both are values so we can proceed to apply the function
= 9


--NORMAL EVALAUTION
square(1+2) --go to the definition of fucntion first 
= (1+2) * (1+2) --multiplication function needs to be evalauted first before arguments
-- but the only way we can proceed with multiplication (or any arithmetic oepration) is if both sides are evalauted
= 3 * (1+2) --now left hand side is evaluated, right hand side also needs to be evaluated so we can apply multilpciation function
= 3 * 3
= 9
```


```Haskell
two :: Integer -> Integer
two _ = 2

infinity :: Integer 
infinity = infinity + 1

--trying to evalaute this with infinity

--applicative!!
two(infinity) --evaluate argument first whihc is infinity
= two(infinity+1) --returns infinity, but it is recursive
= two(infinity(infinity+1)) --this will go on infinitely

--normal evaluation
two(infinty) --go to function definition first. wait... this is just 2 so just return 2
= 2
```


### Church Rossen Theorem:

1. For any expression that terminates, normal evaluation will work. (Proven with Lambda Calculus
2. If applicative and normal evaluation both termiante ==>they will agree on the value.



## Tail Recursion

**Collatz Conjecture** is a function that we don't know if it termiantes or not. good example of terminating or not terminating function. it seems to be that the function will always termiante and the large numbers will be reduced to smaller ones which terminate.

The conjecture is that the Collatz function alwaus termiantes with the value 1:

```Haskell
collatz :: Integer -> Integer
collatz 1 = 1
collatz n 
	    | n <= 0 = error "collatz is undefined for non positive"
        | even  n = collatz(n `div` 2)
        | otherwise = collatz(3*n + 1)
```

*This is **tail recurisve** because no computation is required after Collatz computes the recursive call.*

- Tail recursion actually means that once you have the function call, ou don't need to do any extra computation at that step, whcih saves time and space complexity a lot of the times.
- If any function call requires extra work, it is not a tail recursive function.

*Tail recursion is very efficient*, often we want to make a recursiec function tail recursive for the sake of efficiency. Infintiyy function is not tail recursive. 


```Haskell
--tail recursive loop
--ghc will detec thtat this is a sort of infinite loop and doesn't do anything 
undefined :: Int
undefined = undefined
```



## Some New Data Types

### Tuples

Some computations can output multiple values at tthe same time. 

```Haskell
roots :: Double -> Double -> Double-> (Double,Double)

roots a b c = ((-b+d)/e, (-b-d)/e)
where 
	d = sqrt(b*b - 4*a*c)
    e = 2*a


--alternatively oyu could have written
where
    (d,e) = (sqrt(b*b - 4*a*c),2*a)
```


### Fun Facts about Tuples

What is really cool is that pairs in a tuple do not necessarily need to have the same type. Tuples can also contain tuples. 

Triples exist too of form (type, type, type)

*Tuples have a limit of 64 items?? (like a tuple with 64 items). Tuples are unordered.* 

Haskell also allows tuples to have 0 or 1 elements. 

* ( ) is called a unit
* (type) is called a singleton

```Haskell
dist :: (Float,Float) -> (Float,Float) -> Float
dist (x0,y0) (x1,y1) = sqrt((x0-x1)^2 + (y0-y1)^2)
```



## Polymorphism

In the case we want a function to operate over different types. Known as polymorphism. Eg addition, multiplication, exponent.  

```Haskell
--important function ig 
identity :: Int -> Int
identity x = x

--for any type, you should be able to return the same type
identity :: forall a . a -> a --dot separates the for all part from function part
identity x = x


```





# Questions



1. Can we switch between applicative and normal evaluation??
2. Halting problem: we dont know if a program can hat or not. there are certain thigns where we dont know if they are infinite processes or not/
3. short circutiing ignores the rest of the cases for pattern matching??
4. when doy uo know whether to use tuples insead of eg floats? i think its something to do wtih sapce compelxity and saving memroy.
5. helper ufnction go
