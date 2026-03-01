open Ast

let parse (s : string) : qbf =
  Parser.main Lexer.read (Lexing.from_string s)

let rec subst (x : ident) (s : qbf) (f : qbf) : qbf = 
  match f with
  | Var y -> if x = y then s else f 
  | Disj (phi, psi) -> Disj (subst x s phi, subst x s psi)
  | Conj (phi, psi) -> Conj (subst x s phi, subst x s psi)
  | Not phi -> Not (subst x s phi)
  | Forall (y, phi) -> if x = y then f else Forall (y, subst x s phi)
  | Exists (y, phi) -> if x = y then f else Exists (y, subst x s phi)
  | _ -> f

let rec eval (f : qbf) : bool = 
  match f with
  | Top -> true
  | Bot -> false
  | Var x -> failwith ("unbounded variable " ^ x)
  | Disj (phi, psi) -> (eval phi) || (eval psi)
  | Conj (phi, psi) -> (eval phi) && (eval psi)
  | Not phi -> not (eval phi)
  | Forall (x, phi) -> (eval (subst x Top phi)) && (eval (subst x Bot phi))
  | Exists (x, phi) -> (eval (subst x Top phi)) || (eval (subst x Bot phi))

let interp (s : string) : bool =
eval (parse s)