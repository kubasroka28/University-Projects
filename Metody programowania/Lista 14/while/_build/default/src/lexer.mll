{
open Parser
}

let white = [' ' '\t' '\n']+
let digit = ['0'-'9']
let number = '-'? digit+
let char = ['a'-'z' 'A'-'Z' '_']
let ident = char(char|digit)*

rule read =
    parse
    | white { read lexbuf }
    | "*" { TIMES }
    | "+" { PLUS }
    | "-" { MINUS }
    | "/" { DIV }
    | "&&" { AND }
    | "||" { OR }
    | "=" { EQ }
    | ":=" { ASSIGN }
    | "<>" { NEQ }
    | "<=" { LEQ }
    | "<" { LT }
    | ">" { GT }
    | ">=" { GEQ }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "{" { LBRACE }
    | "}" { RBRACE }
    | "skip" { SKIP }
    | "if" { IF }
    | "else" { ELSE }
    | "true" { BOOL true }
    | "false" { BOOL false }
    | ";" { COLON }
    | "while" { WHILE }
    | "print" { PRINT }
    | number { INT ( int_of_string (Lexing.lexeme lexbuf)) }
    | ident { IDENT (Lexing.lexeme lexbuf) }
    | eof { EOF }
