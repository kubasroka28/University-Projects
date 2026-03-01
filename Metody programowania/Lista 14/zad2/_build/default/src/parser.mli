
(* The type of tokens. *)

type token = 
  | WHILE
  | TIMES
  | SKIP
  | RPAREN
  | RBRACE
  | PRINT
  | PLUS
  | OR
  | NEQ
  | MINUS
  | LT
  | LPAREN
  | LOCAL
  | LEQ
  | LBRACE
  | INT of (int)
  | IF
  | IDENT of (string)
  | GT
  | GEQ
  | EQ
  | EOF
  | ELSE
  | DIV
  | COLON
  | BOOL of (bool)
  | ASSIGN
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.prog)
