#### **First Haskell Lecture!!**

Intentional vs Extensional

In Computer Science, extensional and intentional functions will reduce differently - although they give you the exact same answers for all (input, output) pairs, they do NOT use the same approach.

- Mathematics typically uses extensional functions, looking at mappings from input to output only
- Computer Science uses intentional functions, looking at the mapping itself.


Church's Lambda Calculus was designed to think about reductions systematically. To see how long they take to reduce.

- He showed that all numbers can be reduced to his calculus form.

### Data Types in Haskell

#### Numbers

Haskell can hold huge numbers because it stores the Integer types as memory-bounded many bits. So you can use really large numbers. Other types also exist and they may have better performance, but the trade-off with limited accuracy.

- Int (64 bits) : -2^63 .... 2^63
- Word (64 bits) : 0 .... 2^(64) - 1
- Integer : unbounded bits
- Float (32 bits, ~7 digits) : -3.4 x 10^38 ....3.4 x 10^36
- Double (64 bits, ~16 digits) : -1.8 x 10^308 ....... 1.8 x 10^308

We can distinguish between all of these types by trying to evaluate a particular number


Type annotation can be used to give a aprticular term a particular type

Consequence is that you cannot add two different types together eg Int and Integer. You would have to explicitly use casting. 

For non integers, Haskell defaults to doubles. 

```Haskell
t :: T --this tells haskell that term t has type T
```



#### Boolean Values

Booleans have two defined values. Technically, undefined is a bool too.

```Haskell
True :: Bool
False :: Bool
```



### First Haskell Code

In maths a function associates an output value for each value in the input 

```
f: N -> N
f(x) = x + 1
```

```Haskell
--all fucntions in haskell must start with lowercase letter
succy :: integer -> integer;
succy x = x + 1; 

--haskell is very case sensitive
-- all type names have first letter capitalsied
```



### Declarations

Identifier hiker is used to declar a new value. It is immutable (no such thing as variables here!)

```Haskell
> hiker :: Integer
> hiker = 42

ghci> hiker + 2
44
```



We can also define functions

_ means there is no argument 

```Haskell
Two :: Int -> Int
Two _ = 2
```





GHCI (Glasgow Haskell Compiler Interact)

We can use ghci to evalaute the function at a value. The two ghci commands are equivalent. :q is used to quit. 

```Shell
ghci> succ(41)
ghci> succ 41
ghci> :q
```

![1790868047815](image/lec1/1790868047815.png)



These programming languages gain abstraction going down the list:

![1790868094669](image/lec1/1790868094669.png)



Recommended literature for Haskell
----------------------------------

- learnyouahaskell.com
- tryhaskell.org
- book.realworldhaskell.org.read
- tryhaskell.org
- Programming in Haskell (2nd Ed) by Graham Hutton
- Thinking Functionally with Haskell
