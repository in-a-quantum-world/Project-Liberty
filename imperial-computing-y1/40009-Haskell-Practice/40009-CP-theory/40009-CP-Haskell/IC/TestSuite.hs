{-# LANGUAGE ExistentialQuantification #-}
module IC.TestSuite
  ( TestCase
  , (==>)
  , testCase
  , runTests
  ) where

import Control.Exception (SomeException, evaluate, try)
import Control.Monad (forM, unless)

-- A single test: a name, the result of applying the function under test
-- (held lazily so that errors are caught), and the expected value.
data TestCase = forall a. (Eq a, Show a) => TestCase String a a

-- Build a test from an actual value and an expected value.
--   f x ==> y     means "f x should equal y"
infix 1 ==>
(==>) :: (Eq a, Show a) => a -> a -> (String -> TestCase)
(==>) actual expected name = TestCase name actual expected

-- Attach a name to a comparison.
testCase :: String -> (String -> TestCase) -> TestCase
testCase name mk = mk name

-- Runs a group of named test cases, printing each failure and a summary.
runTests :: [(String, [TestCase])] -> IO ()
runTests groups = do
  results <- forM groups $ \(groupName, cases) -> do
    putStrLn ("--- " ++ groupName)
    outcomes <- mapM runOne cases
    let failed = length (filter not outcomes)
    if failed == 0
      then putStrLn ("    all " ++ show (length cases) ++ " passed")
      else putStrLn ("    " ++ show failed ++ " of " ++ show (length cases) ++ " FAILED")
    return (length cases, failed)
  let total   = sum (map fst results)
      failed  = sum (map snd results)
  putStrLn ""
  putStrLn (show (total - failed) ++ "/" ++ show total ++ " tests passed")
  unless (failed == 0) $ putStrLn "Some tests failed; see above."

runOne :: TestCase -> IO Bool
runOne (TestCase name actual expected) = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  case r of
    Right True  -> return True
    Right False -> do
      putStrLn ("    FAIL " ++ name)
      putStrLn ("         expected: " ++ show expected)
      putStrLn ("         got:      " ++ show actual)
      return False
    Left e -> do
      putStrLn ("    FAIL " ++ name)
      putStrLn ("         expected: " ++ show expected)
      putStrLn ("         raised:   " ++ takeWhile (/= '\n') (show e))
      return False