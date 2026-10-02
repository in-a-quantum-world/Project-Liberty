This lecture is about functions and evaluation

> module Functions where

> square :: Int -> Int
> square n = n * n  -- <- is the body

         ^ that is an argument

While we have seen examples of a function in the previous lecture
it's good to understand how evaluation works in Haskell. The
most important rule is that we *substitute* the arguments of the
function into the places where that appears in the body *without
evaluating it*:

< square 3 = 3 * 3
<          = 9
<
< square (1 + 2) = (1 + 2) * (1 + 2)
<                = 3 * (1 + 2)
<                = 3 * 3
<                = 9

Direct subtitution of this form is known as pass-by-name.
As you can see from the above substitution and evaluation,
`1 + 2` was evaluated twice. In practice, this is to be
avoided, so Haskell will "connect" the occurrences of the
same argument together and only evaluate once:

< square (1 + 2) = (1 + 2) * (1 + 2)
                      ^---------^
<                = 3 * 3
                   ^---^
<                = 9

In the above, when we evaluate `1+2` for the first time, it is
reduces immediately in both places it originally occurred in.
This is called pass-by-need, also known as lazy evaluation.

This differs from how you might be used to thinking about function
application. A langauge which is pass-by-value, or "eager/strict"
will always evaluate arguments fully before doing the substution.
In such a language, the same function call would evaluate as follows:

< square (1 + 2) = square 3
<                = 3 * 3
<                = 9

Something important about eagerness vs laziness is the follows:

    Lazy functions always will return an answer if it is possible
    to produce one. Eager functions may not produce an answer even
    if it were possible.

    When a function always evaluates everything passed to it and
    inside its body, the outcomes between lazy/eager are the same.
    In this case, the eager function will be more efficient.

When does this make a difference? Consider the following function

> two :: Integer -> Integer
> two _ = 2

This function will take an integer, ignore it entirely, and then
return `2` unconditionally. In Haskell, we conventionally use `_`
to denote arguments we don't care about when defining functions.
When evaluating lazy functions, we always look at the *outer-most*
thing, and try and evaluate that first; when evaluating eagerly,
we evaluate the *inner-most* thing. As a result an eager and
lazy evaluation of `two (1 + 2)` will have different amounts of
work done:

(Using laziness)
< two (1 + 2) = 2

(If Haskell were strict)
< two (1 + 2) = two 3
<             = 2

Notice that the lazy evaluation didn't need to touch `1+2` at all!
This is the reason why strict evaluation can sometimes return no answers.
Here is a value to represent `infinity`:

> infinity :: Integer
> infinity = infinity + 1

This classic mathematical definition is legal in Haskell,
but we shouldn't try and evaluate it. Suppose we did:

< infinity = infinity + 1
<          = (infinity + 1) + 1
<          = ((infinity + 1) + 1) + 1
<          = ...

This is not going to ever terminate. So, what happens when we
give `infinity` to the `two` function (try it in GHCi!):

< two infinity = 2

Nothing bad happens, because `two` doesn't use its argument at all
and `infinity` was not evaluated. Now suppose Haskell were eager:

< two infinity = two (infinity + 1)
<              = two ((infinity + 1) + 1)
<              = ...

This function will never return us an answer, even though
it is clear that the answer would have been `2` *eventually*.
From now on, we can assume any functions we are using (except
for arithmetic ones like `(+)`, `(*)`, and so on), are lazily
evaluated, as long as they don't pattern match (see below).
We'll learn how to force Haskell to be strict in a
future week. We will also eventually see a useful version of
`infinity` in Advanced Programming that we *can* work with in
a productive way!

To keep it clear how we should be thinking about evaluating
more complex expressions, here is another expression to
evaluate:

    v we are always going to evaluate outermost thing first
< square (square 2) = square 2 * square 2
                               ^ this is now the outer-most thing, it must evaluate its arguments now
<                   = (2 * 2) * square 2
                         ^ we now need to progress onto the left, and this is outermost thing, 2 is already fully evaluated
<                   = 4 * 4
                          ^ this is now magically evaluated as it was tied to the other side
<                   = 16
                      ^ now that both sides of (*) are evaluated, we can compute the answer

The key lesson is to always look at the outer-most thing, and
process inwards only when you get "stuck". You'll only ever
get stuck when you have something like pattern matching, or
strict operations like arithmetic on numbers.

To round this discussion off, let's also look at how
pattern matching (or inspecting a value to work out
what case you should be in) interacts with laziness.

> fact :: Integer -> Integer
> fact 1 = 1
> fact n = n * fact (n - 1)

The factorial function above (which does not handle negative numbers)
has a special case for when `n` is 1. As such, in order to evaluate
`fact n` we need to have evaluated `n` fully:

< fact (2 + 1) = fact 3
                      ^ now we know the argument is 3, we can now ask "is it 1?"
<              = 3 * fact (3 - 1)
                 ^ the three remains evaluated, as we already looked at it once
<              = 3 * fact 2
                          ^ again, we can't call fact until we evaluate (3 - 1), so that we can ask "is it 1?"
<              = 3 * (2 * fact (2 - 1))
<              = 3 * (2 * fact 1)
                               ^ as this is 1, we will take the `fact 1 = 1` line for substitution
<              = 3 * (2 * 1)
<              = 3 * 2
<              = 6

This function, because of pattern matching, *is* therefore
an eager function.

`undefined` is another example of a value we should never try
and evaluate. For your own understanding, load this
module in and evaluate the following expressions in GHCi,
what do you expect to happen for each one:

< fact undefined
< two undefined
< two (fact undefined)

Finally, at the end of this lecture, I introduced `if`-expressions:

< if cond then x1 else x2

Both `x1` and `x2` must have the same type: one of them will
be the result of evaluating this expression. The condition will
be fully evaluated to one of `True` or `False` (more on that tomorrow);
if it is `True`, the `if` evaluates to `x1`, otherwise it
evaluates to `x2`. In a few lectures time, we will see how we
could have defined if-expressions as our own function.

After the lecture I got a great question:
  "Why would we use guards over just the if-expressions?"

The answer is mostly purely for style: the guard notation using `|`
is more closer to the way functions are described mathematically,
and it has a cleaner looking syntax to the if-expressions. It
will be preferred by your PPTs.

A Note on Haskell Syntax
------------------------

At the end of this lecture, I finished off by making a comment
about Haskell syntax. Haskell is a *whitespace-sensitive* language
so spacing matters. Typically, things on a newline must be found
further to the right than the clause it forms a part of. The number
of spaces doesn't matter, but 2 is a good number for Haskell.
NEVER use a "hard tab", as it can invisibly make your life hell.

The following things are legal:

> -- good!
> signum :: Integer -> Integer
> signum n
>   | n > 0 = 1
>   | n == 0 = 0
>   | otherwise = -1

> -- yuck, but legal
> signum' :: Integer -> Integer
> signum' n
>   | n > 0 = 1
>      | n == 0 = 0
>  | otherwise = -1

> -- good, if you like aligning things, but not *necessary*
> signum'' :: Integer -> Integer
> signum'' n
>   | n > 0     = 1
>   | n == 0    = 0
>   | otherwise = -1

< -- illegal, the | (guard) needs to be indented more than "s"
< signum''' :: Integer -> Integer
< signum''' n
< | n > 0 = 1
< | n == 0 = 0
< | otherwise = -1

> -- legal, but notice it is more cluttered compared with the
> -- above definitions with guards.
> signum'''' :: Integer -> Integer
> signum'''' n =
>  if n > 0 then 1
>  else if n == 0 then 0
>  else -1

> -- legal
> cube :: Integer -> Integer
> cube n =
>   n * n * n

< -- illegal, the body needs to be more indented than the "c" in cube
< cube' :: Integer -> Integer
< cube' n =
< n * n * n
