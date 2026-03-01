open RawAst

(* Zadanie 2 *)
type error = (Lexing.position * Lexing.position) * string
exception Type_error of error
exception Multiple_type_errors of error list

module Env = struct
  module StrMap = Map.Make(String)
  type t = typ StrMap.t

  let initial = StrMap.empty

  let add_var env x tp =
    StrMap.add x tp env

  let lookup_var env x =
    StrMap.find_opt x env
end

let rec string_of_type (tp : typ) : string =
  match tp with
  | TInt -> "int"
  | TBool -> "bool"
  | TUnit -> "unit"
  | TPair (tp1, tp2) -> "(" ^ (string_of_type tp1) ^ ") * (" ^ (string_of_type tp2) ^ ")"
  | TArrow (tp1, tp2) -> "(" ^ (string_of_type tp1) ^ ") -> (" ^ (string_of_type tp2) ^ ")"

(* Zadanie 2 *)
let errors = ref []

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
    | _ ->
      raise (Type_error(e1.pos,
        Printf.sprintf "Expression is not a function"))
    end
  | Fst e ->
    begin match infer_type env e with
    | TPair(tp1, _) -> tp1
    | _ -> 
      raise (Type_error(e.pos,
        Printf.sprintf "Expression is not a pair"))
    end
  | Snd e ->
    begin match infer_type env e with
    | TPair(_, tp2) -> tp2
    | _ ->
      raise (Type_error(e.pos,
        Printf.sprintf "Expression is not a pair"))
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
    (* Zadanie 2 *)
    errors := (e.pos,
      Printf.sprintf "This expression has type " ^
      (string_of_type tp') ^ " but an expression was expected of type " ^
      (string_of_type tp)) :: !errors

(* Zadanie 2 *)
let check_program e =
  let _ = infer_type Env.initial e in
  match !errors with
  | [] -> e
  | _ -> raise (Multiple_type_errors (!errors))

(* Zmodyfikowana jest również funkcja main tak, aby poprawnie wypisać wszystkie błedy*)
