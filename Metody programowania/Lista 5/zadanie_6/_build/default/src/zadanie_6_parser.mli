
(* The type of tokens. *)

type token = 
  | TIMES
  | RPAREN
  | POWER
  | PLUS
  | MINUS
  | LPAREN
  | LOG
  | FLOAT of (float)
  | EOF
  | DIV

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Zadanie_6_ast.expr)
