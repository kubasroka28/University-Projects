%{
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

%}

%token <string> IDENT
%token <int> NUM
%token BR_OPN BR_CLS SBR_OPN SBR_CLS CBR_OPN CBR_CLS
%token EQ NEQ LT GT LEQ GEQ PLUS MINUS TIMES DIV ARR BAR COLON COMMA
%token ABSURD AND AXIOM CASE EXISTS FALSE FORALL FROM FST FUN IN LEFT LET NOT
%token OF OR PACK PROOF QED RIGHT SND THEOREM UNPACK
%token EOF

%start <Syntax.def list> main

%right COMMA ARR
%left OR
%left AND
%right NOT
%left PLUS MINUS
%left TIMES DIV

%%

main:
| e = list(def); EOF { e }
;

def:
| AXIOM;   x = IDENT; COLON; f = formula            { Axiom($loc, x, f) }
| THEOREM; x = IDENT; COLON; f = formula; p = proof { Theorem($loc, x, f, p) }
;

/* ========================================================================= */

term:
| BR_OPN; t = term; BR_CLS { t }
| op = IDENT; BR_OPN; args = separated_list(COMMA, term); BR_CLS
    { Func(op, args) }
| t1 = term; op = add_op;  t2 = term %prec PLUS  { Func(op, [t1; t2]) }
| t1 = term; op = mult_op; t2 = term %prec TIMES { Func(op, [t1; t2]) }
| x = IDENT { Var x }
| n = NUM   { mk_num n }
;

cmp_op:
| EQ  { "="  }
| NEQ { "<>" }
| LT  { "<"  }
| GT  { ">"  }
| LEQ { "<=" }
| GEQ { ">=" }
;

add_op:
| PLUS  { "+" }
| MINUS { "-" }
;

mult_op:
| TIMES { "*" }
| DIV   { "/" }
;

/* ========================================================================= */

formula:
| t = term { formula_of_term t }
| f = non_term_formula { f }
;

non_term_formula:
| FORALL; args = nonempty_list(forall_arg); COMMA; f = formula
    { mk_forall args f }
| EXISTS; args = nonempty_list(IDENT); COMMA; f = formula
    { mk_exists args f }
| f1 = formula; ARR; f2 = formula { Imp(f1, f2) }
| f1 = formula; OR;  f2 = formula { Or(f1, f2)  }
| f1 = formula; AND; f2 = formula { And(f1, f2) }
| t1 = term; op = cmp_op; t2 = term { Rel(op, [t1; t2]) }
| NOT; f = formula { mk_not f }
| FALSE { False }
| BR_OPN; f = non_term_formula; BR_CLS { f }
;

forall_arg:
| x = IDENT                   { Either.Left x  }
| CBR_OPN; x = IDENT; CBR_CLS { Either.Right x }
;

/* ========================================================================= */

proof:
| PROOF; e = expr; QED { e }
;

/* ========================================================================= */

expr:
| LET; x = IDENT; EQ; e1 = expr; IN; e2 = expr
    { node $loc (ELet(x, e1, e2)) }
| FUN; args = nonempty_list(fun_arg); ARR; body = expr
    { mk_fun ~pos:($loc) args body }
| CASE; e = expr; OF; option(BAR);
         LEFT;  x = IDENT; ARR; e1 = expr;
    BAR; RIGHT; y = IDENT; ARR; e2 = expr
    { node $loc (ECase(e, x, e1, y, e2)) }
| UNPACK; SBR_OPN; x = IDENT; SBR_CLS; y = IDENT;
      FROM; e1 = expr; IN; e2 = expr
    { node $loc (EUnpack(x, y, e1, e2)) }
| e = expr_pair { e }
;

expr_pair:
| e1 = expr_pair; COMMA; e2 = expr_annot
    { node $loc (EPair(e1, e2)) }
| e = expr_annot { e }
;

expr_annot:
| LEFT; e = expr_simple; COLON; f = formula
    { node $loc (ELeft(e, f)) }
| RIGHT; e = expr_simple; COLON; f = formula
    { node $loc (ERight(e, f)) }
| ABSURD; e = expr_simple; COLON; f = formula
    { node $loc (EAbsurd(e, f)) }
| PACK; SBR_OPN; t = term; SBR_CLS; e = expr_simple; COLON; f = formula
    { node $loc (EPack(t, e, f)) }
| e = expr_app { e }
;

expr_app:
| e1 = expr_app; e2 = expr_simple
    { node $loc (EApp(e1, e2)) }
| e1 = expr_app; SBR_OPN; t = term; SBR_CLS
    { node $loc (ETermApp(e1, t)) }
| e1 = expr_app; CBR_OPN; x = IDENT; BAR; f = formula; CBR_CLS
    { node $loc (ERelApp(e1, x, f)) }
| FST; e = expr_simple
    { node $loc (EFst e) }
| SND; e = expr_simple
    { node $loc (ESnd e) }
| e = expr_simple { e }
;

expr_simple:
| x = IDENT
    { node $loc (EVar x) }
| BR_OPN; e = expr; BR_CLS
    { node $loc e.data }
;

fun_arg
: SBR_OPN; x = IDENT; SBR_CLS { ($loc, Either.Left x) }
| BR_OPN; x = IDENT; COLON; f = formula; BR_CLS { ($loc, Either.Right(x, f)) }
;
