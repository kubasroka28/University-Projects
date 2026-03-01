open RawAst

exception Type_error of
  (Lexing.position * Lexing.position) * string

module Env = struct
  module StrMap = Map.Make(String)
  type t = typ StrMap.t

  let initial = StrMap.empty

  let add_var env x tp =
    StrMap.add x tp env

  let lookup_var env x =
    StrMap.find_opt x env
end

(* Zadanie 5 *)
let counter = ref 0
let fresh c = 
  c := !c + 1; !c
(**)

let binop_name (bop : RawAst.bop) =
  match bop with
  | Add  -> "add"
  | Sub  -> "sub"
  | Mult -> "mult"
  | Div  -> "div"
  | And  -> "and"
  | Or   -> "or"
  | Eq   -> "eq"
  | Neq  -> "neq"
  | Leq  -> "leq"
  | Lt   -> "lt"
  | Geq  -> "geq"
  | Gt   -> "gt"

  
let rec infer_type_and_simplify env (e : expr) : Ast.expr * typ =
  match e.data with
  | Unit   -> (Unit, TUnit)
  | Int  n -> (Int n, TInt)
  | Bool b -> (Bool b, TBool)
  | Var  x ->
    (* Zadanie 5 *)
    begin match Env.lookup_var env x with
    | Some (int_name, tp) -> 
      (Var int_name, tp)
    | None    ->
      raise (Type_error(e.pos,
        Printf.sprintf "Unbound variable %s" x))
    end
  | Binop(bop, e1, e2) ->
    (match bop with
    | Add | Sub | Mult | Div ->
      let simpl_e1 = check_type_and_simplify env e1 TInt in
      let simpl_e2 = check_type_and_simplify env e2 TInt in
      (App(App(Builtin(binop_name bop), simpl_e1),
          simpl_e2), TInt)
    | And | Or ->
      let simpl_e1 = check_type_and_simplify env e1 TBool in
      let simpl_e2 = check_type_and_simplify env e2 TBool in
      (App(App(Builtin(binop_name bop), simpl_e1),
          simpl_e2), TBool)
    | Leq | Lt | Geq | Gt ->
      let simpl_e1 = check_type_and_simplify env e1 TInt in
      let simpl_e2 = check_type_and_simplify env e2 TInt in
      (App(App(Builtin(binop_name bop), simpl_e1),
          simpl_e2), TBool)
    | Eq | Neq ->
      let (simpl_e1, tp) = infer_type_and_simplify env e1 in
      let simpl_e2 = check_type_and_simplify env e2 tp in
      (App(App(Builtin(binop_name bop), simpl_e1),
          simpl_e2), TBool))
  | If(b, e1, e2) ->
    let simpl_b = check_type_and_simplify env b TBool in
    let (simpl_e1, tp) = infer_type_and_simplify env e1 in
    let simpl_e2 = check_type_and_simplify env e2 tp in
    (If(simpl_b, simpl_e1, simpl_e2), tp)
  (* Zadanie 5 *)
    | Let(x, e1, e2) ->
    let (simpl_e1, tp1) = infer_type_and_simplify env e1 in
    let int_name_for_x = fresh counter in
    let (simpl_e2, tp2) = infer_type_and_simplify (Env.add_var env x (int_name_for_x, tp1)) e2 in
    (Let(int_name_for_x, simpl_e1, simpl_e2), tp2)
  | Pair(e1, e2) ->
    let (simpl_e1, tp1) = infer_type_and_simplify env e1 in
    let (simpl_e2, tp2) = infer_type_and_simplify env e2 in
    (Pair(simpl_e1, simpl_e2), TPair(tp1, tp2))
  | App(e1, e2) ->
    let (simpl_e1, tp) = infer_type_and_simplify env e1 in
    begin match tp with
    | TArrow(tp2, tp1) ->
      let simpl_e2 = check_type_and_simplify env e2 tp2 in
      (App(simpl_e1, simpl_e2), tp1)
    | _ -> failwith "Type error"
    end
  | Fst e ->
    let (simpl_e, tp) = infer_type_and_simplify env e in
    begin match tp with
    | TPair(tp1, _) -> (App(Builtin "fst", simpl_e), tp1)
    | _ -> failwith "Type error"
    end
  | Snd e ->
    let (simpl_e, tp) = infer_type_and_simplify env e in
    begin match tp with
    | TPair(_, tp2) -> (App(Builtin "snd", simpl_e), tp2)
    | _ -> failwith "Type error"
    end
  (* Zadanie 5 *)
  | Fun(x, tp1, e) ->
    let int_name_for_x = fresh counter in
    let (simpl_e, tp2) = infer_type_and_simplify (Env.add_var env x (int_name_for_x, tp1)) e in
    (Fun(int_name_for_x, simpl_e), TArrow(tp1, tp2))
  (* Zadanie 5 *)
  | Funrec(f, x, tp1, tp2, e) ->
    let int_name_for_x = fresh counter in
    let int_name_for_f = fresh counter in
    let env = Env.add_var env x (int_name_for_x, tp1) in
    let env = Env.add_var env f (int_name_for_f, (TArrow(tp1, tp2))) in
    let simpl_e = check_type_and_simplify env e tp2 in
    (Funrec(int_name_for_f, int_name_for_x, simpl_e), TArrow(tp1, tp2))

and check_type_and_simplify env e tp : Ast.expr =
  let (simpl_e, tp') = infer_type_and_simplify env e in
  if tp = tp' then simpl_e
  else
    failwith "Type error"

let check_and_simplify_program e =
  let simpl = fst (infer_type_and_simplify Env.initial e) in
  simpl
