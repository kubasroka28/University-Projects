type position = Lexing.position * Lexing.position

type fun_symbol = string
type rel_symbol = string

type term_var = string
type prf_var  = string

type term =
  | Var  of term_var
  | Func of fun_symbol * term list

type formula =
  | False
  | Rel       of rel_symbol * term list
  | Imp       of formula * formula
  | And       of formula * formula
  | Or        of formula * formula
  | Forall    of term_var * formula
  | ForallRel of rel_symbol * formula
  | Exists    of term_var * formula

type expr =
  { pos  : position;
    data : expr_data
  }
and expr_data =
  | EVar     of prf_var
  | ELet     of prf_var * expr * expr
  | EFun     of prf_var * formula * expr
  | EApp     of expr * expr
  | ETermFun of term_var * expr
  | ETermApp of expr * term
  | ERelApp  of expr * term_var * formula
  | EPair    of expr * expr
  | EFst     of expr
  | ESnd     of expr
  | ELeft    of expr * formula
  | ERight   of expr * formula
  | ECase    of expr * prf_var * expr * prf_var * expr
  | EAbsurd  of expr * formula
  | EPack    of term * expr * formula
  | EUnpack  of term_var * prf_var * expr * expr

type def =
  | Axiom   of position * prf_var * formula
  | Theorem of position * prf_var * formula * expr

exception Type_error of position * string

module StrMap = Map.Make(String)

module EqualEnv = struct
  type t =
    { tvars1 : term_var StrMap.t;
      tvars2 : term_var StrMap.t;
      rvars1 : rel_symbol StrMap.t;
      rvars2 : rel_symbol StrMap.t
    }

  let empty =
    { tvars1 = StrMap.empty;
      tvars2 = StrMap.empty;
      rvars1 = StrMap.empty;
      rvars2 = StrMap.empty
    }

  let add_tvar env x1 x2 =
    { env with
      tvars1 = StrMap.add x1 x2 env.tvars1;
      tvars2 = StrMap.add x2 x1 env.tvars2
    }

  let add_rvar env r1 r2 =
    { env with
      rvars1 = StrMap.add r1 r2 env.rvars1;
      rvars2 = StrMap.add r2 r1 env.rvars2
    }

  let tvar_equal env x1 x2 =
    match StrMap.find_opt x1 env.tvars1, StrMap.find_opt x2 env.tvars2 with
    | None, None -> x1 = x2
    | Some v2, Some v1 -> x1 = v1 && x2 = v2
    | _ -> false

  let rvar_equal env r1 r2 =
    match StrMap.find_opt r1 env.rvars1, StrMap.find_opt r2 env.rvars2 with
    | None, None -> r1 = r2
    | Some v2, Some v1 -> r1 = v1 && r2 = v2
    | _ -> false
end

let paren p p' s =
  if p > p' then Printf.sprintf "(%s)" s else s

let fresh_var contains ctx x =
  if contains x ctx then
    let rec loop n =
      let y = Printf.sprintf "%s_%d" x n in
      if contains y ctx then loop (n + 1)
      else y
    in loop 0
  else x

let rec term_contains_tvar x t =
  match t with
  | Var y -> x = y
  | Func(_, ts) -> List.exists (term_contains_tvar x) ts

let rec formula_contains_tvar x f =
  match f with
  | False -> false
  | Rel(_, ts) -> List.exists (term_contains_tvar x) ts
  | Imp(f1, f2) | And(f1, f2) | Or(f1, f2) ->
    formula_contains_tvar x f1 || formula_contains_tvar x f2
  | Forall(y, f) | Exists(y, f) ->
    x <> y && formula_contains_tvar x f
  | ForallRel(_, f) ->
    formula_contains_tvar x f

let rec formula_contains_rvar r f =
  match f with
  | False -> false
  | Rel(r', [_]) -> r = r'
  | Rel _ -> false
  | Imp(f1, f2) | And(f1, f2) | Or(f1, f2) ->
    formula_contains_rvar r f1 || formula_contains_rvar r f2
  | Forall(_, f) | Exists(_, f) ->
    formula_contains_rvar r f
  | ForallRel(r2, f) ->
    r <> r2 && formula_contains_rvar r f

let rel_contains_tvar x (y, f) =
  x <> y && formula_contains_tvar x f

module Subst : sig
  type t

  val singleton_t : term_var -> term -> t
  val singleton_r : rel_symbol -> term_var * formula -> t

  val extend_t : t -> term_var -> t * term_var
  val extend_r : t -> rel_symbol -> t * rel_symbol

  val lookup_t : t -> term_var -> term option
  val lookup_r : t -> rel_symbol -> (term_var * formula) option
end = struct
  type t = term StrMap.t * (term_var * formula) StrMap.t

  let contains_tvar x (tsub, rsub) =
    StrMap.exists (fun _ t -> term_contains_tvar x t) tsub ||
    StrMap.exists (fun _ r -> rel_contains_tvar x r) rsub

  let contains_rvar r (_, rsub) =
    StrMap.exists (fun _ (_, f) -> formula_contains_rvar r f) rsub

  let singleton_t x t =
    (StrMap.singleton x t, StrMap.empty)

  let singleton_r r rel =
    (StrMap.empty, StrMap.singleton r rel)

  let extend_t (tsub, rsub) x =
    let tsub = StrMap.remove x tsub in
    let y = fresh_var contains_tvar (tsub, rsub) x in
    if x = y then
      ((tsub, rsub), x)
    else
      ((StrMap.add x (Var y) tsub, rsub), y)

  let extend_r (tsub, rsub) r =
    let rsub = StrMap.remove r rsub in
    let r2 = fresh_var contains_rvar (tsub, rsub) r in
    if r = r2 then
      ((tsub, rsub), r)
    else
      let rel = ("#1", Rel(r2, [Var "#1"])) in
      ((tsub, StrMap.add r rel rsub), r2)

  let lookup_t (tsub, _) x =
    StrMap.find_opt x tsub

  let lookup_r (_, rsub) r =
    StrMap.find_opt r rsub
end

module Term = struct
  type t = term

  let rec equal_with env t1 t2 =
    match t1, t2 with
    | Var x1, Var x2 -> EqualEnv.tvar_equal env x1 x2
    | Var _,  _ -> false
    | Func(f1, ts1), Func(f2, ts2) ->
      f1 = f2 && List.length ts1 = List.length ts2 &&
      List.for_all2 (equal_with env) ts1 ts2
    | Func _, _ -> false

  let equal f1 f2 =
    equal_with EqualEnv.empty f1 f2
  
  let contains_tvar = term_contains_tvar

  let rec subst_rec sub t =
    match t with
    | Var x ->
      begin match Subst.lookup_t sub x with
      | Some t -> t
      | None   -> t
      end
    | Func(f, ts) ->
      Func(f, List.map (subst_rec sub) ts)

  let subst x tm f =
    subst_rec (Subst.singleton_t x tm) f

  let rec to_nat n t =
    match t with
    | Func("z", [])  -> Some n
    | Func("s", [t]) -> to_nat (n + 1) t
    | _ -> None

  let rec pretty_print p t =
    match t with
    | Var x -> x
    | Func(("+" | "-") as op, [t1; t2]) ->
      paren p 0
        (Printf.sprintf "%s %s %s" (pretty_print 1 t1) op (pretty_print 0 t2))
    | Func(("*" | "/") as op, [t1; t2]) ->
      paren p 1
        (Printf.sprintf "%s %s %s" (pretty_print 2 t1) op (pretty_print 1 t2))
    | Func(f, args) ->
      begin match to_nat 0 t with
      | Some n -> string_of_int n
      | None ->
        let args_str = String.concat ", " (List.map (pretty_print 0) args) in
        Printf.sprintf "%s(%s)" f args_str
      end

  let to_string t =
    pretty_print 0 t
end

module Formula = struct
  type t = formula

  let rec equal_with env f1 f2 =
    match f1, f2 with
    | False, False -> true
    | False, _     -> false

    | Rel(r1, ts1), Rel(r2, ts2) ->
      let n1 = List.length ts1 in
      n1 = List.length ts2 &&
      (if n1 = 1 then EqualEnv.rvar_equal env r1 r2 else r1 = r2) &&
      List.for_all2 (Term.equal_with env) ts1 ts2
    | Rel _, _ -> false

    | Imp(fa1, fb1), Imp(fa2, fb2)
    | And(fa1, fb1), And(fa2, fb2)
    | Or (fa1, fb1), Or (fa2, fb2) ->
      equal_with env fa1 fa2 &&
      equal_with env fb1 fb2
    | Imp _, _ | And _, _ | Or _, _ -> false

    | Forall(x1, f1), Forall(x2, f2)
    | Exists(x1, f1), Exists(x2, f2) ->
      let env = EqualEnv.add_tvar env x1 x2 in
      equal_with env f1 f2
    | Forall _, _ | Exists _, _ -> false

    | ForallRel(r1, f1), ForallRel(r2, f2) ->
      let env = EqualEnv.add_rvar env r1 r2 in
      equal_with env f1 f2
    | ForallRel _, _ -> false

  let equal f1 f2 =
    equal_with EqualEnv.empty f1 f2

  let contains_tvar = formula_contains_tvar

  let rec subst_rec sub f =
    match f with
    | False       -> False
    | Rel(r, [t]) ->
      let t = Term.subst_rec sub t in
      begin match Subst.lookup_r sub r with
      | Some (x, f) -> subst x t f
      | None        -> Rel(r, [t])
      end
    | Rel(r, ts)  -> Rel(r, List.map (Term.subst_rec sub) ts)
    | Imp(f1, f2) -> Imp(subst_rec sub f1, subst_rec sub f2)
    | And(f1, f2) -> And(subst_rec sub f1, subst_rec sub f2)
    | Or (f1, f2) -> Or (subst_rec sub f1, subst_rec sub f2)
    | Forall(x, f) ->
      let (sub, x) = Subst.extend_t sub x in
      Forall(x, subst_rec sub f)
    | ForallRel(r, f) ->
      let (sub, r) = Subst.extend_r sub r in
      ForallRel(r, subst_rec sub f)
    | Exists(x, f) ->
      let (sub, x) = Subst.extend_t sub x in
      Exists(x, subst_rec sub f)

  and subst x tm f =
    subst_rec (Subst.singleton_t x tm) f

  let subst_rel x rel f =
    subst_rec (Subst.singleton_r x rel) f

  let rec pretty_print p f =
    match f with
    | False -> "⊥"
    | Rel(("=" | "<" | ">") as op, [t1; t2]) ->
      Printf.sprintf "%s %s %s" (Term.to_string t1) op (Term.to_string t2)
    | Rel("<>", [t1; t2]) ->
      Printf.sprintf "%s ≠ %s" (Term.to_string t1) (Term.to_string t2)
    | Rel("<=", [t1; t2]) ->
      Printf.sprintf "%s ≤ %s" (Term.to_string t1) (Term.to_string t2)
    | Rel(">=", [t1; t2]) ->
      Printf.sprintf "%s ≥ %s" (Term.to_string t1) (Term.to_string t2)
    | Rel(r, []) -> r
    | Rel(r, ts) ->
      Printf.sprintf "%s(%s)" r
        (String.concat ", " (List.map Term.to_string ts))
    | Imp(f1, f2) ->
      paren p 0
        (Printf.sprintf "%s → %s" (pretty_print 1 f1) (pretty_print 0 f2))
    | And(f1, f2) ->
      paren p 2
        (Printf.sprintf "%s ∧ %s" (pretty_print 3 f1) (pretty_print 2 f2))
    | Or (f1, f2) ->
      paren p 1
        (Printf.sprintf "%s ∨ %s" (pretty_print 2 f1) (pretty_print 1 f2))
    | Forall _ | ForallRel _ ->
      paren p 0 (pretty_print_forall "∀" f)
    | Exists _ ->
      paren p 0 (pretty_print_exists "∃" f)

  and pretty_print_forall acc f =
    match f with
    | Forall(x, f) ->
      pretty_print_forall (Printf.sprintf "%s %s" acc x) f
    | ForallRel(r, f) ->
      pretty_print_forall (Printf.sprintf "%s {%s}" acc r) f
    | _ ->
      Printf.sprintf "%s, %s" acc (pretty_print 0 f)

  and pretty_print_exists acc f =
    match f with
    | Exists(x, f) ->
      pretty_print_exists (Printf.sprintf "%s %s" acc x) f
    | _ ->
      Printf.sprintf "%s, %s" acc (pretty_print 0 f)

  let to_string f =
    pretty_print 0 f
end
