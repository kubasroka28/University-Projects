%{
open Ast
%}

%token <bool> BOOL
%token <int> INT
%token <string> IDENT
%token IF
%token ELSE
%token WHILE
%token SKIP
%token LBRACE
%token RBRACE
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token AND
%token OR
%token LEQ
%token LT
%token GEQ
%token GT
%token EQ
%token NEQ
%token LPAREN
%token RPAREN
%token COLON
%token ASSIGN
%token PRINT
%token EOF

%start <Ast.prog> main

%left AND OR
%nonassoc EQ NEQ LEQ LT GT GEQ
%left PLUS MINUS
%left TIMES DIV

%%

main:
  | e = stmts; EOF { e }
  ;

stmts:
  | s = stmt; ss = stmts; { s :: ss }
  | s = stmt { [s] }

stmt:
  | SKIP; COLON { Skip }
  | x = IDENT; ASSIGN; e = expr; COLON { Assign (x, e) }
  | LBRACE; ss = stmts; RBRACE { Block ss }
  | LBRACE; RBRACE { Block [] }
  | IF; LPAREN; e = expr; RPAREN; th = stmt; ELSE; el = stmt { If (e, th, el) }
  | IF; LPAREN; e = expr; RPAREN; th = stmt { If (e, th, Skip) }
  | WHILE; LPAREN; e = expr; RPAREN; b = stmt { While (e, b) }
  | PRINT; LPAREN; e = expr; RPAREN; COLON { Print e }
  ;

expr:
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; AND; e2 = expr { Binop(And, e1, e2) }
    | e1 = expr; OR; e2 = expr { Binop(Or, e1, e2) }
    | e1 = expr; EQ; e2 = expr { Binop(Eq, e1, e2) }
    | e1 = expr; NEQ; e2 = expr { Binop(Neq, e1, e2) }
    | e1 = expr; LEQ; e2 = expr { Binop(Leq, e1, e2) }
    | e1 = expr; LT; e2 = expr { Binop(Lt, e1, e2) }
    | e1 = expr; GT; e2 = expr { Binop(Gt, e1, e2) }
    | e1 = expr; GEQ; e2 = expr { Binop(Geq, e1, e2) }
    | e = base_expr { e }

base_expr:
    | x = IDENT { Var x }
    | i = INT { Int i }
    | b = BOOL { Bool b }
    | LPAREN; e = expr; RPAREN { e }
    ;
