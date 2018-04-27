{
module Grammar where
import Tokens
}

%name parseExpr
%tokentype { Token }
%error { parseError }

%token
    ',' {TokenSeparator}
    '(' {TokenLParen }
    ')' {TokenRParen}
    sym {TokenWord $$}

%%

Exp :
Sentence '.'            {Sentence $1}
--| '('Exp ',' Exp')'    {Pair $2 $4}
--| '(' Exp ',' Exp ',' Exp ')' {Triple $2 $4 $6}
--| '(' Exp ',' Exp ',' Exp ',' Exp ')' {Quadple $2 $4 $6 $8}
--| sym                     {Sym $1}
{

parseError :: [Token] -> a
parseError tks = error ("Parse error: " ++ show tks)

}
