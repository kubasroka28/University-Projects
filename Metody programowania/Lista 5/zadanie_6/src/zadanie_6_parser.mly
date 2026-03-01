%token <float> FLOAT
%token PLUS
%token MINUS
%token TIMES
%token DIV
%token POWER
%token LOG
%token LPAREN
%token RPAREN
%token EOF

%start <Zadanie_6_ast.expr> main

%left PLUS MINUS
%left TIMES DIV
%right POWER
%right LOG

%%

main:
    | e = expr; EOF { e }
    ;

expr:
    | f = FLOAT { Float f }
    | e1 = expr; PLUS; e2 = expr { Binop(Add, e1, e2) }
    | e1 = expr; MINUS; e2 = expr { Binop(Sub, e1, e2) }
    | e1 = expr; DIV; e2 = expr { Binop(Div, e1, e2) }
    | e1 = expr; TIMES; e2 = expr { Binop(Mult, e1, e2) }
    | e1 = expr; POWER; e2 = expr { Binop(Pow, e1, e2) }
    | LOG; e = expr { Unop(Log, e) }
    | LPAREN; e = expr; RPAREN { e }
    ;


