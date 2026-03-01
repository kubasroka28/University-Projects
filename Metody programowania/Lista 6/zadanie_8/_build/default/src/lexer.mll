{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let char = ['a'-'z' 'A'-'Z' '_']
let ident = char(char|digit)*

rule read =
    parse
    | white { read lexbuf }
    | "top" { TOP }
    | "bottom" { BOT }
    | "or" { DISJ }
    | "and" { CONJ }
    | "not" { NOT }
    | "forall" { FORALL }
    | "exists" { EXISTS }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | ident { IDENT (Lexing.lexeme lexbuf)}
    | eof { EOF }