(* cd "/mnt/c/Users/Jakub Sroka/OneDrive/Documents/Studia/letni 2024-25/Metody programowania/Lista 6/zadanie_1" *)

open Ast

let parse (s : string) : expr =
  Parser.main Lexer.read (Lexing.from_string s)

type value =
  | VInt of int
  | VBool of bool
  | VUnit of unit (* Zadanie 3 *)
  | VPair of value * value (* Zadanie 4 *)

let eval_op (op : bop) (val1 : value) (val2 : value) : value =
  match op, val1, val2 with
  | Add,  VInt  v1, VInt  v2 -> VInt  (v1 + v2)
  | Sub,  VInt  v1, VInt  v2 -> VInt  (v1 - v2)
  | Mult, VInt  v1, VInt  v2 -> VInt  (v1 * v2)
  | Div,  VInt  v1, VInt  v2 -> VInt  (v1 / v2)
  | And,  VBool v1, VBool v2 -> VBool (v1 && v2)
  | Or,   VBool v1, VBool v2 -> VBool (v1 || v2)
  | Leq,  VInt  v1, VInt  v2 -> VBool (v1 <= v2)
  | Eq,   _,        _        -> VBool (val1 = val2)
  | _,    _,        _        -> failwith "type error"

let rec subst (x : ident) (s : expr) (e : expr) : expr =
  match e with
  | Binop (op, e1, e2) -> Binop (op, subst x s e1, subst x s e2)
  | If (b, t, e) -> If (subst x s b, subst x s t, subst x s e)
  | Var y -> if x = y then s else e
  | Let (y, e1, e2) ->
      Let (y, subst x s e1, if x = y then e2 else subst x s e2)
  | Pair (e1, e2) -> Pair (subst x s e1, subst x s e2) (* Zadanie 4 *)
  | Fst p -> Fst (subst x s p) (* Zadanie 4 *)
  | Snd p -> Snd (subst x s p) (* Zadanie 4 *)
  | _ -> e

let rec reify (v : value) : expr =
  match v with
  | VInt a -> Int a
  | VBool b -> Bool b
  | VUnit u -> Unit u (* Zadanie 3 *)
  | VPair (v1, v2) -> Pair (reify v1, reify v2) (* Zadanie 4 *)

let rec eval (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Bool b -> VBool b
  | Unit u -> VUnit u (* Zadanie 3 *)
  | Pair (e1, e2) -> VPair (eval e1, eval e2) (* Zadanie 4 *)
  | Fst p ->
      (match p with
          | Pair (e1, _) -> eval e1
          | _ -> failwith "type error") (* Zadanie 4 *)
  | Snd p ->
      (match p with
          | Pair (_, e2) -> eval e2
          | _ -> failwith "type error") (* Zadanie 4 *)        
  | Binop (op, e1, e2) ->
      eval_op op (eval e1) (eval e2)
  | If (b, t, e) ->
      (match eval b with
           | VBool true -> eval t
           | VBool false -> eval e
           | _ -> failwith "type error")
  | Let (x, e1, e2) ->
      eval (subst x (reify (eval e1)) e2)
  | Var x -> failwith ("unknown var " ^ x)
  
(* Zadanie 1 *)
(* v1 *)
let closed (e : expr) : bool =
  let rec closed (e : expr) (var_stack : ident list) =
    match e with
    | Binop (_, e1, e2) -> (closed e1 var_stack) && (closed e2 var_stack)
    | If (b, t, e) -> (closed b var_stack) && (closed t var_stack) && (closed e var_stack)
    | Let (x, e1, e2) -> (closed e1 var_stack) && (closed e2 (x :: var_stack))
    | Var x -> List.mem x var_stack
    | _ -> true
  in closed e []
(* v2 *)
(*let rec closed (e : expr) : bool =
    match e with
    | Binop (_, e1, e2) -> (closed e1) && (closed e2)
    | If (b, t, e) -> (closed b) && (closed t) && (closed e)
    | Let (x, e1, e2) -> (closed e1) && (closed (subst x e1 e2))
    | Var _ -> false
    | _ -> true*)
(**)

let interp (s : string) : value =
  eval (parse s)
