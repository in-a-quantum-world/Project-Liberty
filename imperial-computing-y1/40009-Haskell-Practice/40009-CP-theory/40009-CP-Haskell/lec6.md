# **Lecture 6**

Last lecture ended with foldr and the fold-map fusion proof. This lecture finishes folds (foldl, strictness, scans) and then looks at the tools for building functions out of other functions: composition, application, currying, sections, point-free style.

## Foldr recap

```Haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
foldr f k [] = k
foldr f k (x:xs) = f x (foldr f k xs)

--picture: foldr replaces every (:) with f and the final [] with k
--  x1 : (x2 : (x3 : []))
--  x1 `f` (x2 `f` (x3 `f` k))
--the brackets nest to the RIGHT, hence fold RIGHT
```

So `foldr (+) 0 [1,2,3] = 1 + (2 + (3 + 0))`.

Many list functions are a foldr in disguise:

```Haskell
sum     = foldr (+) 0
product = foldr (*) 1
and     = foldr (&&) True
or      = foldr (||) False
concat  = foldr (++) []
length  = foldr (\_ n -> 1 + n) 0   --ignore the element, count 1 for it
map f   = foldr (\x ys -> f x : ys) []
filter p = foldr (\x ys -> if p x then x : ys else ys) []
```

## Foldl

Recall the tail recursive version of sum from lecture 4, using a helper with an accumulating parameter:

```Haskell
sum :: [Int] -> Int
sum xs = go 0 xs
  where
    go :: Int -> [Int] -> Int
    go acc [] = acc
    go acc (x:xs) = go (acc + x) xs
```

The pattern "walk down the list, updating an accumulator, return the accumulator at the end" can be generalised in the same way foldr generalised the plain recursion:

```Haskell
foldl :: (b -> a -> b) -> b -> [a] -> b
foldl f k [] = k
foldl f k (x:xs) = foldl f (f k x) xs

--notice f takes the ACCUMULATOR first, then the element
--compare foldr's f which takes the element first, then the rest
```

```Haskell
foldl (+) 0 [1,2,3]
= foldl (+) (0 + 1) [2,3]
= foldl (+) ((0 + 1) + 2) [3]
= foldl (+) (((0 + 1) + 2) + 3) []
= ((0 + 1) + 2) + 3
--brackets nest to the LEFT, hence fold LEFT
```

foldl is exactly tail recursion over a list. The `go` in sum above is `foldl (+)`.

reverse is the classic foldl:

```Haskell
reverse :: [a] -> [a]
reverse = foldl (\acc x -> x : acc) []

--or using flip, since (:) takes element then list, and we want acc then element
reverse = foldl (flip (:)) []

flip :: (a -> b -> c) -> b -> a -> c
flip f x y = f y x
```

### foldr vs foldl

For `(+)` they give the same answer because addition is associative. In general they do not:

```Haskell
foldr (-) 0 [1,2,3] = 1 - (2 - (3 - 0)) = 2
foldl (-) 0 [1,2,3] = ((0 - 1) - 2) - 3 = -6
```

Which one to use:

- foldr works on infinite lists if f is lazy in its second argument. `foldr (\x _ -> x) 0 [1..]` returns 1 immediately. foldl can never return on an infinite list because it has to reach the `[]` first.
- foldr is the natural choice when the result is a list built with `(:)`, because `(:)` nests to the right.
- foldl is the natural choice when you are computing a single number or reversing, but see the memory problem next.

## Laziness and the foldl space leak

Haskell is lazy (normal order evaluation, lecture 2). `foldl f k xs` does not actually compute `f k x` as it goes. It builds up an unevaluated expression (called a thunk) and only evaluates it at the very end.

```Haskell
sum [1,2,3]
= go 0 [1,2,3]
= go (0+1) [2,3]            --the (0+1) is NOT computed yet
= go ((0+1)+2) [3]
= go (((0+1)+2)+3) []
= (((0+1)+2)+3)             --only now does it start adding
```

For a million element list that is a million nested additions sitting in memory before a single one is done. This is a memory leak (space leak): the program uses far more memory than the single Int it needs. In ghci it shows up as a stack overflow on big lists.

### Adding strictness

We want the accumulator evaluated eagerly at each step. Two tools.

`seq` forces evaluation:

```Haskell
seq :: a -> b -> b
--seq x y returns y, but only after x has been evaluated

go acc [] = acc
go acc (x:xs) = let acc' = acc + x in acc' `seq` go acc' xs
```

Bang patterns are the neater syntax for the same thing. A `!` in front of a pattern insists that argument is evaluated before the function body runs:

```Haskell
{-# LANGUAGE BangPatterns #-}   --needed at the top of the file

go :: Int -> [Int] -> Int
go !acc [] = acc
go !acc (x:xs) = go (acc + x) xs
--now (acc + x) is computed before the recursive call, so the
--accumulator is always a single Int, never a chain
```

The strict foldl is called `foldl'` and lives in Data.List:

```Haskell
import Data.List (foldl')

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' f k [] = k
foldl' f k (x:xs) = k' `seq` foldl' f k' xs
  where
    k' = f k x
```

Rule of thumb: if you reach for foldl, you almost always want foldl'. Plain foldl is rarely the right choice.

Strictness can also go on data types, which makes the fields evaluated when the constructor is built:

```Haskell
data Coords = Coords !Int !Int
```

## Scans

A scan is a fold that keeps all the intermediate results instead of just the last one.

```Haskell
scanl :: (b -> a -> b) -> b -> [a] -> [b]
scanl f k [] = [k]
scanl f k (x:xs) = k : scanl f (f k x) xs

scanl (+) 0 [1,2,3,4] = [0,1,3,6,10]     --running totals
foldl (+) 0 [1,2,3,4] = 10               --just the last one

scanr (+) 0 [1,2,3,4] = [10,9,7,4,0]
```

Useful for things like factorials as a lazy infinite list:

```Haskell
factorials = scanl (*) 1 [1..]     --[1,1,2,6,24,120,...]
```

## Function composition

Composition in maths: (g ∘ f)(x) = g(f(x)). Haskell has it as an operator:

```Haskell
(.) :: (b -> c) -> (a -> b) -> (a -> c)
(g . f) x = g (f x)

--or as a lambda
g . f = \x -> g (f x)
```

Read `g . f` as "g after f". The types have to line up: f produces a `b`, g consumes a `b`.

```Haskell
--the caesar cipher from lecture 5 again
encrypt :: String -> String
encrypt xs = map (chr . succ . ord) xs

--chr . succ . ord :: Char -> Char
--  ord  :: Char -> Int
--  succ :: Int -> Int
--  chr  :: Int -> Char
--read right to left: ord first, then succ, then chr
```

This is where map fusion from last lecture comes from: `map g . map f = map (g . f)`.

Two other things to know about `.`: it is associative, so `(h . g) . f = h . (g . f)` and you can drop the brackets, and `id` is its identity, `f . id = id . f = f`.

## Function application `$`

```Haskell
($) :: (a -> b) -> a -> b
f $ x = f x
```

Looks pointless, but it has the lowest precedence of any operator and groups to the right, so it replaces brackets:

```Haskell
head (map (+1) (filter even [1..10]))
head $ map (+1) $ filter even [1..10]     --same thing, fewer brackets
```

Everything to the right of a `$` gets evaluated first and handed to the function on the left. Lab 3 uses `fromJust $ lookup e lst`.

## Currying and partial application

Every Haskell function takes exactly one argument. A "two argument" function is really a function that takes one argument and returns a function that takes the next:

```Haskell
add :: Int -> Int -> Int
--is actually
add :: Int -> (Int -> Int)
--the arrow associates to the right

add 3 :: Int -> Int        --a function waiting for its second argument
map (add 3) [1,2,3] = [4,5,6]
```

Giving a function fewer arguments than it wants is partial application. This is why `sum = foldr (+) 0` type checks in lecture 5 with no `xs`: `foldr (+) 0` is already a function `[Int] -> Int`.

The tuple form and the curried form are interchangeable:

```Haskell
curry :: ((a, b) -> c) -> (a -> b -> c)
curry f x y = f (x, y)

uncurry :: (a -> b -> c) -> ((a, b) -> c)
uncurry f (x, y) = f x y

uncurry add (3, 4) = 7
```

This is what the `uncurry maxOf2` in the test files was doing.

### Sections

An operator with one of its two arguments filled in:

```Haskell
(+1)      = \x -> x + 1
(2*)      = \x -> 2 * x
(`div` 2) = \x -> x `div` 2
(subtract 1)   --note: (-1) is the number minus one, not a section!

map (*2) [1,2,3] = [2,4,6]
filter (>0) [-1,0,1,2] = [1,2]
```

## Point-free style

If `f x = g x` for every x then `f = g` (function extensionality). So any definition whose last argument just gets passed straight through can drop it:

```Haskell
doubles xs = map (*2) xs
doubles    = map (*2)             --point-free

sumSquares xs = sum (map (^2) xs)
sumSquares    = sum . map (^2)
```

"Point" means argument, so point-free means argument-free. It reads well for short pipelines and badly for long ones. `concatMap = (concat .) . map` is technically correct and nobody should write it.

## More list functions worth knowing

```Haskell
concatMap :: (a -> [b]) -> [a] -> [b]
concatMap f = concat . map f
concatMap (\x -> [x, x]) "abc" = "aabbcc"

all :: (a -> Bool) -> [a] -> Bool
all p = and . map p
all even [2,4,6] = True

any :: (a -> Bool) -> [a] -> Bool
any p = or . map p

takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile (<5) [1..] = [1,2,3,4]       --stops at the first failure

dropWhile :: (a -> Bool) -> [a] -> [a]
dropWhile (<5) [1..10] = [5,6,7,8,9,10]

iterate :: (a -> a) -> a -> [a]
iterate (*2) 1 = [1,2,4,8,16,...]      --infinite, use with take

zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
```

Lab 3's maclaurin uses `iterate`, `scanl` and `zipWith3` together: iterate `diff` to get the list of derivatives, scanl `(*)` for factorials, zipWith3 to combine them with powers of x.

## Questions

1. Why is foldr the "default" fold if foldl is more efficient? Because foldr is lazy and works on infinite lists and list-building, and foldl without strictness leaks. foldl' is the efficient one.
2. Is `f . g $ x` the same as `f (g x)`? Yes. `$` has lower precedence than `.`, so it parses as `(f . g) $ x`.
3. Can you compose a two-argument function? `(.)` only composes one-argument functions, so `g . f` where f takes two args does not do what you want. Either write the lambda or partially apply f first.
4. Why does `(-1)` not work as a section? Because `-1` is parsed as the literal negative one. Use `subtract 1` or `(\x -> x - 1)`.
5. Does the compiler add strictness itself? Sometimes, with optimisation on, but you should not rely on it. In ghci (no optimisation) plain `foldl (+) 0 [1..10000000]` will blow up.
6. If every function takes one argument, what does `add 3 4` actually do? `(add 3) 4`. Application is left-associative; the first call returns a function, the second call applies it.
