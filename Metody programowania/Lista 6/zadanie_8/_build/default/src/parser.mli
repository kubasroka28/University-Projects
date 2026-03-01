
(* The type of tokens. *)

type token = 
  | TOP
  | RPAREN
  | NOT
  | LPAREN
  | IDENT of (string)
  | FORALL
  | EXISTS
  | EOF
  | DISJ
  | CONJ
  | BOT

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.qbf)
