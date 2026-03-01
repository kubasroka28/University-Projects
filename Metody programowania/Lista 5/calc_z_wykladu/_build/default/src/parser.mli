
(* The type of tokens. *)

type token = 
  | TIMES
  | RPAREN
  | PLUS
  | OR
  | MINUS
  | LPAREN
  | LEQ
  | INT of (int)
  | EQ
  | EOF
  | DIV
  | BOOL of (bool)
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
