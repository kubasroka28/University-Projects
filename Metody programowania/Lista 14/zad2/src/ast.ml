type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Neq | Leq | Lt | Geq | Gt

type ident = string

type expr = 
  | Int   of int
  | Binop of bop * expr * expr
  | Bool  of bool
  | Var   of ident

type stmt =
  | Skip
  | Assign of ident * expr
  | If of expr * stmt * stmt
  | While of expr * stmt
  | Print of expr
  | Local of ident * expr (*Zadanie 2*)
  | Block of stmt list

type prog = stmt list
