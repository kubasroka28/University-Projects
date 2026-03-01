
(* The type of tokens. *)

type token = 
  | UNPACK
  | TIMES
  | THEOREM
  | SND
  | SBR_OPN
  | SBR_CLS
  | RIGHT
  | QED
  | PROOF
  | PLUS
  | PACK
  | OR
  | OF
  | NUM of (int)
  | NOT
  | NEQ
  | MINUS
  | LT
  | LET
  | LEQ
  | LEFT
  | IN
  | IDENT of (string)
  | GT
  | GEQ
  | FUN
  | FST
  | FROM
  | FORALL
  | FALSE
  | EXISTS
  | EQ
  | EOF
  | DIV
  | COMMA
  | COLON
  | CBR_OPN
  | CBR_CLS
  | CASE
  | BR_OPN
  | BR_CLS
  | BAR
  | AXIOM
  | ARR
  | AND
  | ABSURD

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Syntax.def list)
