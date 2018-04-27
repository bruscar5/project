import Tokens
import System.Environment
import Grammar
import Sentence

main :: IO ()
main = do
  args <- getArgs
  s <- readFile $ head args
  let e = scanTokens s
  putStrLn $ show e
  let y = parseExpr e
  putStrLn $ show y
