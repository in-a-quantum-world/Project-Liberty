# **Lecture 1 - One Day Later (as to not forget!)**

Haskell is a functional language.


Types: Int (64 bit, -2^63 to 2^63 - 1) , Integer (not memory bounded), Float (32 bits, ~7 decimal places)Double (64 bits, ~16 decimal places), Word (64 bits, 0 ... 2^64)

haskell defaults to using doubles. 

Type annotation means we need to specify the type of all inputs, and the type of the output. 

haskell is very case sensitive so alld ata types need to begin with capital letter Int, Integer, Word, Double, Bool

Intentional vs Extensional functions. In CS we care about what a function is doing, not just the input --> output mapping, which is why functions which are fundamentally different despite having the exact same input --> output mapping for all inputs, need to be treated carefully. 


Defined booleans: True, False. other booleans: undefined. 


Declarations: we use identifier hiker to declare a new value. eg hiker :: Integer, hiker x = 42;

We use _ when we are lazy and referring to an argument that does not have a name, when looking at function definitions. 

```Haskell
eg Square:: Int -> IntSquare _ = _ * _
```



With multiple arguments we do the following:

```Haskell
Sum:: Int -> Int -> Int
Sum x y = x + y
```



Pattern matching is a speciality of Haskell. We can have a funcrion that returns a specific value for specific inputs

```Haskell
Sinc:: Double -> Double
Sinc 0 = 1
Sinc x = sin x / x
```


Short Circuiting is possible as well and this involves 

You can also instead of doing this, you can do pattern matching with conditionals and guards. Example:

```Haskell
Sinc :: Double -> Double
Sinc x | x < 0 = sin x / x     
       | x > 0  =  sin x / x     
       | otherwise 1
```



GHCI can be used to evaluate a function at runtime with ghci> func_name  arg. You don't need brakcets automaticaly when passing arguments, unless you are explicity doing soething such as numerically modifying an argument, then you do indeed need brackets.
