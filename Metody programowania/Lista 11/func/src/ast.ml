type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Neq | Leq | Lt | Geq | Gt

type value_type = TInt | TBool | TUnit | TPair | TFun

type ident = string

type expr = 
  | Int    of int
  | Binop  of bop * expr * expr
  | Bool   of bool
  | If     of expr * expr * expr
  | Let    of ident * expr * expr
  | Var    of ident
  | Unit
  | Pair   of expr * expr
  | Fst    of expr
  | Snd    of expr
  | Is     of value_type * expr
  | Fun    of ident * expr
  | Funrec of ident * ident * expr
  | App    of expr * expr

let rec fv (env : ident list) (e : expr) : ident list =
  match e with
  | Var x when List.mem x env -> []
  | Var x -> [x]
  | Binop (_, e1, e2) -> fv env e1 @ fv env e2
  | If (b, t, e) -> fv env b @ fv env t @ fv env e
  | Let (x, e1, e2) -> fv env e1 @ fv (x :: env) e2
  | Pair (e1, e2) -> fv env e1 @ fv env e2
  | Fst e -> fv env e
  | Snd e -> fv env e
  | Is (_, e) -> fv env e
  | Fun (x, e) -> fv (x :: env) e
  | Funrec (f, x, e) -> fv (f :: x :: env) e
  | App (e1, e2) -> fv env e1 @ fv env e2
  | _ -> []

let free_vars (env : ident list) (e : expr) : ident list =
  fv env e |> List.sort_uniq (String.compare)
