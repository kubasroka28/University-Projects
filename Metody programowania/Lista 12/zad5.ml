type 'v nnf =
| NNFLit of bool * 'v
| NNFConj of 'v nnf * 'v nnf
| NNFDisj of 'v nnf * 'v nnf

(*general form*)
type 'v gf =
| Lit   of 'v
| Neg   of 'v gf
| Conj  of 'v gf * 'v gf
| Disj  of 'v gf * 'v gf
| Imp   of 'v gf * 'v gf
| Equiv of 'v gf * 'v gf 

let rec general_to_NNF (negation_flag : bool) (e : 'v gf) : 'v nnf =
  let simplify (e : 'v gf) : 'v gf =
    match e with
    | Imp   (e1, e2) -> Disj(Neg e1, e2)
    | Equiv (e1, e2) -> Conj(Imp(e1,e2), Imp(e2,e1))
    | _ -> e in
  if not negation_flag then
    match e with
    | Lit   l        -> NNFLit(true, l)
    | Conj  (e1, e2) -> NNFConj(general_to_NNF e1, general_to_NNF e2)
    | Disj  (e1, e2) -> NNFDisj(general_to_NNF e1, general_to_NNF e2)
    | Imp   (e1, e2) -> general_to_NNF (simplify e)
    | Equiv (e1, e2) -> general_to_NNF (simplify e)
    | Neg e -> general_to_NNF true e
  else
    match e with
    | Lit l -> NNFLit(false, l)
    | Neg e -> general_to_NNF false e
    | Conj  (e1, e2) -> NNFDisj(general_to_NNF true e1, general_to_NNF true e2)
    | Disj  (e1, e2) -> NNFConj(general_to_NNF true e1, general_to_NNF true e2)
    | Imp   (e1, e2) -> general_to_NNF (simplify e)
    | Equiv (e1, e2) -> general_to_NNF (simplify e)
    

















  

(*
(*general form*)
type 'v gf =
| Lit of 'v
| Neg of 'v gf
| Conj of 'v gf * 'v gf
| Disj of 'v gf * 'v gf


let rec general_to_NNF (e : 'v gf) : 'v nnf =
  let aux (n : bool) (e : 'v gf) : 'v nnf =
    match e with
    | Lit l -> NNFLit(false, l)
    | Neg e -> aux (not n) e
    | Conj (e1, e2) -> if n then  else NNFConj(general_to_NNF e1, general_to_NNF e2)
    | Disj (e1, e2) ->
    in false e
*)


 