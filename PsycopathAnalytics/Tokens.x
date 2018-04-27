{
module Tokens where
}

%wrapper "basic"

$digit = 0-9
$alpha = [a-zA-Z]
$lower = [a-z]

tokens :-
  "("                            { \s -> TokenLParen }
  ")"                            { \s -> TokenRParen }
  $white+                       ;
  "--".*                        ;
  ","                             {\s -> TokenSeparator}
  "let"                         { \s -> TokenLet }
  "in"                            { \s -> TokenIn }
  "="                            { \s -> TokenEq }
  "+"                          { \s -> TokenPlus }
  $lower[$alpha $digit \_\']*  { \s -> TokenWord s}
  $digit+                       { \s -> TokenNum (read s :: Integer) }  

{

-- The token type:
data Token = TokenLet
           | TokenIn
           | TokenWord String
           |TokenSeparator
           | TokenNum Integer           
           | TokenEq
           | TokenPlus
           | TokenTimes
           | TokenLParen
           | TokenRParen
           deriving (Eq,Show)

scanTokens = alexScanTokens

}
