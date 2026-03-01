%{
open RawAst

let node pos data =
  { data; pos }

%}

%token <bool> BOOL
%token <int> INT
%token <string> IDENT
%token IF THEN ELSE
%token LET IN
%token PLUS MINUS TIMES DIV AND OR LEQ LT GEQ GT EQ NEQ
%token LPAREN RPAREN
%token UNIT FST SND ARR FUN FUNREC
%token KW_INT KW_BOOL KW_UNIT
%token COMMA COLON
%token EOF
%start <RawAst.expr> main

%right ARR
%left AND OR
%nonassoc EQ NEQ LEQ LT GT GEQ
%left PLUS MINUS
%left TIMES DIV

%%

main:
    | e = mexpr; EOF { e }
    ;

type_expr:
    | tp = type_simpl { tp }
    | tp1 = type_expr; ARR; tp2 = type_expr
      { TArrow(tp1, tp2) }
    | tp1 = type_expr; TIMES; tp2 = type_expr
      { TPair(tp1, tp2) }
    ;

type_simpl:
    | KW_INT  { TInt  }
    | KW_BOOL { TBool }
    | KW_UNIT { TUnit }
    | LPAREN; tp = type_expr; RPAREN { tp }
;

mexpr:
    | IF; e1 = mexpr; THEN; e2 = mexpr; ELSE; e3 = mexpr
        { node $loc (If(e1, e2, e3)) }
    | LET; x = IDENT; EQ; e1 = mexpr; IN; e2 = mexpr
        { node $loc (Let(x, e1, e2)) }
    | FUN;
      LPAREN; x = IDENT; COLON; tp = type_expr; RPAREN;
      ARR; e = mexpr
        { node $loc (Fun(x, tp, e)) }
    (*| FUNREC; f = IDENT;
      LPAREN; x = IDENT; COLON; tp1 = type_expr; RPAREN;
      COLON; tp2 = type_simpl; ARR; e = mexpr
        { node $loc (Funrec(f, x, tp1, tp2, e)) }
    | FUNREC; f = IDENT;
      LPAREN; x = IDENT; COLON; tp1 = type_expr; RPAREN;
      LPAREN; y = IDENT; COLON; tp2 = type_expr; RPAREN;
      COLON; tp3 = type_simpl; ARR; e = mexpr
        (*{ node $loc (Funrec(f, x, tp1, tp2, e)) }
      FUNREC; f = IDENT;
      LPAREN; x = IDENT; COLON; tp1 = type_expr; RPAREN;
      COLON; tp' = tp2 -> tp3; ARR;
      FUN;
      LPAREN; y = IDENT; COLON; tp'' = tp2; RPAREN;
      ARR; e = mexpr*)
        { node $loc (Funrec(f, x, tp1, TArrow(tp2, tp3), node $loc (Fun(y, tp2, e)))) }
    | FUNREC; f = IDENT;
      LPAREN; x = IDENT; COLON; tp1 = type_expr; RPAREN;
      LPAREN; y = IDENT; COLON; tp2 = type_expr; RPAREN;
      LPAREN; z = IDENT; COLON; tp3 = type_expr; RPAREN;
      COLON; end_tp = type_simpl; ARR; e = mexpr
        { node $loc (Funrec(f, x, tp1, TArrow(tp2, TArrow(tp3, end_tp)), node $loc (Fun(y, tp2, node $loc (Fun(z, tp3, e)))))) }*)

    | FUNREC; f = IDENT;
      args = args;
      COLON; end_tp = type_simpl; ARR; e = mexpr
    {
      (* Zbuduj typ i ciało funkcji *)
      let (x1, tp1, rest) = 
        match args with
        | (x, tp) :: rest -> (x, tp, rest)
        | _ -> failwith "no arguments" in
      let output_type = List.fold_right (fun (_, tp) acc -> TArrow(tp, acc)) rest end_tp in 
      let fun_body = List.fold_right (fun (x, tp) acc -> node $loc (Fun(x, tp, acc))) rest e in
      node $loc (Funrec(f, x1, tp1, output_type, node $loc fun_body.data))
    }

    | e = expr
      { e }
    ;

args:
    | { [] }
    | LPAREN; x = IDENT; COLON; tp = type_expr; RPAREN; rest = args
      { (x, tp) :: rest }

(*arg:
    | LPAREN; x = IDENT; COLON; tp = type_expr; RPAREN; a = arg { node $loc }
    | LPAREN; x = IDENT; COLON; tp = type_expr; RPAREN;
      COLON; end_tp = type_simpl; ARR; e = mexpr { node $loc (Funrec(f, x, tp1, tp2, e)) }*)


expr:
    | e1 = expr; PLUS; e2 = expr
      { node $loc (Binop(Add, e1, e2)) }
    | e1 = expr; MINUS; e2 = expr
      { node $loc (Binop(Sub, e1, e2)) }
    | e1 = expr; DIV; e2 = expr
      { node $loc (Binop(Div, e1, e2)) }
    | e1 = expr; TIMES; e2 = expr
      { node $loc (Binop(Mult, e1, e2)) }
    | e1 = expr; AND; e2 = expr
      { node $loc (Binop(And, e1, e2)) }
    | e1 = expr; OR; e2 = expr
      { node $loc (Binop(Or, e1, e2)) }
    | e1 = expr; EQ; e2 = expr
      { node $loc (Binop(Eq, e1, e2)) }
    | e1 = expr; NEQ; e2 = expr
      { node $loc (Binop(Neq, e1, e2)) }
    | e1 = expr; LEQ; e2 = expr
      { node $loc (Binop(Leq, e1, e2)) }
    | e1 = expr; LT; e2 = expr
      { node $loc (Binop(Lt, e1, e2)) }
    | e1 = expr; GT; e2 = expr
      { node $loc (Binop(Gt, e1, e2)) }
    | e1 = expr; GEQ; e2 = expr
      { node $loc (Binop(Geq, e1, e2)) }
    | e = app_expr { e }

app_expr:
    | FST; e = base_expr { node $loc (Fst e) }
    | SND; e = base_expr { node $loc (Snd e) }
    | e1 = app_expr; e2 = base_expr
      { node $loc (App (e1, e2)) }
    | e = base_expr { e }
    ;

base_expr:
    | x = IDENT { node $loc (Var x) }
    | i = INT { node $loc (Int i) }
    | b = BOOL { node $loc (Bool b) }
    | UNIT { node $loc Unit }
    | LPAREN; e1 = mexpr; COMMA; e2 = mexpr; RPAREN {
      node $loc (Pair (e1,e2)) }
    | LPAREN; e = mexpr; RPAREN
      { node $loc (e.data) }
    ;
