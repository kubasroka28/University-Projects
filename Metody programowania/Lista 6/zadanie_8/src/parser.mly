%{
open Ast
%}

%token TOP
%token BOT
%token <string> IDENT
%token DISJ
%token CONJ
%token NOT
%token FORALL
%token EXISTS
%token LPAREN
%token RPAREN
%token EOF

%start <Ast.qbf> main

%right FORALL EXISTS
%left CONJ DISJ
%right NOT

%%

main:
    | f = qbf; EOF { f }
    ;

qbf:
    | TOP { Top }
    | BOT { Bot }    
    | x = IDENT { Var x}
    | phi = qbf; DISJ; psi = qbf { Disj(phi, psi) }
    | phi = qbf; CONJ; psi = qbf { Conj(phi, psi) }
    | NOT; phi = qbf { Not phi }
    | FORALL; x = IDENT; phi = qbf { Forall(x, phi) }
    | EXISTS; x = IDENT; phi = qbf { Exists(x, phi) }
    | LPAREN; phi = qbf; RPAREN { phi }
    ;