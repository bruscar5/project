module Sentence where

import qualified Data.Trie as D
import qualified Data.ByteString.Char8 as C

data Sentence =
  Sentence Word Sentence |
  Conjuction Sentence Sentence |
  Word String


instance Show Sentence where
  show =showSentence

showSentence :: Sentence -> String
showSentence (Word a) = a
showSentence a b = (showSentence a) ++ " " ++ (showSentence b)
showSentence (Conjuction a b) = (showSentence a) ++ " , " ++ (showSentence b)

--showTuple (Sym a) = a
--showTuple (Oneple a) = "(" ++ (showTuple a) ++ ")"
--showTuple (Pair a b) = "(" ++ (showTuple a) ++ "," ++ (showTuple b) ++ ")"
--showTuple (Triple a b c) = "(" ++ (showTuple a) ++ "," ++ (showTuple b) ++ "," ++ (showTuple c) ++ ")"
--showTuple (Quadple a b c d) = "(" ++ (showTuple a) ++ "," ++ (showTuple b) ++ "," ++ (showTuple c) ++  "," ++ (showTuple d) ++ ")"
