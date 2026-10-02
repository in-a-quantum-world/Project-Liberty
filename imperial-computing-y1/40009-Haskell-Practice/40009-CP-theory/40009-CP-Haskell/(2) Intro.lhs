This is a *literate* Haskell file, where everything is a comment
unless it starts with > (lines starting with < are still comments!)

You can still use it with GHCi just fine! Just write `ghci Intro.lhs`
and it'll load it for you to play with.

On your own systems, you should install via https://www.haskell.org/ghcup/,
on the lab machines, GHCi, GHC, and cabal are already installed for you.
We'll be using the current recommended GHC version, 9.4.8.

Haskell files start with their module name:

> module Intro where

During the lecture, someone asked about negatives, and I tried
to get hold of `Natural` numbers, it lived here. Don't worry
about module imports for now, they'll come up during the Friday
lectures at some point!

> import Numeric.Natural

This is where we left off at the end of the lecture, having implemented
the classic fibonacci function. A function starts with its type signature,
which describes what data can go in and out of the function:

> --        v domain   v co-domain
> fib :: Integer -> Integer

Then it is followed by one or more definition lines for the function. The name of
the function is followed by its arguments, on the left of the `=`, and
the body as an expression on the right of the `=`. In this case, we
need to handle the two special "base cases" of the function, for `fib 0`
and `fib 1` using *pattern matching* (more on that in a later lecture):

> --      v body (expression)
> fib 0 = 1
> fib 1 = 1
> --  ^ arguments

It is important that the more specific cases are at the top of the function,
as they will be visited first. Finally, we need to define the final case:

< fib n = fib (n - 1) + fib (n - 2)

In this general case, we refer to all over numbers `n` that are neither
`0` or `1`. Here we can describe the result of the `n`th fibonacci numbers
as being the sum of the two previous ones.

As pointed out in the lecture, it was noticed that the function described above
does not correctly handle negative numbers. To fix this we can add *guards*,
which allow the same definition to be split across 1 or more conditions:

> fib n
>   | n < 0     = undefined
>   | otherwise = fib (n - 1) + fib (n - 2)

In the above definition, if the number `n` is negative, we will
say that the result is undefined (we'll see what the consequence of this
is below, or you can run this yourself). The `| otherwise` is catching
any other case not handled by the guards above it. There is nothing
special about `otherwise`, as we will see in the coming lectures.

< ghci> fib (-1)
< *** Exception: Prelude.undefined
< CallStack (from HasCallStack):
<  undefined, called at Intro.lhs:52:19 in main:Intro

Later in the course, we will learn how we can write safer functions that
don't crash when they encounter a problem, but instead continue gracefully.

A "better" way of handling negative numbers in this function is
to fully rule them out by using a more appropriate type. As we'll
see later this week, `Integer` is the type of all unbounded integers;
instead we could have used `Natural`, which is the type of all unbounded
natural numbers. In this way, we confirm that the function will not accept
negative numbers, and is guaranteed to not produce a negative number in
return:

> fib' :: Natural -> Natural
> fib' 0 = 1
> fib' 1 = 1
> fib' n = fib' (n - 1) + fib' (n - 2)

In practice, though, `Natural` does not see much use in this course (generally,
Haskell has been designed around signed numbers, for better or worse). To see
what happens this time:

< ghci> fib' (-4)
<
< <interactive>:3:8: warning: [-Woverflowed-literals]
<     Literal -4 is negative but Natural only supports positive numbers
< *** Exception: arithmetic underflow

Here the compiler has warned us that -4 is not a legal natural, and that it
will instead *underflow*, which would be infinite in this case. So indeed,
this program will still crash at runtime, but there were more compile-time
reassurances: the warning, at least, was compile time!

In the next two lectures this week, we'll roll back a bit and dive more
carefully into both how functions work, including how to evaluate them,
and look at the primitive types at our disposal in Haskell. This lecture
is more designed as a whistlestop introduction.
