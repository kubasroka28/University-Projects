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
  | Assign of ident * expr (* x := 3 + y *)
  | If of expr * stmt * stmt (* if (e) s1 else s2 *)
  | While of expr * stmt (* while (e) s *)
  | Print of expr
  | Block of stmt list

type prog = stmt list
