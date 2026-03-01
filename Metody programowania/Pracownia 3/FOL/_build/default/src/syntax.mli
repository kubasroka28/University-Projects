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

module Term : sig
  type t = term

  val equal : t -> t -> bool

  val contains_tvar : term_var -> t -> bool

  val subst : term_var -> term -> t -> t

  val to_string : t -> string
end

module Formula : sig
  type t = formula

  val equal : t -> t -> bool

  val contains_tvar : term_var -> t -> bool

  val subst : term_var -> term -> t -> t

  val subst_rel : rel_symbol -> term_var * formula -> t -> t

  val to_string : t -> string
end
