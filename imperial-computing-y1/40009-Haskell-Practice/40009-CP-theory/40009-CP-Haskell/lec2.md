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



### Evaluation

Evaluation is the process of generating/reducing to a value of from an expression. ***Infininty does not give you such a value.** *

Any expression will boil down to a value or a function applied to a value

- **Normal evaluation**:
  - First the function is evalauted, then x is evalauted, if need be.
  - Looks up definition of the function before it proceeds.
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
