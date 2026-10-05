--sequences - assignment 1
module Sequences where
-- ASSIGNMENT 1: Arithmetic Sequence Generator
-- Description: 
-- Write a function that generates an arithmetic sequence as a list of integers.
-- The function takes a starting value, a step size, and the length of the list.
-- If the length is 0 or negative, return an empty list.
--
-- Hint: You can use recursion or Haskell's list comprehension/range syntax.

arithSeq:: Int -> Int -> Int



-- ASSIGNMENT 2: Sequence Element Counter
-- Description:
-- Write a function that counts how many times a specific target element 
-- appears consecutively at the very beginning of a sequence.
--
-- Hint: Look into pattern matching on lists or the built-in `takeWhile` function.


- ASSIGNMENT 3: Look-and-Say Sequence Step

-- Description:
-- The "Look-and-Say" sequence describes the digits of the previous number.
-- For example, "11" is described as "two 1s", which becomes.
-- Write a function that takes a sequence of integers and returns the *next* 
-- step in the look-and-say sequence.
--
-- Examples:
-- [1]       -> [1, 1]     (One 1)
-- [1, 1]    -> [2, 1]     (Two 1s)
-- [2, 1]    -> [1, 2, 1, 1] (One 2, then one 1)
--
-- Hint: The standard library function `group` from `Data.List` is highly 
-- recommended for this. You will need to add `import Data.List (group)` 
-- at the top of your file if you use it.