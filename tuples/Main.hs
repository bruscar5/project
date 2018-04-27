import Tokens
import System.Environment
import Tuples
import Grammar

main :: IO ()
main = do
  args <- getArgs
  s <- readFile $ head args
  let e = scanTokens s
  putStrLn $ show e
  let y = parseExpr e
  putStrLn $ show y
