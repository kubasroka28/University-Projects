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

let rec infer_type env (e : expr) : typ =
  match e.data with
  | Unit   -> TUnit
  | Int  _ -> TInt
  | Bool _ -> TBool
  | Var  x ->
    begin match Env.lookup_var env x with
    | Some tp -> tp
    | None    ->
      raise (Type_error(e.pos,
        Printf.sprintf "Unbound variable %s" x))
    end
  | Binop((Add | Sub | Mult | Div), e1, e2) ->
    check_type env e1 TInt;
    check_type env e2 TInt;
    TInt
  | Binop((And | Or), e1, e2) ->
    check_type env e1 TBool;
    check_type env e2 TBool;
    TBool
  | Binop((Leq | Lt | Geq | Gt), e1, e2) ->
    check_type env e1 TInt;
    check_type env e2 TInt;
    TBool
  | Binop((Eq | Neq), e1, e2) ->
    let tp = infer_type env e1 in
    check_type env e2 tp;
    TBool
  | If(b, e1, e2) ->
    check_type env b TBool;
    let tp = infer_type env e1 in
    check_type env e2 tp;
    tp
  | Let(x, e1, e2) ->
    let tp1 = infer_type env e1 in
    let tp2 = infer_type (Env.add_var env x tp1) e2 in
    tp2
  | Pair(e1, e2) ->
    TPair(infer_type env e1, infer_type env e2)
  | App(e1, e2) ->
    begin match infer_type env e1 with
    | TArrow(tp2, tp1) ->
      check_type env e2 tp2;
      tp1
    | _ -> failwith "Type error"
    end
  | Fst e ->
    begin match infer_type env e with
    | TPair(tp1, _) -> tp1
    | _ -> failwith "Type error"
    end
  | Snd e ->
    begin match infer_type env e with
    | TPair(_, tp2) -> tp2
    | _ -> failwith "Type error"
    end
  | Fun(x, tp1, e) ->
    let tp2 = infer_type (Env.add_var env x tp1) e in
    TArrow(tp1, tp2)
  | Funrec(f, x, tp1, tp2, e) ->
    let env = Env.add_var env x tp1 in
    let env = Env.add_var env f (TArrow(tp1, tp2)) in
    check_type env e tp2;
    TArrow(tp1, tp2)

and check_type env e tp =
  let tp' = infer_type env e in
  if tp = tp' then ()
  else
    failwith "Type error"

let check_program e =
  let _ = infer_type Env.initial e in
  e
