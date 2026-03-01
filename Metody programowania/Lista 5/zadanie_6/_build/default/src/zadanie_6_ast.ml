type bop = Add | Sub | Mult | Div | Pow
type uop = Log

type expr = 
    | Float of float
    | Binop of bop * expr * expr
    | Unop of uop * expr
