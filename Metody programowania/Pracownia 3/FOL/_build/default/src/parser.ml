
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | UNPACK
    | TIMES
    | THEOREM
    | SND
    | SBR_OPN
    | SBR_CLS
    | RIGHT
    | QED
    | PROOF
    | PLUS
    | PACK
    | OR
    | OF
    | NUM of (
# 51 "src/parser.mly"
       (int)
# 28 "src/parser.ml"
  )
    | NOT
    | NEQ
    | MINUS
    | LT
    | LET
    | LEQ
    | LEFT
    | IN
    | IDENT of (
# 50 "src/parser.mly"
       (string)
# 41 "src/parser.ml"
  )
    | GT
    | GEQ
    | FUN
    | FST
    | FROM
    | FORALL
    | FALSE
    | EXISTS
    | EQ
    | EOF
    | DIV
    | COMMA
    | COLON
    | CBR_OPN
    | CBR_CLS
    | CASE
    | BR_OPN
    | BR_CLS
    | BAR
    | AXIOM
    | ARR
    | AND
    | ABSURD
  
end

include MenhirBasics

# 1 "src/parser.mly"
  
open Syntax

let node pos data =
  { data; pos }

let rec mk_num n =
  if n = 0 then Func("z", [])
  else Func("s", [ mk_num (n-1) ])

let mk_not f = Imp(f, False)

let mk_forall xs f =
  List.fold_right
    (fun x f ->
      match x with
      | Either.Left  x -> Forall(x, f)
      | Either.Right x -> ForallRel(x, f))
    xs
    f

let mk_exists xs f =
  List.fold_right (fun x f -> Exists(x, f)) xs f

let rec mk_fun ?pos args body =
  match args with
  | [] -> body
  | (p1, arg) :: args ->
    let pos =
      match pos with
      | None     -> (fst p1, snd body.pos)
      | Some pos -> pos
    in
    let body = mk_fun args body in
    { pos;
      data =
        begin match arg with
        | Either.Left  x     -> ETermFun(x, body)
        | Either.Right(x, f) -> EFun(x, f, body)
        end
    }

let formula_of_term tm =
  match tm with
  | Var x       -> Rel(x, [])
  | Func(f, ts) -> Rel(f, ts)


# 120 "src/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_main) _menhir_state
    (** State 000.
        Stack shape : .
        Start symbol: main. *)

  | MenhirState003 : (('s, _menhir_box_main) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 003.
        Stack shape : THEOREM IDENT.
        Start symbol: main. *)

  | MenhirState005 : (('s, _menhir_box_main) _menhir_cell1_NOT, _menhir_box_main) _menhir_state
    (** State 005.
        Stack shape : NOT.
        Start symbol: main. *)

  | MenhirState007 : (('s, _menhir_box_main) _menhir_cell1_IDENT _menhir_cell0_BR_OPN, _menhir_box_main) _menhir_state
    (** State 007.
        Stack shape : IDENT BR_OPN.
        Start symbol: main. *)

  | MenhirState008 : (('s, _menhir_box_main) _menhir_cell1_BR_OPN, _menhir_box_main) _menhir_state
    (** State 008.
        Stack shape : BR_OPN.
        Start symbol: main. *)

  | MenhirState015 : (('s, _menhir_box_main) _menhir_cell1_term _menhir_cell0_mult_op, _menhir_box_main) _menhir_state
    (** State 015.
        Stack shape : term mult_op.
        Start symbol: main. *)

  | MenhirState017 : (('s, _menhir_box_main) _menhir_cell1_term _menhir_cell0_add_op, _menhir_box_main) _menhir_state
    (** State 017.
        Stack shape : term add_op.
        Start symbol: main. *)

  | MenhirState020 : (('s, _menhir_box_main) _menhir_cell1_term, _menhir_box_main) _menhir_state
    (** State 020.
        Stack shape : term.
        Start symbol: main. *)

  | MenhirState025 : (('s, _menhir_box_main) _menhir_cell1_FORALL, _menhir_box_main) _menhir_state
    (** State 025.
        Stack shape : FORALL.
        Start symbol: main. *)

  | MenhirState031 : ((('s, _menhir_box_main) _menhir_cell1_FORALL, _menhir_box_main) _menhir_cell1_nonempty_list_forall_arg_, _menhir_box_main) _menhir_state
    (** State 031.
        Stack shape : FORALL nonempty_list(forall_arg).
        Start symbol: main. *)

  | MenhirState033 : (('s, _menhir_box_main) _menhir_cell1_EXISTS, _menhir_box_main) _menhir_state
    (** State 033.
        Stack shape : EXISTS.
        Start symbol: main. *)

  | MenhirState034 : (('s, _menhir_box_main) _menhir_cell1_IDENT, _menhir_box_main) _menhir_state
    (** State 034.
        Stack shape : IDENT.
        Start symbol: main. *)

  | MenhirState037 : ((('s, _menhir_box_main) _menhir_cell1_EXISTS, _menhir_box_main) _menhir_cell1_nonempty_list_IDENT_, _menhir_box_main) _menhir_state
    (** State 037.
        Stack shape : EXISTS nonempty_list(IDENT).
        Start symbol: main. *)

  | MenhirState038 : (('s, _menhir_box_main) _menhir_cell1_BR_OPN, _menhir_box_main) _menhir_state
    (** State 038.
        Stack shape : BR_OPN.
        Start symbol: main. *)

  | MenhirState046 : (('s, _menhir_box_main) _menhir_cell1_term _menhir_cell0_cmp_op, _menhir_box_main) _menhir_state
    (** State 046.
        Stack shape : term cmp_op.
        Start symbol: main. *)

  | MenhirState051 : (('s, _menhir_box_main) _menhir_cell1_formula, _menhir_box_main) _menhir_state
    (** State 051.
        Stack shape : formula.
        Start symbol: main. *)

  | MenhirState055 : (('s, _menhir_box_main) _menhir_cell1_formula, _menhir_box_main) _menhir_state
    (** State 055.
        Stack shape : formula.
        Start symbol: main. *)

  | MenhirState057 : (('s, _menhir_box_main) _menhir_cell1_formula, _menhir_box_main) _menhir_state
    (** State 057.
        Stack shape : formula.
        Start symbol: main. *)

  | MenhirState061 : (('s, _menhir_box_main) _menhir_cell1_forall_arg, _menhir_box_main) _menhir_state
    (** State 061.
        Stack shape : forall_arg.
        Start symbol: main. *)

  | MenhirState065 : ((('s, _menhir_box_main) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_formula, _menhir_box_main) _menhir_state
    (** State 065.
        Stack shape : THEOREM IDENT formula.
        Start symbol: main. *)

  | MenhirState071 : (('s, _menhir_box_main) _menhir_cell1_UNPACK _menhir_cell0_SBR_OPN _menhir_cell0_IDENT _menhir_cell0_SBR_CLS _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 071.
        Stack shape : UNPACK SBR_OPN IDENT SBR_CLS IDENT.
        Start symbol: main. *)

  | MenhirState072 : (('s, _menhir_box_main) _menhir_cell1_SND, _menhir_box_main) _menhir_state
    (** State 072.
        Stack shape : SND.
        Start symbol: main. *)

  | MenhirState074 : (('s, _menhir_box_main) _menhir_cell1_BR_OPN, _menhir_box_main) _menhir_state
    (** State 074.
        Stack shape : BR_OPN.
        Start symbol: main. *)

  | MenhirState075 : (('s, _menhir_box_main) _menhir_cell1_RIGHT, _menhir_box_main) _menhir_state
    (** State 075.
        Stack shape : RIGHT.
        Start symbol: main. *)

  | MenhirState077 : ((('s, _menhir_box_main) _menhir_cell1_RIGHT, _menhir_box_main) _menhir_cell1_expr_simple, _menhir_box_main) _menhir_state
    (** State 077.
        Stack shape : RIGHT expr_simple.
        Start symbol: main. *)

  | MenhirState080 : (('s, _menhir_box_main) _menhir_cell1_PACK _menhir_cell0_SBR_OPN, _menhir_box_main) _menhir_state
    (** State 080.
        Stack shape : PACK SBR_OPN.
        Start symbol: main. *)

  | MenhirState082 : ((('s, _menhir_box_main) _menhir_cell1_PACK _menhir_cell0_SBR_OPN, _menhir_box_main) _menhir_cell1_term _menhir_cell0_SBR_CLS, _menhir_box_main) _menhir_state
    (** State 082.
        Stack shape : PACK SBR_OPN term SBR_CLS.
        Start symbol: main. *)

  | MenhirState084 : (((('s, _menhir_box_main) _menhir_cell1_PACK _menhir_cell0_SBR_OPN, _menhir_box_main) _menhir_cell1_term _menhir_cell0_SBR_CLS, _menhir_box_main) _menhir_cell1_expr_simple, _menhir_box_main) _menhir_state
    (** State 084.
        Stack shape : PACK SBR_OPN term SBR_CLS expr_simple.
        Start symbol: main. *)

  | MenhirState088 : (('s, _menhir_box_main) _menhir_cell1_LET _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 088.
        Stack shape : LET IDENT.
        Start symbol: main. *)

  | MenhirState089 : (('s, _menhir_box_main) _menhir_cell1_LEFT, _menhir_box_main) _menhir_state
    (** State 089.
        Stack shape : LEFT.
        Start symbol: main. *)

  | MenhirState091 : ((('s, _menhir_box_main) _menhir_cell1_LEFT, _menhir_box_main) _menhir_cell1_expr_simple, _menhir_box_main) _menhir_state
    (** State 091.
        Stack shape : LEFT expr_simple.
        Start symbol: main. *)

  | MenhirState093 : (('s, _menhir_box_main) _menhir_cell1_FUN, _menhir_box_main) _menhir_state
    (** State 093.
        Stack shape : FUN.
        Start symbol: main. *)

  | MenhirState099 : (('s, _menhir_box_main) _menhir_cell1_BR_OPN _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 099.
        Stack shape : BR_OPN IDENT.
        Start symbol: main. *)

  | MenhirState103 : ((('s, _menhir_box_main) _menhir_cell1_FUN, _menhir_box_main) _menhir_cell1_nonempty_list_fun_arg_, _menhir_box_main) _menhir_state
    (** State 103.
        Stack shape : FUN nonempty_list(fun_arg).
        Start symbol: main. *)

  | MenhirState104 : (('s, _menhir_box_main) _menhir_cell1_FST, _menhir_box_main) _menhir_state
    (** State 104.
        Stack shape : FST.
        Start symbol: main. *)

  | MenhirState106 : (('s, _menhir_box_main) _menhir_cell1_CASE, _menhir_box_main) _menhir_state
    (** State 106.
        Stack shape : CASE.
        Start symbol: main. *)

  | MenhirState107 : (('s, _menhir_box_main) _menhir_cell1_ABSURD, _menhir_box_main) _menhir_state
    (** State 107.
        Stack shape : ABSURD.
        Start symbol: main. *)

  | MenhirState109 : ((('s, _menhir_box_main) _menhir_cell1_ABSURD, _menhir_box_main) _menhir_cell1_expr_simple, _menhir_box_main) _menhir_state
    (** State 109.
        Stack shape : ABSURD expr_simple.
        Start symbol: main. *)

  | MenhirState113 : (('s, _menhir_box_main) _menhir_cell1_expr_pair, _menhir_box_main) _menhir_state
    (** State 113.
        Stack shape : expr_pair.
        Start symbol: main. *)

  | MenhirState114 : (('s, _menhir_box_main) _menhir_cell1_expr_app, _menhir_box_main) _menhir_state
    (** State 114.
        Stack shape : expr_app.
        Start symbol: main. *)

  | MenhirState115 : ((('s, _menhir_box_main) _menhir_cell1_expr_app, _menhir_box_main) _menhir_cell1_SBR_OPN, _menhir_box_main) _menhir_state
    (** State 115.
        Stack shape : expr_app SBR_OPN.
        Start symbol: main. *)

  | MenhirState120 : ((('s, _menhir_box_main) _menhir_cell1_expr_app, _menhir_box_main) _menhir_cell1_CBR_OPN _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 120.
        Stack shape : expr_app CBR_OPN IDENT.
        Start symbol: main. *)

  | MenhirState132 : ((('s, _menhir_box_main) _menhir_cell1_CASE, _menhir_box_main) _menhir_cell1_expr _menhir_cell0_option_BAR_ _menhir_cell0_LEFT _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 132.
        Stack shape : CASE expr option(BAR) LEFT IDENT.
        Start symbol: main. *)

  | MenhirState137 : (((('s, _menhir_box_main) _menhir_cell1_CASE, _menhir_box_main) _menhir_cell1_expr _menhir_cell0_option_BAR_ _menhir_cell0_LEFT _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_expr _menhir_cell0_RIGHT _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 137.
        Stack shape : CASE expr option(BAR) LEFT IDENT expr RIGHT IDENT.
        Start symbol: main. *)

  | MenhirState140 : (('s, _menhir_box_main) _menhir_cell1_fun_arg, _menhir_box_main) _menhir_state
    (** State 140.
        Stack shape : fun_arg.
        Start symbol: main. *)

  | MenhirState143 : ((('s, _menhir_box_main) _menhir_cell1_LET _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_expr, _menhir_box_main) _menhir_state
    (** State 143.
        Stack shape : LET IDENT expr.
        Start symbol: main. *)

  | MenhirState149 : ((('s, _menhir_box_main) _menhir_cell1_UNPACK _menhir_cell0_SBR_OPN _menhir_cell0_IDENT _menhir_cell0_SBR_CLS _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_expr, _menhir_box_main) _menhir_state
    (** State 149.
        Stack shape : UNPACK SBR_OPN IDENT SBR_CLS IDENT expr.
        Start symbol: main. *)

  | MenhirState156 : (('s, _menhir_box_main) _menhir_cell1_AXIOM _menhir_cell0_IDENT, _menhir_box_main) _menhir_state
    (** State 156.
        Stack shape : AXIOM IDENT.
        Start symbol: main. *)

  | MenhirState161 : (('s, _menhir_box_main) _menhir_cell1_def, _menhir_box_main) _menhir_state
    (** State 161.
        Stack shape : def.
        Start symbol: main. *)


and 's _menhir_cell0_add_op = 
  | MenhirCell0_add_op of 's * (string)

and 's _menhir_cell0_cmp_op = 
  | MenhirCell0_cmp_op of 's * (string)

and ('s, 'r) _menhir_cell1_def = 
  | MenhirCell1_def of 's * ('s, 'r) _menhir_state * (Syntax.def)

and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Syntax.expr) * Lexing.position

and ('s, 'r) _menhir_cell1_expr_app = 
  | MenhirCell1_expr_app of 's * ('s, 'r) _menhir_state * (Syntax.expr) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_expr_pair = 
  | MenhirCell1_expr_pair of 's * ('s, 'r) _menhir_state * (Syntax.expr) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_expr_simple = 
  | MenhirCell1_expr_simple of 's * ('s, 'r) _menhir_state * (Syntax.expr) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_forall_arg = 
  | MenhirCell1_forall_arg of 's * ('s, 'r) _menhir_state * ((string, string) Either.t)

and ('s, 'r) _menhir_cell1_formula = 
  | MenhirCell1_formula of 's * ('s, 'r) _menhir_state * (Syntax.formula) * Lexing.position

and ('s, 'r) _menhir_cell1_fun_arg = 
  | MenhirCell1_fun_arg of 's * ('s, 'r) _menhir_state * ((Lexing.position * Lexing.position) *
  (string, string * Syntax.formula) Either.t)

and 's _menhir_cell0_mult_op = 
  | MenhirCell0_mult_op of 's * (string)

and ('s, 'r) _menhir_cell1_nonempty_list_IDENT_ = 
  | MenhirCell1_nonempty_list_IDENT_ of 's * ('s, 'r) _menhir_state * (string list)

and ('s, 'r) _menhir_cell1_nonempty_list_forall_arg_ = 
  | MenhirCell1_nonempty_list_forall_arg_ of 's * ('s, 'r) _menhir_state * ((string, string) Either.t list)

and ('s, 'r) _menhir_cell1_nonempty_list_fun_arg_ = 
  | MenhirCell1_nonempty_list_fun_arg_ of 's * ('s, 'r) _menhir_state * (((Lexing.position * Lexing.position) *
   (string, string * Syntax.formula) Either.t)
  list)

and 's _menhir_cell0_option_BAR_ = 
  | MenhirCell0_option_BAR_ of 's * (unit option)

and ('s, 'r) _menhir_cell1_term = 
  | MenhirCell1_term of 's * ('s, 'r) _menhir_state * (Syntax.term) * Lexing.position

and ('s, 'r) _menhir_cell1_ABSURD = 
  | MenhirCell1_ABSURD of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_AXIOM = 
  | MenhirCell1_AXIOM of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_BR_OPN = 
  | MenhirCell1_BR_OPN of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_BR_OPN = 
  | MenhirCell0_BR_OPN of 's * Lexing.position

and ('s, 'r) _menhir_cell1_CASE = 
  | MenhirCell1_CASE of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_CBR_OPN = 
  | MenhirCell1_CBR_OPN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_EXISTS = 
  | MenhirCell1_EXISTS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_FORALL = 
  | MenhirCell1_FORALL of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_FST = 
  | MenhirCell1_FST of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_FUN = 
  | MenhirCell1_FUN of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_IDENT = 
  | MenhirCell1_IDENT of 's * ('s, 'r) _menhir_state * (
# 50 "src/parser.mly"
       (string)
# 454 "src/parser.ml"
) * Lexing.position * Lexing.position

and 's _menhir_cell0_IDENT = 
  | MenhirCell0_IDENT of 's * (
# 50 "src/parser.mly"
       (string)
# 461 "src/parser.ml"
) * Lexing.position * Lexing.position

and ('s, 'r) _menhir_cell1_LEFT = 
  | MenhirCell1_LEFT of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_LEFT = 
  | MenhirCell0_LEFT of 's * Lexing.position

and ('s, 'r) _menhir_cell1_LET = 
  | MenhirCell1_LET of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_NOT = 
  | MenhirCell1_NOT of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_PACK = 
  | MenhirCell1_PACK of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_RIGHT = 
  | MenhirCell1_RIGHT of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_RIGHT = 
  | MenhirCell0_RIGHT of 's * Lexing.position

and 's _menhir_cell0_SBR_CLS = 
  | MenhirCell0_SBR_CLS of 's * Lexing.position

and ('s, 'r) _menhir_cell1_SBR_OPN = 
  | MenhirCell1_SBR_OPN of 's * ('s, 'r) _menhir_state * Lexing.position

and 's _menhir_cell0_SBR_OPN = 
  | MenhirCell0_SBR_OPN of 's * Lexing.position

and ('s, 'r) _menhir_cell1_SND = 
  | MenhirCell1_SND of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_THEOREM = 
  | MenhirCell1_THEOREM of 's * ('s, 'r) _menhir_state * Lexing.position

and ('s, 'r) _menhir_cell1_UNPACK = 
  | MenhirCell1_UNPACK of 's * ('s, 'r) _menhir_state * Lexing.position

and _menhir_box_main = 
  | MenhirBox_main of (Syntax.def list) [@@unboxed]

let _menhir_action_01 =
  fun () ->
    (
# 100 "src/parser.mly"
        ( "+" )
# 511 "src/parser.ml"
     : (string))

let _menhir_action_02 =
  fun () ->
    (
# 101 "src/parser.mly"
        ( "-" )
# 519 "src/parser.ml"
     : (string))

let _menhir_action_03 =
  fun () ->
    (
# 91 "src/parser.mly"
      ( "="  )
# 527 "src/parser.ml"
     : (string))

let _menhir_action_04 =
  fun () ->
    (
# 92 "src/parser.mly"
      ( "<>" )
# 535 "src/parser.ml"
     : (string))

let _menhir_action_05 =
  fun () ->
    (
# 93 "src/parser.mly"
      ( "<"  )
# 543 "src/parser.ml"
     : (string))

let _menhir_action_06 =
  fun () ->
    (
# 94 "src/parser.mly"
      ( ">"  )
# 551 "src/parser.ml"
     : (string))

let _menhir_action_07 =
  fun () ->
    (
# 95 "src/parser.mly"
      ( "<=" )
# 559 "src/parser.ml"
     : (string))

let _menhir_action_08 =
  fun () ->
    (
# 96 "src/parser.mly"
      ( ">=" )
# 567 "src/parser.ml"
     : (string))

let _menhir_action_09 =
  fun _endpos_f_ _startpos__1_ f x ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 74 "src/parser.mly"
                                                    ( Axiom(_loc, x, f) )
# 578 "src/parser.ml"
     : (Syntax.def))

let _menhir_action_10 =
  fun _endpos_p_ _startpos__1_ f p x ->
    let _endpos = _endpos_p_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 75 "src/parser.mly"
                                                    ( Theorem(_loc, x, f, p) )
# 589 "src/parser.ml"
     : (Syntax.def))

let _menhir_action_11 =
  fun _endpos_e2_ _startpos__1_ e1 e2 x ->
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 145 "src/parser.mly"
    ( node _loc (ELet(x, e1, e2)) )
# 600 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_12 =
  fun _endpos_body_ _startpos__1_ args body ->
    let _endpos = _endpos_body_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 147 "src/parser.mly"
    ( mk_fun ~pos:(_loc) args body )
# 611 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_13 =
  fun _endpos_e2_ _startpos__1_ e e1 e2 x y ->
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 151 "src/parser.mly"
    ( node _loc (ECase(e, x, e1, y, e2)) )
# 622 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_14 =
  fun _endpos_e2_ _startpos__1_ e1 e2 x y ->
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 154 "src/parser.mly"
    ( node _loc (EUnpack(x, y, e1, e2)) )
# 633 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_15 =
  fun e ->
    (
# 155 "src/parser.mly"
                ( e )
# 641 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_16 =
  fun _endpos_f_ _startpos__1_ e f ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 166 "src/parser.mly"
    ( node _loc (ELeft(e, f)) )
# 652 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_17 =
  fun _endpos_f_ _startpos__1_ e f ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 168 "src/parser.mly"
    ( node _loc (ERight(e, f)) )
# 663 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_18 =
  fun _endpos_f_ _startpos__1_ e f ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 170 "src/parser.mly"
    ( node _loc (EAbsurd(e, f)) )
# 674 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_19 =
  fun _endpos_f_ _startpos__1_ e f t ->
    let _endpos = _endpos_f_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 172 "src/parser.mly"
    ( node _loc (EPack(t, e, f)) )
# 685 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_20 =
  fun e ->
    (
# 173 "src/parser.mly"
               ( e )
# 693 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_21 =
  fun _endpos_e2_ _startpos_e1_ e1 e2 ->
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    let _loc = (_startpos, _endpos) in
    (
# 178 "src/parser.mly"
    ( node _loc (EApp(e1, e2)) )
# 704 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_22 =
  fun _endpos__4_ _startpos_e1_ e1 t ->
    let _endpos = _endpos__4_ in
    let _startpos = _startpos_e1_ in
    let _loc = (_startpos, _endpos) in
    (
# 180 "src/parser.mly"
    ( node _loc (ETermApp(e1, t)) )
# 715 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_23 =
  fun _endpos__6_ _startpos_e1_ e1 f x ->
    let _endpos = _endpos__6_ in
    let _startpos = _startpos_e1_ in
    let _loc = (_startpos, _endpos) in
    (
# 182 "src/parser.mly"
    ( node _loc (ERelApp(e1, x, f)) )
# 726 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_24 =
  fun _endpos_e_ _startpos__1_ e ->
    let _endpos = _endpos_e_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 184 "src/parser.mly"
    ( node _loc (EFst e) )
# 737 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_25 =
  fun _endpos_e_ _startpos__1_ e ->
    let _endpos = _endpos_e_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 186 "src/parser.mly"
    ( node _loc (ESnd e) )
# 748 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_26 =
  fun e ->
    (
# 187 "src/parser.mly"
                  ( e )
# 756 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_27 =
  fun _endpos_e2_ _startpos_e1_ e1 e2 ->
    let _endpos = _endpos_e2_ in
    let _startpos = _startpos_e1_ in
    let _loc = (_startpos, _endpos) in
    (
# 160 "src/parser.mly"
    ( node _loc (EPair(e1, e2)) )
# 767 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_28 =
  fun e ->
    (
# 161 "src/parser.mly"
                 ( e )
# 775 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_29 =
  fun _endpos_x_ _startpos_x_ x ->
    let _endpos = _endpos_x_ in
    let _startpos = _startpos_x_ in
    let _loc = (_startpos, _endpos) in
    (
# 192 "src/parser.mly"
    ( node _loc (EVar x) )
# 786 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_30 =
  fun _endpos__3_ _startpos__1_ e ->
    let _endpos = _endpos__3_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 194 "src/parser.mly"
    ( node _loc e.data )
# 797 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_31 =
  fun x ->
    (
# 131 "src/parser.mly"
                              ( Either.Left x  )
# 805 "src/parser.ml"
     : ((string, string) Either.t))

let _menhir_action_32 =
  fun x ->
    (
# 132 "src/parser.mly"
                              ( Either.Right x )
# 813 "src/parser.ml"
     : ((string, string) Either.t))

let _menhir_action_33 =
  fun t ->
    (
# 112 "src/parser.mly"
           ( formula_of_term t )
# 821 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_34 =
  fun f ->
    (
# 113 "src/parser.mly"
                       ( f )
# 829 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_35 =
  fun _endpos__3_ _startpos__1_ x ->
    let _endpos = _endpos__3_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 198 "src/parser.mly"
                              ( (_loc, Either.Left x) )
# 840 "src/parser.ml"
     : ((Lexing.position * Lexing.position) *
  (string, string * Syntax.formula) Either.t))

let _menhir_action_36 =
  fun _endpos__5_ _startpos__1_ f x ->
    let _endpos = _endpos__5_ in
    let _startpos = _startpos__1_ in
    let _loc = (_startpos, _endpos) in
    (
# 199 "src/parser.mly"
                                                ( (_loc, Either.Right(x, f)) )
# 852 "src/parser.ml"
     : ((Lexing.position * Lexing.position) *
  (string, string * Syntax.formula) Either.t))

let _menhir_action_37 =
  fun () ->
    (
# 216 "<standard.mly>"
    ( [] )
# 861 "src/parser.ml"
     : (Syntax.def list))

let _menhir_action_38 =
  fun x xs ->
    (
# 219 "<standard.mly>"
    ( x :: xs )
# 869 "src/parser.ml"
     : (Syntax.def list))

let _menhir_action_39 =
  fun () ->
    (
# 145 "<standard.mly>"
    ( [] )
# 877 "src/parser.ml"
     : (Syntax.term list))

let _menhir_action_40 =
  fun x ->
    (
# 148 "<standard.mly>"
    ( x )
# 885 "src/parser.ml"
     : (Syntax.term list))

let _menhir_action_41 =
  fun e ->
    (
# 70 "src/parser.mly"
                     ( e )
# 893 "src/parser.ml"
     : (Syntax.def list))

let _menhir_action_42 =
  fun () ->
    (
# 105 "src/parser.mly"
        ( "*" )
# 901 "src/parser.ml"
     : (string))

let _menhir_action_43 =
  fun () ->
    (
# 106 "src/parser.mly"
        ( "/" )
# 909 "src/parser.ml"
     : (string))

let _menhir_action_44 =
  fun args f ->
    (
# 118 "src/parser.mly"
    ( mk_forall args f )
# 917 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_45 =
  fun args f ->
    (
# 120 "src/parser.mly"
    ( mk_exists args f )
# 925 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_46 =
  fun f1 f2 ->
    (
# 121 "src/parser.mly"
                                  ( Imp(f1, f2) )
# 933 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_47 =
  fun f1 f2 ->
    (
# 122 "src/parser.mly"
                                  ( Or(f1, f2)  )
# 941 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_48 =
  fun f1 f2 ->
    (
# 123 "src/parser.mly"
                                  ( And(f1, f2) )
# 949 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_49 =
  fun op t1 t2 ->
    (
# 124 "src/parser.mly"
                                    ( Rel(op, [t1; t2]) )
# 957 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_50 =
  fun f ->
    (
# 125 "src/parser.mly"
                   ( mk_not f )
# 965 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_51 =
  fun () ->
    (
# 126 "src/parser.mly"
        ( False )
# 973 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_52 =
  fun f ->
    (
# 127 "src/parser.mly"
                                       ( f )
# 981 "src/parser.ml"
     : (Syntax.formula))

let _menhir_action_53 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 989 "src/parser.ml"
     : (string list))

let _menhir_action_54 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 997 "src/parser.ml"
     : (string list))

let _menhir_action_55 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 1005 "src/parser.ml"
     : ((string, string) Either.t list))

let _menhir_action_56 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 1013 "src/parser.ml"
     : ((string, string) Either.t list))

let _menhir_action_57 =
  fun x ->
    (
# 228 "<standard.mly>"
    ( [ x ] )
# 1021 "src/parser.ml"
     : (((Lexing.position * Lexing.position) *
   (string, string * Syntax.formula) Either.t)
  list))

let _menhir_action_58 =
  fun x xs ->
    (
# 231 "<standard.mly>"
    ( x :: xs )
# 1031 "src/parser.ml"
     : (((Lexing.position * Lexing.position) *
   (string, string * Syntax.formula) Either.t)
  list))

let _menhir_action_59 =
  fun () ->
    (
# 111 "<standard.mly>"
    ( None )
# 1041 "src/parser.ml"
     : (unit option))

let _menhir_action_60 =
  fun x ->
    (
# 114 "<standard.mly>"
    ( Some x )
# 1049 "src/parser.ml"
     : (unit option))

let _menhir_action_61 =
  fun e ->
    (
# 138 "src/parser.mly"
                       ( e )
# 1057 "src/parser.ml"
     : (Syntax.expr))

let _menhir_action_62 =
  fun x ->
    (
# 250 "<standard.mly>"
    ( [ x ] )
# 1065 "src/parser.ml"
     : (Syntax.term list))

let _menhir_action_63 =
  fun x xs ->
    (
# 253 "<standard.mly>"
    ( x :: xs )
# 1073 "src/parser.ml"
     : (Syntax.term list))

let _menhir_action_64 =
  fun t ->
    (
# 81 "src/parser.mly"
                           ( t )
# 1081 "src/parser.ml"
     : (Syntax.term))

let _menhir_action_65 =
  fun op xs ->
    let args = 
# 241 "<standard.mly>"
    ( xs )
# 1089 "src/parser.ml"
     in
    (
# 83 "src/parser.mly"
    ( Func(op, args) )
# 1094 "src/parser.ml"
     : (Syntax.term))

let _menhir_action_66 =
  fun op t1 t2 ->
    (
# 84 "src/parser.mly"
                                                 ( Func(op, [t1; t2]) )
# 1102 "src/parser.ml"
     : (Syntax.term))

let _menhir_action_67 =
  fun op t1 t2 ->
    (
# 85 "src/parser.mly"
                                                 ( Func(op, [t1; t2]) )
# 1110 "src/parser.ml"
     : (Syntax.term))

let _menhir_action_68 =
  fun x ->
    (
# 86 "src/parser.mly"
            ( Var x )
# 1118 "src/parser.ml"
     : (Syntax.term))

let _menhir_action_69 =
  fun n ->
    (
# 87 "src/parser.mly"
            ( mk_num n )
# 1126 "src/parser.ml"
     : (Syntax.term))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | ABSURD ->
        "ABSURD"
    | AND ->
        "AND"
    | ARR ->
        "ARR"
    | AXIOM ->
        "AXIOM"
    | BAR ->
        "BAR"
    | BR_CLS ->
        "BR_CLS"
    | BR_OPN ->
        "BR_OPN"
    | CASE ->
        "CASE"
    | CBR_CLS ->
        "CBR_CLS"
    | CBR_OPN ->
        "CBR_OPN"
    | COLON ->
        "COLON"
    | COMMA ->
        "COMMA"
    | DIV ->
        "DIV"
    | EOF ->
        "EOF"
    | EQ ->
        "EQ"
    | EXISTS ->
        "EXISTS"
    | FALSE ->
        "FALSE"
    | FORALL ->
        "FORALL"
    | FROM ->
        "FROM"
    | FST ->
        "FST"
    | FUN ->
        "FUN"
    | GEQ ->
        "GEQ"
    | GT ->
        "GT"
    | IDENT _ ->
        "IDENT"
    | IN ->
        "IN"
    | LEFT ->
        "LEFT"
    | LEQ ->
        "LEQ"
    | LET ->
        "LET"
    | LT ->
        "LT"
    | MINUS ->
        "MINUS"
    | NEQ ->
        "NEQ"
    | NOT ->
        "NOT"
    | NUM _ ->
        "NUM"
    | OF ->
        "OF"
    | OR ->
        "OR"
    | PACK ->
        "PACK"
    | PLUS ->
        "PLUS"
    | PROOF ->
        "PROOF"
    | QED ->
        "QED"
    | RIGHT ->
        "RIGHT"
    | SBR_CLS ->
        "SBR_CLS"
    | SBR_OPN ->
        "SBR_OPN"
    | SND ->
        "SND"
    | THEOREM ->
        "THEOREM"
    | TIMES ->
        "TIMES"
    | UNPACK ->
        "UNPACK"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_159 : type  ttv_stack. ttv_stack -> _ -> _menhir_box_main =
    fun _menhir_stack _v ->
      let e = _v in
      let _v = _menhir_action_41 e in
      MenhirBox_main _v
  
  let rec _menhir_run_162 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_def -> _ -> _menhir_box_main =
    fun _menhir_stack _v ->
      let MenhirCell1_def (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_38 x xs in
      _menhir_goto_list_def_ _menhir_stack _v _menhir_s
  
  and _menhir_goto_list_def_ : type  ttv_stack. ttv_stack -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _v _menhir_s ->
      match _menhir_s with
      | MenhirState161 ->
          _menhir_run_162 _menhir_stack _v
      | MenhirState000 ->
          _menhir_run_159 _menhir_stack _v
      | _ ->
          _menhir_fail ()
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_THEOREM (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _menhir_s = MenhirState003 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NUM _v ->
                  _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | NOT ->
                  _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FORALL ->
                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | FALSE ->
                  _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | EXISTS ->
                  _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | BR_OPN ->
                  _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_004 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_n_, n) = (_endpos, _v) in
      let _v = _menhir_action_69 n in
      _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_n_ _v _menhir_s _tok
  
  and _menhir_goto_term : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState115 ->
          _menhir_run_116 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState080 ->
          _menhir_run_081 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState156 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState109 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState099 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState091 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState003 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState031 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState037 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState051 ->
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState046 ->
          _menhir_run_047 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState020 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState007 ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState017 ->
          _menhir_run_018 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState015 ->
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState008 ->
          _menhir_run_009 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_116 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_expr_app, _menhir_box_main) _menhir_cell1_SBR_OPN as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | SBR_CLS ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_SBR_OPN (_menhir_stack, _, _) = _menhir_stack in
          let MenhirCell1_expr_app (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
          let (t, _endpos__4_) = (_v, _endpos_0) in
          let _v = _menhir_action_22 _endpos__4_ _startpos_e1_ e1 t in
          _menhir_goto_expr_app _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__4_ _startpos_e1_ _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_010 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_42 () in
      _menhir_goto_mult_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_goto_mult_op : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_mult_op (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | NUM _v_0 ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState015
      | IDENT _v_1 ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState015
      | BR_OPN ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState015
      | _ ->
          _eRR ()
  
  and _menhir_run_006 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | BR_OPN ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell0_BR_OPN (_menhir_stack, _startpos) in
          let _menhir_s = MenhirState007 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BR_OPN ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_CLS ->
              let _v = _menhir_action_39 () in
              _menhir_goto_loption_separated_nonempty_list_COMMA_term__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
          | _ ->
              _eRR ())
      | AND | ARR | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | DIV | EOF | EQ | GEQ | GT | IN | LEQ | LT | MINUS | NEQ | OF | OR | PLUS | PROOF | QED | SBR_CLS | THEOREM | TIMES ->
          let (_endpos_x_, x) = (_endpos, _v) in
          let _v = _menhir_action_68 x in
          _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_x_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_008 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState008 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BR_OPN ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_loption_separated_nonempty_list_COMMA_term__ : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_IDENT _menhir_cell0_BR_OPN -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell0_BR_OPN (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_IDENT (_menhir_stack, _menhir_s, op, _, _) = _menhir_stack in
      let (xs, _endpos__4_) = (_v, _endpos) in
      let _v = _menhir_action_65 op xs in
      _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__4_ _v _menhir_s _tok
  
  and _menhir_goto_expr_app : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SBR_OPN ->
          let _menhir_stack = MenhirCell1_expr_app (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _menhir_s = MenhirState114 in
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell1_SBR_OPN (_menhir_stack, _menhir_s, _startpos) in
          let _menhir_s = MenhirState115 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BR_OPN ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | IDENT _v_3 ->
          let _menhir_stack = MenhirCell1_expr_app (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState114
      | CBR_OPN ->
          let _menhir_stack = MenhirCell1_expr_app (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _menhir_stack = MenhirCell1_CBR_OPN (_menhir_stack, MenhirState114) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
              let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | BAR ->
                  let _menhir_s = MenhirState120 in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | NUM _v ->
                      _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                  | NOT ->
                      _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | IDENT _v ->
                      _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                  | FORALL ->
                      _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | FALSE ->
                      _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | EXISTS ->
                      _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | BR_OPN ->
                      _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | BR_OPN ->
          let _menhir_stack = MenhirCell1_expr_app (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState114
      | BAR | BR_CLS | COMMA | IN | OF | QED ->
          let (_endpos_e_, _startpos_e_, e) = (_endpos, _startpos, _v) in
          let _v = _menhir_action_20 e in
          _menhir_goto_expr_annot _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos_e_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_073 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let (_endpos_x_, _startpos_x_, x) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_29 _endpos_x_ _startpos_x_ x in
      _menhir_goto_expr_simple _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_x_ _startpos_x_ _v _menhir_s _tok
  
  and _menhir_goto_expr_simple : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState072 ->
          _menhir_run_147 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState114 ->
          _menhir_run_123 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState065 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState149 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState071 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState143 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState103 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState137 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState113 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState106 ->
          _menhir_run_111 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState107 ->
          _menhir_run_108 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState104 ->
          _menhir_run_105 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState089 ->
          _menhir_run_090 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState082 ->
          _menhir_run_083 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState075 ->
          _menhir_run_076 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_147 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_SND -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_SND (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_e_, e) = (_endpos, _v) in
      let _v = _menhir_action_25 _endpos_e_ _startpos__1_ e in
      _menhir_goto_expr_app _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_123 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_expr_app -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_expr_app (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_21 _endpos_e2_ _startpos_e1_ e1 e2 in
      _menhir_goto_expr_app _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_111 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_e_, _startpos_e_, e) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_26 e in
      _menhir_goto_expr_app _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos_e_ _v _menhir_s _tok
  
  and _menhir_run_108 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_ABSURD as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr_simple (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState109 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | NOT ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FORALL ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FALSE ->
              _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EXISTS ->
              _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_005 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NOT (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState005 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_025 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_FORALL (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState025 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | CBR_OPN ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_026 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = _v in
      let _v = _menhir_action_31 x in
      _menhir_goto_forall_arg _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_forall_arg : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | IDENT _v_0 ->
          let _menhir_stack = MenhirCell1_forall_arg (_menhir_stack, _menhir_s, _v) in
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState061
      | CBR_OPN ->
          let _menhir_stack = MenhirCell1_forall_arg (_menhir_stack, _menhir_s, _v) in
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState061
      | COMMA ->
          let x = _v in
          let _v = _menhir_action_55 x in
          _menhir_goto_nonempty_list_forall_arg_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_027 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | CBR_CLS ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = _v in
              let _v = _menhir_action_32 x in
              _menhir_goto_forall_arg _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_forall_arg_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState061 ->
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState025 ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_062 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_forall_arg -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_forall_arg (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_56 x xs in
      _menhir_goto_nonempty_list_forall_arg_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_030 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_FORALL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_nonempty_list_forall_arg_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState031 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_032 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _endpos__1_ = _endpos in
      let _v = _menhir_action_51 () in
      _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__1_ _v _menhir_s _tok
  
  and _menhir_goto_non_term_formula : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState156 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState109 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState099 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState091 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState003 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState031 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState037 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState051 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_053 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let (_endpos_f_, f) = (_endpos, _v) in
      let _v = _menhir_action_34 f in
      _menhir_goto_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _v _menhir_s _tok
  
  and _menhir_goto_formula : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState156 ->
          _menhir_run_157 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState120 ->
          _menhir_run_121 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState109 ->
          _menhir_run_110 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState099 ->
          _menhir_run_100 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState091 ->
          _menhir_run_092 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState084 ->
          _menhir_run_085 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState077 ->
          _menhir_run_078 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState003 ->
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState005 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState031 ->
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState037 ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState057 ->
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState055 ->
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState051 ->
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState038 ->
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_157 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_AXIOM _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AXIOM | EOF | THEOREM ->
          let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
          let MenhirCell1_AXIOM (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_09 _endpos_f_ _startpos__1_ f x in
          _menhir_goto_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_051 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_formula -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState051 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_033 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_EXISTS (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState033 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_034 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v_0 ->
          let _menhir_stack = MenhirCell1_IDENT (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          _menhir_run_034 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState034
      | COMMA ->
          let x = _v in
          let _v = _menhir_action_53 x in
          _menhir_goto_nonempty_list_IDENT_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_IDENT_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState033 ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState034 ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_036 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_EXISTS as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_nonempty_list_IDENT_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState037 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_038 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState038 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_035 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_IDENT -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_IDENT (_menhir_stack, _menhir_s, x, _, _) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_54 x xs in
      _menhir_goto_nonempty_list_IDENT_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_057 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_formula -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState057 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_055 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_formula -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState055 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUM _v ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FORALL ->
          _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FALSE ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | EXISTS ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_def : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_def (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | THEOREM ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | AXIOM ->
          _menhir_run_154 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState161
      | EOF ->
          let _v_0 = _menhir_action_37 () in
          _menhir_run_162 _menhir_stack _v_0
      | _ ->
          _eRR ()
  
  and _menhir_run_154 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_AXIOM (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _menhir_s = MenhirState156 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NUM _v ->
                  _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | NOT ->
                  _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FORALL ->
                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | FALSE ->
                  _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | EXISTS ->
                  _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | BR_OPN ->
                  _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_121 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_expr_app, _menhir_box_main) _menhir_cell1_CBR_OPN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | CBR_CLS ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
          let MenhirCell1_CBR_OPN (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr_app (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
          let (f, _endpos__6_) = (_v, _endpos_0) in
          let _v = _menhir_action_23 _endpos__6_ _startpos_e1_ e1 f x in
          _menhir_goto_expr_app _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__6_ _startpos_e1_ _v _menhir_s _tok
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_110 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_ABSURD, _menhir_box_main) _menhir_cell1_expr_simple as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | BR_CLS | COMMA | IN | OF | QED ->
          let MenhirCell1_expr_simple (_menhir_stack, _, e, _, _) = _menhir_stack in
          let MenhirCell1_ABSURD (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_18 _endpos_f_ _startpos__1_ e f in
          _menhir_goto_expr_annot _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_expr_annot : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState065 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState149 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState071 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState143 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState088 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState103 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState137 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState132 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState106 ->
          _menhir_run_125 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok
      | MenhirState113 ->
          _menhir_run_124 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_125 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let (_endpos_e_, _startpos_e_, e) = (_endpos, _startpos, _v) in
      let _v = _menhir_action_28 e in
      _menhir_goto_expr_pair _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos_e_ _v _menhir_s _tok
  
  and _menhir_goto_expr_pair : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | COMMA ->
          let _menhir_stack = MenhirCell1_expr_pair (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
          let _menhir_s = MenhirState113 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SND ->
              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RIGHT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PACK ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LEFT ->
              _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FST ->
              _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ABSURD ->
              _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | BAR | BR_CLS | IN | OF | QED ->
          let (_endpos_e_, e) = (_endpos, _v) in
          let _v = _menhir_action_15 e in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_072 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_SND (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState072 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_074 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState074 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNPACK ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | SND ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RIGHT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PACK ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LEFT ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FST ->
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CASE ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ABSURD ->
          _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_066 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_UNPACK (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SBR_OPN ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell0_SBR_OPN (_menhir_stack, _startpos) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
              let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | SBR_CLS ->
                  let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
                  let _menhir_stack = MenhirCell0_SBR_CLS (_menhir_stack, _endpos) in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | IDENT _v ->
                      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
                      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
                      let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | FROM ->
                          let _menhir_s = MenhirState071 in
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | UNPACK ->
                              _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | SND ->
                              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | RIGHT ->
                              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | PACK ->
                              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | LET ->
                              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | LEFT ->
                              _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | IDENT _v ->
                              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                          | FUN ->
                              _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | FST ->
                              _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | CASE ->
                              _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | BR_OPN ->
                              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | ABSURD ->
                              _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_075 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_RIGHT (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState075 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_079 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_PACK (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SBR_OPN ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell0_SBR_OPN (_menhir_stack, _startpos) in
          let _menhir_s = MenhirState080 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BR_OPN ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_086 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LET (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQ ->
              let _menhir_s = MenhirState088 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | UNPACK ->
                  _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | SND ->
                  _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | RIGHT ->
                  _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | PACK ->
                  _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LET ->
                  _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | LEFT ->
                  _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FUN ->
                  _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | FST ->
                  _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | CASE ->
                  _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | BR_OPN ->
                  _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | ABSURD ->
                  _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_089 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_LEFT (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState089 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_093 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_FUN (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState093 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | SBR_OPN ->
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_094 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SBR_CLS ->
              let _endpos_1 = _menhir_lexbuf.Lexing.lex_curr_p in
              let _tok = _menhir_lexer _menhir_lexbuf in
              let (x, _startpos__1_, _endpos__3_) = (_v, _startpos, _endpos_1) in
              let _v = _menhir_action_35 _endpos__3_ _startpos__1_ x in
              _menhir_goto_fun_arg _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_fun_arg : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SBR_OPN ->
          let _menhir_stack = MenhirCell1_fun_arg (_menhir_stack, _menhir_s, _v) in
          _menhir_run_094 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState140
      | BR_OPN ->
          let _menhir_stack = MenhirCell1_fun_arg (_menhir_stack, _menhir_s, _v) in
          _menhir_run_097 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState140
      | ARR ->
          let x = _v in
          let _v = _menhir_action_57 x in
          _menhir_goto_nonempty_list_fun_arg_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_097 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _startpos) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
          let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _menhir_s = MenhirState099 in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NUM _v ->
                  _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | NOT ->
                  _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | IDENT _v ->
                  _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
              | FORALL ->
                  _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | FALSE ->
                  _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | EXISTS ->
                  _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | BR_OPN ->
                  _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_nonempty_list_fun_arg_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState140 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState093 ->
          _menhir_run_102 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_141 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_fun_arg -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_fun_arg (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_58 x xs in
      _menhir_goto_nonempty_list_fun_arg_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_102 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_FUN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_nonempty_list_fun_arg_ (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState103 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNPACK ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | SND ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RIGHT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PACK ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LEFT ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FST ->
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CASE ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ABSURD ->
          _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_104 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_FST (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState104 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_106 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_CASE (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState106 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | UNPACK ->
          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | SND ->
          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | RIGHT ->
          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | PACK ->
          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LET ->
          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LEFT ->
          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FUN ->
          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | FST ->
          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CASE ->
          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ABSURD ->
          _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_107 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
      let _menhir_stack = MenhirCell1_ABSURD (_menhir_stack, _menhir_s, _startpos) in
      let _menhir_s = MenhirState107 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | IDENT _v ->
          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BR_OPN ->
          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState065 ->
          _menhir_run_151 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState149 ->
          _menhir_run_150 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState071 ->
          _menhir_run_148 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState074 ->
          _menhir_run_145 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState143 ->
          _menhir_run_144 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState088 ->
          _menhir_run_142 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState103 ->
          _menhir_run_139 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState137 ->
          _menhir_run_138 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok
      | MenhirState132 ->
          _menhir_run_133 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | MenhirState106 ->
          _menhir_run_126 _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_151 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_THEOREM _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_formula -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | QED ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let (e, _endpos__3_) = (_v, _endpos_0) in
          let _v = _menhir_action_61 e in
          let _endpos = _endpos__3_ in
          let MenhirCell1_formula (_menhir_stack, _, f, _) = _menhir_stack in
          let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
          let MenhirCell1_THEOREM (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_p_, p) = (_endpos, _v) in
          let _v = _menhir_action_10 _endpos_p_ _startpos__1_ f p x in
          _menhir_goto_def _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_150 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_UNPACK _menhir_cell0_SBR_OPN _menhir_cell0_IDENT _menhir_cell0_SBR_CLS _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _, e1, _) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, y, _, _) = _menhir_stack in
      let MenhirCell0_SBR_CLS (_menhir_stack, _) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
      let MenhirCell0_SBR_OPN (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_UNPACK (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_14 _endpos_e2_ _startpos__1_ e1 e2 x y in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _v _menhir_s _tok
  
  and _menhir_run_148 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_UNPACK _menhir_cell0_SBR_OPN _menhir_cell0_IDENT _menhir_cell0_SBR_CLS _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | IN ->
          let _menhir_s = MenhirState149 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNPACK ->
              _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | SND ->
              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RIGHT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PACK ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LEFT ->
              _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FST ->
              _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CASE ->
              _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ABSURD ->
              _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_145 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | BR_CLS ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (e, _endpos__3_) = (_v, _endpos_0) in
          let _v = _menhir_action_30 _endpos__3_ _startpos__1_ e in
          _menhir_goto_expr_simple _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__3_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_144 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_LET _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _, e1, _) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
      let MenhirCell1_LET (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_11 _endpos_e2_ _startpos__1_ e1 e2 x in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _v _menhir_s _tok
  
  and _menhir_run_142 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_LET _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | IN ->
          let _menhir_s = MenhirState143 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNPACK ->
              _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | SND ->
              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RIGHT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PACK ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LEFT ->
              _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FST ->
              _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CASE ->
              _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ABSURD ->
              _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_139 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_FUN, _menhir_box_main) _menhir_cell1_nonempty_list_fun_arg_ -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_nonempty_list_fun_arg_ (_menhir_stack, _, args) = _menhir_stack in
      let MenhirCell1_FUN (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_body_, body) = (_endpos, _v) in
      let _v = _menhir_action_12 _endpos_body_ _startpos__1_ args body in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_body_ _v _menhir_s _tok
  
  and _menhir_run_138 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_CASE, _menhir_box_main) _menhir_cell1_expr _menhir_cell0_option_BAR_ _menhir_cell0_LEFT _menhir_cell0_IDENT, _menhir_box_main) _menhir_cell1_expr _menhir_cell0_RIGHT _menhir_cell0_IDENT -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_IDENT (_menhir_stack, y, _, _) = _menhir_stack in
      let MenhirCell0_RIGHT (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _, e1, _) = _menhir_stack in
      let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
      let MenhirCell0_LEFT (_menhir_stack, _) = _menhir_stack in
      let MenhirCell0_option_BAR_ (_menhir_stack, _) = _menhir_stack in
      let MenhirCell1_expr (_menhir_stack, _, e, _) = _menhir_stack in
      let MenhirCell1_CASE (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_13 _endpos_e2_ _startpos__1_ e e1 e2 x y in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _v _menhir_s _tok
  
  and _menhir_run_133 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_CASE, _menhir_box_main) _menhir_cell1_expr _menhir_cell0_option_BAR_ _menhir_cell0_LEFT _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | BAR ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | RIGHT ->
              let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
              let _menhir_stack = MenhirCell0_RIGHT (_menhir_stack, _startpos) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | IDENT _v ->
                  let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
                  let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
                  let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | ARR ->
                      let _menhir_s = MenhirState137 in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | UNPACK ->
                          _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | SND ->
                          _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | RIGHT ->
                          _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | PACK ->
                          _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | LET ->
                          _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | LEFT ->
                          _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | IDENT _v ->
                          _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                      | FUN ->
                          _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | FST ->
                          _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | CASE ->
                          _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | BR_OPN ->
                          _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | ABSURD ->
                          _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_126 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_CASE as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | OF ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | BAR ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = () in
              let _v = _menhir_action_60 x in
              _menhir_goto_option_BAR_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | LEFT ->
              let _v = _menhir_action_59 () in
              _menhir_goto_option_BAR_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_option_BAR_ : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_CASE, _menhir_box_main) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_option_BAR_ (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | LEFT ->
          let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
          let _menhir_stack = MenhirCell0_LEFT (_menhir_stack, _startpos) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              let _startpos = _menhir_lexbuf.Lexing.lex_start_p in
              let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
              let _menhir_stack = MenhirCell0_IDENT (_menhir_stack, _v, _startpos, _endpos) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | ARR ->
                  let _menhir_s = MenhirState132 in
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | UNPACK ->
                      _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | SND ->
                      _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | RIGHT ->
                      _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | PACK ->
                      _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | LET ->
                      _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | LEFT ->
                      _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | IDENT _v ->
                      _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
                  | FUN ->
                      _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | FST ->
                      _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | CASE ->
                      _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | BR_OPN ->
                      _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | ABSURD ->
                      _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_124 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_expr_pair -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_expr_pair (_menhir_stack, _menhir_s, e1, _startpos_e1_, _) = _menhir_stack in
      let (_endpos_e2_, e2) = (_endpos, _v) in
      let _v = _menhir_action_27 _endpos_e2_ _startpos_e1_ e1 e2 in
      _menhir_goto_expr_pair _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e2_ _startpos_e1_ _v _menhir_s _tok
  
  and _menhir_run_100 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BR_CLS ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell0_IDENT (_menhir_stack, x, _, _) = _menhir_stack in
          let MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (f, _endpos__5_) = (_v, _endpos_0) in
          let _v = _menhir_action_36 _endpos__5_ _startpos__1_ f x in
          _menhir_goto_fun_arg _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_092 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_LEFT, _menhir_box_main) _menhir_cell1_expr_simple as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | BR_CLS | COMMA | IN | OF | QED ->
          let MenhirCell1_expr_simple (_menhir_stack, _, e, _, _) = _menhir_stack in
          let MenhirCell1_LEFT (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_16 _endpos_f_ _startpos__1_ e f in
          _menhir_goto_expr_annot _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_085 : type  ttv_stack. ((((ttv_stack, _menhir_box_main) _menhir_cell1_PACK _menhir_cell0_SBR_OPN, _menhir_box_main) _menhir_cell1_term _menhir_cell0_SBR_CLS, _menhir_box_main) _menhir_cell1_expr_simple as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | BR_CLS | COMMA | IN | OF | QED ->
          let MenhirCell1_expr_simple (_menhir_stack, _, e, _, _) = _menhir_stack in
          let MenhirCell0_SBR_CLS (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_term (_menhir_stack, _, t, _) = _menhir_stack in
          let MenhirCell0_SBR_OPN (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_PACK (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_19 _endpos_f_ _startpos__1_ e f t in
          _menhir_goto_expr_annot _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_078 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_RIGHT, _menhir_box_main) _menhir_cell1_expr_simple as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BAR | BR_CLS | COMMA | IN | OF | QED ->
          let MenhirCell1_expr_simple (_menhir_stack, _, e, _, _) = _menhir_stack in
          let MenhirCell1_RIGHT (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_17 _endpos_f_ _startpos__1_ e f in
          _menhir_goto_expr_annot _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _startpos__1_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_064 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_THEOREM _menhir_cell0_IDENT as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | PROOF ->
          let _menhir_s = MenhirState065 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | UNPACK ->
              _menhir_run_066 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | SND ->
              _menhir_run_072 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | RIGHT ->
              _menhir_run_075 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | PACK ->
              _menhir_run_079 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LET ->
              _menhir_run_086 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | LEFT ->
              _menhir_run_089 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FUN ->
              _menhir_run_093 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FST ->
              _menhir_run_104 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | CASE ->
              _menhir_run_106 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | ABSURD ->
              _menhir_run_107 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | OR ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_NOT -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_NOT (_menhir_stack, _menhir_s) = _menhir_stack in
      let (_endpos_f_, f) = (_endpos, _v) in
      let _v = _menhir_action_50 f in
      _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _v _menhir_s _tok
  
  and _menhir_run_060 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_FORALL, _menhir_box_main) _menhir_cell1_nonempty_list_forall_arg_ as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | IN | OF | PROOF | QED | THEOREM ->
          let MenhirCell1_nonempty_list_forall_arg_ (_menhir_stack, _, args) = _menhir_stack in
          let MenhirCell1_FORALL (_menhir_stack, _menhir_s) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_44 args f in
          _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_059 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_EXISTS, _menhir_box_main) _menhir_cell1_nonempty_list_IDENT_ as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | IN | OF | PROOF | QED | THEOREM ->
          let MenhirCell1_nonempty_list_IDENT_ (_menhir_stack, _, args) = _menhir_stack in
          let MenhirCell1_EXISTS (_menhir_stack, _menhir_s) = _menhir_stack in
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_45 args f in
          _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_058 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_formula as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | IN | OF | PROOF | QED | THEOREM ->
          let MenhirCell1_formula (_menhir_stack, _menhir_s, f1, _) = _menhir_stack in
          let (_endpos_f2_, f2) = (_endpos, _v) in
          let _v = _menhir_action_46 f1 f2 in
          _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f2_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_056 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_formula -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_formula (_menhir_stack, _menhir_s, f1, _) = _menhir_stack in
      let (_endpos_f2_, f2) = (_endpos, _v) in
      let _v = _menhir_action_48 f1 f2 in
      _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f2_ _v _menhir_s _tok
  
  and _menhir_run_054 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_formula as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | AND ->
          let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | IN | OF | OR | PROOF | QED | THEOREM ->
          let MenhirCell1_formula (_menhir_stack, _menhir_s, f1, _) = _menhir_stack in
          let (_endpos_f2_, f2) = (_endpos, _v) in
          let _v = _menhir_action_47 f1 f2 in
          _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f2_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_050 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_formula (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | OR ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer
      | ARR ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_048 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | BR_CLS ->
          let _endpos_0 = _menhir_lexbuf.Lexing.lex_curr_p in
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _) = _menhir_stack in
          let (_endpos__3_, f) = (_endpos_0, _v) in
          let _v = _menhir_action_52 f in
          _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__3_ _v _menhir_s _tok
      | AND | ARR | OR ->
          let (_endpos_f_, f) = (_endpos, _v) in
          let _v = _menhir_action_34 f in
          _menhir_goto_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_f_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_105 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_FST -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell1_FST (_menhir_stack, _menhir_s, _startpos__1_) = _menhir_stack in
      let (_endpos_e_, e) = (_endpos, _v) in
      let _v = _menhir_action_24 _endpos_e_ _startpos__1_ e in
      _menhir_goto_expr_app _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_e_ _startpos__1_ _v _menhir_s _tok
  
  and _menhir_run_090 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_LEFT as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr_simple (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState091 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | NOT ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FORALL ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FALSE ->
              _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EXISTS ->
              _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_083 : type  ttv_stack. (((ttv_stack, _menhir_box_main) _menhir_cell1_PACK _menhir_cell0_SBR_OPN, _menhir_box_main) _menhir_cell1_term _menhir_cell0_SBR_CLS as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr_simple (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState084 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | NOT ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FORALL ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FALSE ->
              _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EXISTS ->
              _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_076 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_RIGHT as 'stack) -> _ -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _startpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr_simple (_menhir_stack, _menhir_s, _v, _startpos, _endpos) in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _menhir_s = MenhirState077 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | NOT ->
              _menhir_run_005 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | FORALL ->
              _menhir_run_025 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | FALSE ->
              _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | EXISTS ->
              _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | BR_OPN ->
              _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_011 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_01 () in
      _menhir_goto_add_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_goto_add_op : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_add_op (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | NUM _v_0 ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState017
      | IDENT _v_1 ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState017
      | BR_OPN ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState017
      | _ ->
          _eRR ()
  
  and _menhir_run_012 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_02 () in
      _menhir_goto_add_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_013 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_43 () in
      _menhir_goto_mult_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_081 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_PACK _menhir_cell0_SBR_OPN as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | SBR_CLS ->
          let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
          let _menhir_stack = MenhirCell0_SBR_CLS (_menhir_stack, _endpos) in
          let _menhir_s = MenhirState082 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | IDENT _v ->
              _menhir_run_073 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BR_OPN ->
              _menhir_run_074 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | PLUS ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_052 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | NEQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GEQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND | ARR | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | IN | OF | OR | PROOF | QED | THEOREM ->
          let (_endpos_t_, t) = (_endpos, _v) in
          let _v = _menhir_action_33 t in
          _menhir_goto_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_040 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_04 () in
      _menhir_goto_cmp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_goto_cmp_op : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let _menhir_stack = MenhirCell0_cmp_op (_menhir_stack, _v) in
      match (_tok : MenhirBasics.token) with
      | NUM _v_0 ->
          _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState046
      | IDENT _v_1 ->
          _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState046
      | BR_OPN ->
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState046
      | _ ->
          _eRR ()
  
  and _menhir_run_041 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_05 () in
      _menhir_goto_cmp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_042 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_07 () in
      _menhir_goto_cmp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_043 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_06 () in
      _menhir_goto_cmp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_044 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_08 () in
      _menhir_goto_cmp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_045 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _v = _menhir_action_03 () in
      _menhir_goto_cmp_op _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_047 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_term _menhir_cell0_cmp_op as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND | ARR | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | IN | OF | OR | PROOF | QED | THEOREM ->
          let MenhirCell0_cmp_op (_menhir_stack, op) = _menhir_stack in
          let MenhirCell1_term (_menhir_stack, _menhir_s, t1, _) = _menhir_stack in
          let (_endpos_t2_, t2) = (_endpos, _v) in
          let _v = _menhir_action_49 op t1 t2 in
          _menhir_goto_non_term_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t2_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_039 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | NEQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GEQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BR_CLS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND | ARR | OR ->
          let (_endpos_t_, t) = (_endpos, _v) in
          let _v = _menhir_action_33 t in
          _menhir_goto_formula _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_014 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _endpos = _menhir_lexbuf.Lexing.lex_curr_p in
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_term (_menhir_stack, _, t, _) = _menhir_stack in
      let MenhirCell1_BR_OPN (_menhir_stack, _menhir_s, _) = _menhir_stack in
      let _endpos__3_ = _endpos in
      let _v = _menhir_action_64 t in
      _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _endpos__3_ _v _menhir_s _tok
  
  and _menhir_run_019 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          let _menhir_s = MenhirState020 in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUM _v ->
              _menhir_run_004 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | IDENT _v ->
              _menhir_run_006 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
          | BR_OPN ->
              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
          | _ ->
              _eRR ())
      | BR_CLS ->
          let x = _v in
          let _v = _menhir_action_62 x in
          _menhir_goto_separated_nonempty_list_COMMA_term_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_separated_nonempty_list_COMMA_term_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_main) _menhir_state -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState007 ->
          _menhir_run_022 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState020 ->
          _menhir_run_021 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_022 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_IDENT _menhir_cell0_BR_OPN -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let x = _v in
      let _v = _menhir_action_40 x in
      _menhir_goto_loption_separated_nonempty_list_COMMA_term__ _menhir_stack _menhir_lexbuf _menhir_lexer _v
  
  and _menhir_run_021 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_term (_menhir_stack, _menhir_s, x, _) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_63 x xs in
      _menhir_goto_separated_nonempty_list_COMMA_term_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_018 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_term _menhir_cell0_add_op as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND | ARR | AXIOM | BAR | BR_CLS | CBR_CLS | COMMA | EOF | EQ | GEQ | GT | IN | LEQ | LT | MINUS | NEQ | OF | OR | PLUS | PROOF | QED | SBR_CLS | THEOREM ->
          let MenhirCell0_add_op (_menhir_stack, op) = _menhir_stack in
          let MenhirCell1_term (_menhir_stack, _menhir_s, t1, _) = _menhir_stack in
          let (_endpos_t2_, t2) = (_endpos, _v) in
          let _v = _menhir_action_66 op t1 t2 in
          _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t2_ _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_016 : type  ttv_stack. (ttv_stack, _menhir_box_main) _menhir_cell1_term _menhir_cell0_mult_op -> _ -> _ -> _ -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _tok ->
      let MenhirCell0_mult_op (_menhir_stack, op) = _menhir_stack in
      let MenhirCell1_term (_menhir_stack, _menhir_s, t1, _) = _menhir_stack in
      let (_endpos_t2_, t2) = (_endpos, _v) in
      let _v = _menhir_action_67 op t1 t2 in
      _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _endpos_t2_ _v _menhir_s _tok
  
  and _menhir_run_009 : type  ttv_stack. ((ttv_stack, _menhir_box_main) _menhir_cell1_BR_OPN as 'stack) -> _ -> _ -> _ -> _ -> ('stack, _menhir_box_main) _menhir_state -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _endpos _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_term (_menhir_stack, _menhir_s, _v, _endpos) in
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          _menhir_run_010 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          _menhir_run_011 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_012 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIV ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BR_CLS ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_main =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | THEOREM ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | AXIOM ->
          _menhir_run_154 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState000
      | EOF ->
          let _v = _menhir_action_37 () in
          _menhir_run_159 _menhir_stack _v
      | _ ->
          _eRR ()
  
end

let main =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_main v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
