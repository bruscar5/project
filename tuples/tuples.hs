module Tuples where

import qualified Data.Trie as D
import qualified Data.ByteString.Char8 as C

data Tuple =
  Oneple Tuple |
  Pair Tuple Tuple |
  Triple Tuple Tuple Tuple|
  Quadple Tuple Tuple Tuple Tuple|
  Sym String


instance Show Tuple where
  show =showTuple

showTuple :: Tuple -> String
showTuple (Sym a) = a
showTuple (Oneple a) = "(" ++ (showTuple a) ++ ")"
showTuple (Pair a b) = "(" ++ (showTuple a) ++ "," ++ (showTuple b) ++ ")"
showTuple (Triple a b c) = "(" ++ (showTuple a) ++ "," ++ (showTuple b) ++ "," ++ (showTuple c) ++ ")"
showTuple (Quadple a b c d) = "(" ++ (showTuple a) ++ "," ++ (showTuple b) ++ "," ++ (showTuple c) ++  "," ++ (showTuple d) ++ ")"
