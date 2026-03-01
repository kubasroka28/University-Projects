type ident = string

type qbf =
| Top                   (* ⊤ *)
| Bot                   (* ⊥ *)
| Var of ident          (* x *)
| Disj of qbf * qbf     (* ∨ *)
| Conj of qbf * qbf     (* ∧ *)
| Not of qbf            (* ¬ *)
| Forall of ident * qbf (* ∀ *)
| Exists of ident * qbf (* ∃ *)