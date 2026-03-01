type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Leq

type ident = string

type expr = 
  | Int   of int
  | Binop of bop * expr * expr
  | Bool  of bool
  | If    of expr * expr * expr
  | Let   of ident * expr * expr
  | Var   of ident
  (*| Integral of ident * expr * expr * expr*)(* Zadanie 2, zmienna, po której całkujemy * k * n * f(x) *)
  (*| For   of ident * expr * expr * expr*)(* Zadanie 2, i * n * m * środek pętli *)
  | Unit  of unit (* Zadanie 3 *)
  | Pair  of expr * expr (* Zadanie 4 *)
  | Fst   of expr (* Zadanie 4 *)
  | Snd   of expr (* Zadanie 4 *)

