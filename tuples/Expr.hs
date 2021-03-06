module Expr where

import qualified Data.Trie as D
import qualified Data.ByteString.Char8 as C

data Expr =
  Num Integer |
  Add Expr Expr |
  Mult Expr Expr |
  Var String |
  Let String Expr Expr |
  TrueE |
  FalseE |
  Ite Expr Expr Expr |
  And Expr Expr |
  Or Expr Expr |
  Not Expr |
  Tuple Expr Expr|
  Sym String

-- showExprOp stringForOp e1 e2
showExprOp :: String -> Expr -> Expr -> String
showExprOp opstring e1 e2 = "(" ++ showExpr e1 ++ opstring ++ showExpr e2 ++ ")"

showExpr :: Expr -> String
showExpr (Var x) = x
showExpr (Num x) = show x
showExpr TrueE = "tt"
showExpr FalseE = "ff"
showExpr (Not e) = "(~ " ++ showExpr e ++ ")"
showExpr (Ite e1 e2 e3) =
  "(if " ++ showExpr e1 ++ " then " ++ showExpr e2 ++ " else " ++ showExpr e3 ++ ")"
showExpr (Add e1 e2) = showExprOp " + " e1 e2
showExpr (Or e1 e2) = showExprOp " || " e1 e2
showExpr (And e1 e2) = showExprOp " && " e1 e2
showExpr (Mult e1 e2) = showExprOp " * " e1 e2
showExpr (Let x e1 e2) = "(let " ++ x ++ " = " ++ showExpr e1 ++ " in " ++ showExpr e2 ++ ")"
showExpr (Tuple e1 e2) = "(" ++ (showExpr e1) ++ "," ++ (showExpr e2) ++ ")"

instance Show Expr where
  show = showExpr

testExprBody :: Expr
testExprBody = Add (Var "x") (Var "x")

testExpr :: Expr
testExpr = Let "x" (Num 2) testExprBody

testExpr2 :: Expr
testExpr2 = Let "x" testExpr testExprBody

type Value = Either Integer Bool

type Environment = D.Trie Value


envLookup :: String -> Environment -> Maybe Value
envLookup str env = D.lookup (C.pack str) env

envUpdate :: String -> Value -> Environment -> Environment
envUpdate x v env = D.insert (C.pack x) v env 

envEmpty :: Environment
envEmpty = D.empty

test :: Environment
test = envUpdate "x" (Left 3) $
       envUpdate "a" (Left 4) $
       envUpdate "b" (Left 5) $
       envUpdate "c" (Left 6) $
       envEmpty

join' :: Monad f => f (f a) -> f a
join' d = d >>= id

integerOp :: (Integer -> Integer -> Integer) -> Value -> Value -> Maybe Value
integerOp f (Left x) (Left y) = Just (Left (f x y))
integerOp f _ _ = Nothing

boolOp :: (Bool -> Bool -> Bool) -> Value -> Value -> Maybe Value
boolOp f (Right x) (Right y) = Just (Right (f x y))
boolOp f _ _ = Nothing

boolOp1 :: Value -> Maybe Value
boolOp1 (Right x) = Just (Right (not x))
boolOp1 _ = Nothing

iteOp :: Value -> Value -> Value -> Maybe Value
iteOp (Right ifPart) thenPart elsePart = Just (if ifPart then thenPart else elsePart)
iteOp _ _ _ = Nothing

eval :: Environment -> Expr -> Maybe Value
eval env (Var x) = envLookup x env
eval env (Num x) = Just (Left x)
eval env TrueE = Just (Right True)
eval env FalseE = Just (Right False)
eval env (And e1 e2) = join' (pure (boolOp (&&)) <*> (eval env e1) <*> (eval env e2))
eval env (Or e1 e2) = join' (pure (boolOp (||)) <*> (eval env e1) <*> (eval env e2))
eval env (Not e1) = join' (pure boolOp1 <*> (eval env e1))
eval env (Add e1 e2) = join' (pure (integerOp (+)) <*> (eval env e1) <*> (eval env e2))
eval env (Mult e1 e2) = join' (pure (integerOp (*)) <*> (eval env e1) <*> (eval env e2))
eval env (Ite e1 e2 e3) = join' (pure iteOp <*> (eval env e1) <*> (eval env e2) <*> (eval env e3))
eval env (Let x e1 e2) =
  do
    v <- eval env e1
    eval (envUpdate x v env) e2

