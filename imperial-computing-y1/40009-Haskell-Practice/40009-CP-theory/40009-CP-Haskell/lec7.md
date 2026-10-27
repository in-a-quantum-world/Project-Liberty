# **Lecture 7**

So far all the types have been built in: Int, Char, Bool, lists, tuples. This lecture is about defining your own, and about type classes, which are how `==` and `+` manage to work on more than one type.

## User-defined data types

Lecture 4 defined lists this way, with a `data ... where` block listing each constructor and its type:

```Haskell
data [a] where
  []  :: [a]
  (:) :: a -> [a] -> [a]
```

Bool is the same idea:

```Haskell
data Bool where
  True  :: Bool
  False :: Bool

--shorter, more common syntax: list the constructors separated by |
data Bool = True | False
```

Anything starting with a capital letter can be a new type, and its constructors must also start with capitals.

### Enumerations

A type with a fixed set of values and no data inside:

```Haskell
data Cowboy = Good | Bad | Ugly

trust :: Cowboy -> Bool
trust Good = True
trust _    = False
```

Lab 3 starts with two of these:

```Haskell
data UnOp  = Neg | Sin | Cos | Log
data BinOp = Add | Mul | Div
```

### Constructors with fields

A constructor can carry data. Think of it as a function from the field types to the new type:

```Haskell
data Shape where
  Circle :: Double -> Shape
  Rect   :: Double -> Double -> Shape

--equivalently
data Shape = Circle Double | Rect Double Double

area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rect w h) = w * h
```

Pattern matching takes the constructor apart and names its fields, exactly like `(x:xs)` takes a list apart. The brackets around `(Circle r)` are needed because the pattern has more than one word.

### Recursive data types

A constructor can contain the type being defined. This is how lists work (`(:)` contains another list) and how trees and expressions work:

```Haskell
data Nat where
  Z :: Nat          --zero
  S :: Nat -> Nat   --successor

--S (S (S Z)) is three

toInt :: Nat -> Int
toInt Z = 0
toInt (S n) = 1 + toInt n
```

The function follows the shape of the type: one equation per constructor, recursion where the type recurses. This is the single most important pattern of the whole course.

### Syntax trees

Lab 3's expression type:

```Haskell
data Exp = Val Double
         | Id String
         | UnApp UnOp Exp
         | BinApp BinOp Exp Exp

-- 5 * x is          BinApp Mul (Val 5) (Id "x")
-- -cos x is         UnApp Neg (UnApp Cos (Id "x"))
-- (x * x) + y is    BinApp Add (BinApp Mul (Id "x") (Id "x")) (Id "y")
```

Drawn as a tree, each BinApp is a node with two children and each Val or Id is a leaf. Evaluating, printing and differentiating are all "one equation per constructor, recurse on the sub-expressions":

```Haskell
eval :: Exp -> Env -> Double
eval (Val v) _ = v
eval (Id s) env = lookUp s env
eval (UnApp Neg e) env = negate (eval e env)
eval (UnApp Sin e) env = sin (eval e env)
-- ... and so on for each UnOp, then
eval (BinApp Add e1 e2) env = eval e1 env + eval e2 env
-- ... and so on for each BinOp
```

### Type synonyms

`type` gives an existing type a new name. No new type is created, it is purely for readability:

```Haskell
type String = [Char]              --this is how String is actually defined
type Env = [(String, Double)]     --lab 3: variable name to value
type KeywordDefs = [(String, String)]   --lab 4
```

Compare `data`, which makes a brand new type that is not interchangeable with anything else.

### Deriving

Haskell can write some boring instances for you:

```Haskell
data UnOp = Neg | Sin | Cos | Log
  deriving (Eq, Ord, Show)
```

`Eq` lets you use `==` on it, `Ord` gives `<` and friends (in the order the constructors are listed), `Show` lets ghci print it. Without `deriving Show`, typing a value of your type into ghci gives a "No instance for Show" error.

## Association lists and lookup

A list of pairs used as a dictionary. The `Env` above is one. The Prelude function:

```Haskell
lookup :: Eq a => a -> [(a, b)] -> Maybe b
lookup _ [] = Nothing
lookup k ((k', v) : rest)
  | k == k'   = Just v
  | otherwise = lookup k rest

lookup "y" [("x", 1), ("y", 2)] = Just 2
lookup "z" [("x", 1), ("y", 2)] = Nothing
```

The `Eq a =>` is a type class constraint (see below): this works for any key type that can be compared with `==`. The `Maybe b` is because the key might not be there.

The labs always define their own non-Maybe version with a precondition:

```Haskell
lookUp :: Eq a => a -> [(a, b)] -> b
--Pre: the key is in the list
lookUp k table = fromJust (lookup k table)       --fromJust is in Data.Maybe

--or by hand, with an error for the missing case
lookUp k [] = error ("lookUp: no binding for key")
lookUp k ((k', v) : rest)
  | k == k'   = v
  | otherwise = lookUp k rest
```

Lab 4 wants a version that returns ALL matching values, which is a one line list comprehension:

```Haskell
lookUp :: String -> [(String, a)] -> [a]
lookUp k table = [v | (k', v) <- table, k == k']
--pattern matching on the pair inside the generator
```

## Maybe

Lecture 4 said `head []` and `tail []` crash. The fix is a type that can be "nothing":

```Haskell
data Maybe a where
  Nothing :: Maybe a
  Just    :: a -> Maybe a

--or
data Maybe a = Nothing | Just a
```

`Maybe a` is a parameterised type: `Maybe Int`, `Maybe String`, `Maybe Exp` are all different types, in the same way `[Int]` and `[String]` are.

```Haskell
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv m n = Just (m `div` n)
```

The caller is forced to deal with both cases, usually by pattern matching:

```Haskell
describe :: Maybe Int -> String
describe Nothing = "no value"
describe (Just n) = "the value is " ++ show n
```

Useful helpers in Data.Maybe:

```Haskell
fromJust :: Maybe a -> a          --crashes on Nothing, so only with a precondition
fromMaybe :: a -> Maybe a -> a    --fromMaybe 0 Nothing = 0, fromMaybe 0 (Just 5) = 5
isJust, isNothing :: Maybe a -> Bool
catMaybes :: [Maybe a] -> [a]     --drops the Nothings
```

### Either

Like Maybe but the failure case carries information too, typically an error message:

```Haskell
data Either a b = Left a | Right b

safeHead :: [a] -> Either String a
safeHead [] = Left "empty list"
safeHead (x:_) = Right x
```

Convention: Right is the right answer, Left is the error.

## Case expressions

Pattern matching in the middle of an expression rather than in the function definition. Most often used on the result of a function call:

```Haskell
getAge :: String -> Int
getAge name = case lookup name ages of
  Just age -> age
  Nothing  -> error ("no age for " ++ name)
  where
    ages = [("Tom", 18), ("Anish", 19)]
```

Each alternative is `pattern -> result`, and they must line up vertically. A function defined by several equations is just sugar for one case expression on its arguments.

## Type classes

### The problem

`==` works on Int, Char, Bool, lists of those, tuples of those. What is its type? It cannot be `a -> a -> Bool` for every `a`, because functions cannot be compared (if they could, you could solve the halting problem by comparing a program to one known to halt).

This is ad hoc polymorphism: one name, different implementations for different types. Compare parametric polymorphism from lecture 2, where `length :: [a] -> Int` does the same thing regardless of `a`.

### Classes and instances

A type class is a set of types that support certain operations. `Eq` is the class of types with equality:

```Haskell
class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
  x /= y = not (x == y)       --default definition, so you only need to write ==
```

Which gives `==` the type

```Haskell
(==) :: Eq a => a -> a -> Bool
--read: for any type a, PROVIDED a is in Eq, ...
```

Everything before `=>` is a constraint. A function that uses `==` on a polymorphic value inherits the constraint:

```Haskell
elem :: Eq a => a -> [a] -> Bool
elem _ [] = False
elem x (y:ys) = x == y || elem x ys

--try leaving the "Eq a =>" off and ghc will tell you to put it back
```

To put your own type in the class you write an instance:

```Haskell
instance Eq Nat where
  Z == Z = True
  S m == S n = m == n        --recursive, on the smaller Nats
  _ == _ = False
```

`deriving Eq` writes exactly this for you.

### The main classes

```Haskell
class Eq a => Ord a where        --Ord requires Eq first
  (<), (<=), (>), (>=) :: a -> a -> Bool
  compare :: a -> a -> Ordering  --Ordering is data Ordering = LT | EQ | GT
  max, min :: a -> a -> a

class Show a where
  show :: a -> String

class Num a where
  (+), (-), (*) :: a -> a -> a
  negate, abs, signum :: a -> a
  fromInteger :: Integer -> a
```

`Num` explains the overloaded literals from lecture 1: `3` has type `Num a => a` and becomes an Int or Double depending on context, via `fromInteger`.

### Constraints you will write

```Haskell
isort :: Ord a => [a] -> [a]
isort = foldr insert []
  where
    insert x [] = [x]
    insert x (y:ys)
      | x <= y    = x : y : ys
      | otherwise = y : insert x ys

showAll :: Show a => [a] -> String
showAll = concatMap show

lookUp :: Eq a => a -> [(a, b)] -> b      --only the key needs Eq, not the value
```

Multiple constraints go in a tuple: `(Eq a, Show a) => ...`.

### Your own class

Lab 3 defines one. A class does not have to have functions with arguments; here it is just three named constants that each instance provides:

```Haskell
class Vars a where
  x, y, z :: a

instance Vars Exp where
  x = Id "x"
  y = Id "y"
  z = Id "z"

instance Vars Double where
  x = 4.3
  y = 9.2
  z = -1.7
```

So `x` means the expression `Id "x"` or the number 4.3 depending on what type is needed. Lab 3 also makes `Exp` an instance of `Num` so that `x * x + y` builds a syntax tree. That is the extension part; the point is that `+` on your own type is just a function you define.

## Records (brief)

For constructors with several fields, naming them saves writing accessor functions:

```Haskell
data Person = Person { name :: String, age :: Int }

tom = Person { name = "Tom", age = 18 }
age tom = 18                           --age is generated for free
birthday p = p { age = age p + 1 }     --copy with one field changed
```

## Questions

1. What is the difference between `type`, `data` and `newtype`? `type` is a synonym, no new type. `data` is a new type with any number of constructors. `newtype` is a `data` with exactly one constructor and one field, which costs nothing at runtime; use it when you want a distinct type for safety (e.g. `newtype GBP = Pence Int` so pounds and plain Ints cannot be mixed).
2. Why does ghci say "No instance for (Show Exp)"? You forgot `deriving Show`. Every type you want to print at the prompt needs it.
3. Can a data type be parameterised by more than one type? Yes, `Either a b` has two. Lists and Maybe have one.
4. Is `Maybe` just a list of length 0 or 1? Nearly. `toList Nothing = []`, `toList (Just x) = [x]`. The difference is the type stops you putting two things in.
5. If I derive Ord, what order do I get? The order the constructors are written in, so `Neg < Sin < Cos < Log`. For constructors with fields, it compares the fields left to right.
6. Why `Eq a => Ord a` in the class definition? Because `compare` has to be able to return EQ, so anything orderable must be comparable for equality first. The constraint on the class means every Ord instance must also have an Eq instance.
7. Why is the Calculus `showExp` allowed to use a lookup table `[(Neg, "-"), (Sin, "sin"), ...]`? Because UnOp derives Eq, so it can be a key in an association list.
