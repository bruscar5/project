{
module Grammar where
import Tokens
import Tuples
}

%name parseExpr
%tokentype { Token }
%error { parseError }

%token
    ',' {TokenSeparator}
    '(' {TokenLParen }
    ')' {TokenRParen}
    sym {TokenSym $$}

%%

Exp :
'(' Exp ')'             {Oneple $2}
| '('Exp ',' Exp')'    {Pair $2 $4}
| '(' Exp ',' Exp ',' Exp ')' {Triple $2 $4 $6}
| '(' Exp ',' Exp ',' Exp ',' Exp ')' {Quadple $2 $4 $6 $8}
| sym                     {Sym $1}
{

parseError :: [Token] -> a
parseError tks = error ("Parse error: " ++ show tks)

}
