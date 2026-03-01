open Zadanie_6_ast

let parse (s : string) : expr =  
    Zadanie_6_parser.main Zadanie_6_lexer.read (Lexing.from_string s)

let eval_binop (op : bop) (v1 : float) (v2 : float) : float =
    match op with
    | Add -> v1 +. v2
    | Sub -> v1 -. v2
    | Mult -> v1 *. v2
    | Div -> v1 /. v2
    | Pow -> v1 ** v2

let eval_unop (op : uop) (v : float) =
    match op with
    | Log -> log v

let rec eval (e : expr) : float =
    match e with
    | Float f -> f
    | Binop (op, e1, e2) -> eval_binop op (eval e1) (eval e2)
    | Unop (op, e) -> eval_unop op (eval e)

let interp (s : string) : float =
    eval (parse s)

 