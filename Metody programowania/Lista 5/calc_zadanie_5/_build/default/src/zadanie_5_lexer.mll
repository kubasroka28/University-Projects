{
open Zadanie_5_parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let number = '-'? digit+'.'digit* (* zmiana definicji liczby na taką, która ma dodatkowo kropkę i ewentualnie po niej liczby *)

rule read =
    parse
    | white { read lexbuf }
    | "*" { TIMES }
    | "+" { PLUS }
    | "-" { MINUS }
    | "/" { DIV }
    | "(" { LPAREN }
    | ")" { RPAREN }
    | number { FLOAT ( float_of_string (Lexing.lexeme lexbuf)) }
    | eof { EOF }
