{
open Zadanie_6_parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let number = '-'? digit+ ('.'digit*)?

rule read =
    parse
    | white { read lexbuf }
    | "*" { TIMES }
    | "+" { PLUS }
    | "-" { MINUS }
    | "/" { DIV }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | "**" { POWER }
    | "log" { LOG }
    | "e" { FLOAT ( Float.exp 1.0 ) }
    | number { FLOAT ( float_of_string (Lexing.lexeme lexbuf)) }
    | eof { EOF }
