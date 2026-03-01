
(* The type of tokens. *)

type token = 
  | UNIT
  | TIMES
  | THEN
  | SND
  | RPAREN
  | PLUS
  | OR
  | NEQ
  | MINUS
  | LT
  | LPAREN
  | LET
  | LEQ
  | KW_UNIT
  | KW_INT
  | KW_BOOL
  | INT of (int)
  | IN
  | IF
  | IDENT of (string)
  | GT
  | GEQ
  | FUNREC
  | FUN
  | FST
  | EQ
  | EOF
  | ELSE
  | DIV
  | COMMA
  | COLON
  | BOOL of (bool)
  | ARR
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (RawAst.expr)
