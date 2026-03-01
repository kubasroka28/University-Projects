type bop = Add | Sub | Mult | Div | And | Or | Eq | Leq

type expr = 
    | Int of int
    | Bool of bool
    | Binop of bop * expr * expr
