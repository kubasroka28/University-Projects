open Ast

let parse (s : string) : expr =
  Parser.main Lexer.read (Lexing.from_string s)

module M = Map.Make(String)

type env = value M.t

and value =
  | VInt of int
  | VBool of bool

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

let rec eval_env (env : env) (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Bool b -> VBool b
  | Binop (op, e1, e2) ->
      eval_op op (eval_env env e1) (eval_env env e2)
  | If (b, t, e) ->
    (match eval_env env b with
      | VBool true -> eval_env env t
      | VBool false -> eval_env env e
      | _ -> failwith "type error")
  | Let (x, e1, e2) ->
  eval_env (M.add x (eval_env env e1) env) e2
  | Var x ->
    (match M.find_opt x env with
      | Some v -> v
      | None -> failwith "unknown var")
    
let eval = eval_env M.empty

let interp (s : string) : value =
  eval (parse s)

(* Zadanie 1 *)

type expr_env = expr M.t

let rec cp_env (env : expr_env) (e : expr) : expr =
  match e with
  | Int i -> Int i
  | Bool b -> Bool b
  | Binop (op, e1, e2) ->
    (match cp_env env e1, cp_env env e2 with
    | Int a, Int b -> 
      (match op with
      | Add -> Int (a + b)
      | Sub -> Int (a - b)
      | Mult -> Int (a * b)
      | Div -> Int (a / b)
      | Leq -> Bool (a <= b)
      | Eq -> Bool (a = b)
      | _ -> Binop (op, Int a, Int b)
      )
    | Bool a, Bool b ->
      (match op with
      | And -> Bool (a && b)
      | Or  -> Bool (a || b)
      | Eq -> Bool (a = b)
      | _ -> Binop (op, Bool a, Bool b)
      )
    | e1, e2 -> Binop (op, e1, e2))
  | If (b, t, e) ->
    (match cp_env env b with
    | Bool b -> if b then cp_env env t else cp_env env e
    | _ -> If (b, cp_env env t, cp_env env e)
    )
  | Var x ->
    (match M.find_opt x env with
      | Some v -> v
      | None -> Var x)
  | Let (x, e1, e2) ->
    (match cp_env env e1 with
    | Int i -> cp_env (M.add x (Int i) env) e2
    | Bool b -> cp_env (M.add x (Bool b) env) e2
    | e1' -> Let (x, e1', cp_env (M.add x (Var x) env) e2)
    )
 
let cp = cp_env M.empty

(* Zadanie 2 *)

type string_env = string M.t

let rec alpha_equiv_env (env1 : string_env) (env2 : string_env) ( e1 : expr ) (e2 : expr) : bool =
  match e1, e2 with
  | Int i1, Int i2 -> i1 = i2
  | Bool b1, Bool b2 -> b1 = b2
  | Binop (op1, e1l, e1r), Binop (op2, e2l, e2r) ->
    (op1 = op2) && (alpha_equiv_env env1 env2 e1l e2l) && (alpha_equiv_env env1 env2 e1r e2r)
  | If (b1, t1, e1), If (b2, t2, e2) ->
    (alpha_equiv_env env1 env2 b1 b2) && (alpha_equiv_env env1 env2 t1 t2) && (alpha_equiv_env env1 env2 e1 e2)
  | Let (x1, e1l, e1r), Let (x2, e2l, e2r) ->
    (alpha_equiv_env env1 env2 e1l e2l) && (alpha_equiv_env (M.add x1 x2 env1) (M.add x2 x1 env2) e1r e2r)
  | Var x1, Var x2 ->
    (match (M.find_opt x1 env1), (M.find_opt x2 env2) with
    | Some v1, Some v2 -> v1 = x2 && v2 = x1
    | None, None -> x1 = x2
    | _ -> false
    )
  | _ -> false

let alpha_equiv = alpha_equiv_env M.empty M.empty

(* Zadanie 3 *)

let rec rename_expr_env (env : string_env) (path : string) (e : expr) : expr (*dodac do ast expr w ktorym moze byc #*) (*nie trzeba tego robic xd*) =
  match e with
  | Int i -> Int i
  | Bool b -> Bool b
  | Binop (op, e1, e2) ->
    Binop (op, rename_expr_env env (path ^ "B1") e1, rename_expr_env env (path ^ "B2") e2)
  | If (b, t, e) ->
    If (rename_expr_env env (path ^ "Ib") b, rename_expr_env env (path ^ "It") t, rename_expr_env env (path ^ "Ie") e)
  | Let (x, e1, e2) ->
    Let (path, rename_expr_env env (path ^ "L1") e1, rename_expr_env (M.add x path env) (path ^ "L2") e2)
  | Var x ->
    (match M.find_opt x env with
    | Some v -> Var v
    | None -> Var x
    )

let  rename_expr = rename_expr_env M.empty "#"


