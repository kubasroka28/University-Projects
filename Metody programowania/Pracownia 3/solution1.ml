open Syntax

(*
Notatki

Uzupełnić failwith odpowiednimi komentarzami
*)

exception Unbound_term of string

module Env = struct
  module StrMap = Map.Make(String)
  type term_vars_env = unit StrMap.t
  type proof_vars_env = formula StrMap.t

  let initial = StrMap.empty

  let add_term_var env t =
    StrMap.add t () env

  let add_proof_var env p f =
    StrMap.add p f env

  let lookup_var env x =
    StrMap.find_opt x env
end
  
let rec wft (delta : Env.term_vars_env) (t : term)  : unit =
  match t with
  | Var x ->
    begin match Env.lookup_var delta x with
    | Some _ -> ()
    | None -> raise (Unbound_term ("Unbound term variable " ^ x))
    end
  | Func (_, terms) ->
    List.iter (wft delta) terms

let rec wff (delta : Env.term_vars_env) (f : formula) : unit =
  match f with
  | False -> ()
  | Rel (_, terms) ->
    List.iter (wft delta) terms
  | Imp (f1, f2) 
  | And (f1, f2) 
  | Or  (f1, f2) ->
    wff delta f1;
    wff delta f2
  | Forall (x, f) 
  | Exists (x, f) ->
    wff (Env.add_term_var delta x) f
  | ForallRel (_, f) ->
    wff delta f   

let rec check_proof (delta : Env.term_vars_env) (gamma : Env.proof_vars_env) (e : expr) : formula =
  match e.data with
  | EVar x ->
      begin match Env.lookup_var gamma x with
      | Some f -> f
      | None -> raise (Type_error (e.pos, "Unknown definition " ^ x))
      end
  | ELet(x, e1, e2) ->
    let f1 = check_proof delta gamma e1 in
    let f2 = check_proof delta (Env.add_proof_var gamma x f1) e2 in
    f2
    (*NOT IMPLEMENTED*)
  | EFun(x, f1, e) ->
      (
        try wff delta f1 with
        | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wff delta f1;*) (* Może tutaj będę musiał dać try, a może to gdzieś wyżej przechwycę*)
      let new_gamma = Env.add_proof_var gamma x f1 in
      let f2 = check_proof delta new_gamma e in
      Imp(f1, f2)
  | EApp(e1, e2) ->
      begin match check_proof delta gamma e1 with
      | Imp(f2, f1) ->
        check_formula delta gamma e2 f2;
        f1
      | _-> failwith ""
      end
  | ETermFun(x, e) ->
      begin match Env.lookup_var delta x with
      | Some _ -> failwith "coś tam x nie powinien tu być"
      | None ->
        let new_delta = Env.add_term_var delta x in
        let f = check_proof new_delta gamma e in
        Forall(x, f)
      end
  | ETermApp(e, t) ->
      (
        try wft delta t; with
        | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wft delta t;*)
      begin match check_proof delta gamma e with
      | Forall(x, f) ->
        Formula.subst x t f (*TUTAJ ZA X W F MUSZE PODSTAWIC T. TRZEBA UZYĆ JAKIEJŚ FUNKCJI*)
      | _ -> failwith ""
      end
  | ERelApp(e, x, f2) ->
      let new_delta = Env.add_term_var delta x in
      (
      try wff new_delta f2 with
      | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wff new_delta f2;*)
      begin match check_proof delta gamma e with
      | ForallRel(r, f1) ->
        Formula.subst_rel r (x, f2) f1 (*Podstawienie jakiegoś czegoś*)
      | _ -> failwith ""
      end
  | EPair(e1, e2)->
      And(check_proof delta gamma e1, check_proof delta gamma e2)
  | EFst e ->
      begin match check_proof delta gamma e with
      | And(f1, _) -> f1
      | _ -> failwith ""
      end
  | ESnd e ->
      begin match check_proof delta gamma e with
      | And(_, f2) -> f2
      | _ -> failwith ""
      end
  | ELeft(e, f) ->
      (
      try wff delta f with
      | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wff delta f;*)
      begin match f with
      | Or(f1, _) ->
        check_formula delta gamma e f1;
        f
      | _ -> failwith ""
      end
  | ERight(e, f) ->
      (
      try wff delta f with
      | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wff delta f;*)
      begin match f with
      | Or(_, f2) ->
        check_formula delta gamma e f2;
        f
      | _ -> failwith ""
      end
  | ECase(e, x, e1, y, e2) ->
      begin match check_proof delta gamma e with
      | Or(f1, f2) ->
        let new_gamma1 = Env.add_proof_var gamma x f1 in
        let new_gamma2 = Env.add_proof_var gamma y f2 in
        let f = check_proof delta new_gamma1 e1 in
        check_formula delta new_gamma2 e2 f;
        f
      | _ -> failwith ""
      end
  | EAbsurd(e, f) ->
      (
      try wff delta f with
      | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wff delta f;*)
      begin match check_proof delta gamma e with
      | False -> f
      | _ -> failwith ""
      end
  | EPack(t, e, f1) ->
      (
      try wft delta t; wff delta f1 with
      | Unbound_term s -> raise (Type_error (e.pos, s))
      );
      (*wft delta t;
      wff delta f1;*)
      begin match f1 with
      | Exists(x, f2) ->
        let new_f2 = Formula.subst x t f2 (*Jakieś podstawienie t za x*) in
        check_formula delta gamma e new_f2;
        f1
      | _ -> failwith ""
      end
  | EUnpack(x, y, e1, e2) -> (* a może tutaj przy x musze dać _, bo mi jest niepotrzebny?*)
      begin match check_proof delta gamma e1 with
      | Exists(x', f1) -> (* Czy tutaj faktycznie sprawdzam, że ten x z dopasowania jest równy temu u góry? Chyba nie, może to będzie problem*)
        (
          if x = x' then () else failwith ""
        );
        begin match Env.lookup_var delta x with
        | Some _ -> failwith "coś tam x nie powinien tu być"
        | None ->
          let new_delta = Env.add_term_var delta x in
          let new_gamma = Env.add_proof_var gamma y f1 in
          let f2 = check_proof new_delta new_gamma e2 in
          (
          try wff delta f2 with
          | Unbound_term s -> raise (Type_error (e.pos, s))
          );
          (*wff delta f2;*)
          f2
        end
      | _ -> failwith ""
      end

and check_formula delta gamma e f : unit =
  let f' = check_proof delta gamma e in
  if Formula.equal f f' (*ALPHA RÓWNOWAŻNOŚĆ*) then ()
  else
    failwith ""

let check_def (gamma : Env.proof_vars_env) (d : def) : Env.proof_vars_env =
  match d with
  | Axiom (pos, axiom_name, axiom_content) ->
    (
      try wff Env.initial axiom_content with
      | Unbound_term s -> raise (Type_error (pos, s))
    );
    Env.add_proof_var gamma axiom_name axiom_content
  | Theorem (pos, theorem_name, theorem_content, proof) ->
    (
      try wff Env.initial theorem_content with
      | Unbound_term s -> raise (Type_error (pos, s))
    );
    check_formula Env.initial gamma proof theorem_content;
    Env.add_proof_var gamma theorem_name theorem_content

let check_defs (ds : def list) : unit =
  let rec iter (gamma : Env.proof_vars_env) (ds : def list) : unit =
    match ds with
    | [] -> ()
    | d :: rest ->
      let new_gamma = check_def gamma d
      in iter new_gamma rest
  in
  iter Env.initial ds
