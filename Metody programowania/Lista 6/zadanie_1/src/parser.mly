%{
open Ast
%}

%token <bool> BOOL
%token <int> INT
%token <string> IDENT
%token IF
%token THEN
%token ELSE
%token LET
%token IN
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token AND
%token OR
%token EQ
%token LEQ
%token LPAREN
%token RPAREN
%token UNIT (* Zadanie 3 *)
%token COMMA (* Zadanie 4 *)
%token FST (* Zadanie 4 *)
%token SND (* Zadanie 4 *)
%token EOF

%start <Ast.expr> main

%left AND OR
%nonassoc EQ LEQ
%left PLUS MINUS
%left TIMES DIV
%right FST SND (* Zadanie 4 *)

%%

main:
    | e = mexpr; EOF { e }
    ;

mexpr:
    | IF; e1 = mexpr; THEN; e2 = mexpr; ELSE; e3 = mexpr { If(e1,e2,e3) }
    | LET; x = IDENT; EQ; e1 = mexpr; IN; e2 = mexpr { Let(x,e1,e2) }
    | e = expr { e }
    ;

expr:
    | i = INT { Int i }
    | b = BOOL { Bool b }
    | x = IDENT { Var x }
    | u = UNIT { Unit u } (* Zadanie 3 *)
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; AND; e2 = expr { Binop(And, e1, e2) }
    | e1 = expr; OR; e2 = expr { Binop(Or, e1, e2) }
    | e1 = expr; EQ; e2 = expr { Binop(Eq, e1, e2) }
    | e1 = expr; LEQ; e2 = expr { Binop(Leq, e1, e2) }
    | LPAREN; e = mexpr; RPAREN { e }
    | LPAREN; e1 = expr; COMMA; e2 = expr; RPAREN { Pair(e1, e2) } (* Zadanie 4 *)
    | FST; p = expr { Fst p } (* Zadanie 4 *)
    | SND; p = expr { Snd p } (* Zadanie 4 *)
    ;


