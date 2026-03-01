type bop =
  (* arithmetic *)
  | Add | Sub | Mult | Div
  (* logic *)
  | And | Or
  (* comparison *)
  | Eq | Neq | Leq | Lt | Geq | Gt

type ident = string

type expr =
  | Int    of int
  | Binop  of bop * expr * expr
  | Bool   of bool
  | If     of expr * expr * expr
  | Let    of ident * expr * expr
  | Var    of ident
  | Cell   of int * int
  | Unit
  | Pair   of expr * expr
  | Fst    of expr
  | Snd    of expr
  | Match  of expr * ident * ident * expr
  | IsPair of expr
  | Fun    of ident * expr
  | Funrec of ident * ident * expr
  | App    of expr * expr

type env = value Map.Make(String).t

and value =
  | VInt of int
  | VBool of bool
  | VUnit
  | VPair of value * value
  | VClosure of ident * expr * env
  | VRecClosure of ident * ident * expr * env

(*adding an exception*)
exception UncalculatedCell

(*auxiliary function*)
let cell_name_of_cords x y =
  "r" ^ string_of_int x ^ "c" ^ string_of_int y

module M = Map.Make(String)

let eval_op (op : bop) (val1 : value) (val2 : value) : value =
  match op, val1, val2 with
  | Add,  VInt  v1, VInt  v2 -> VInt  (v1 + v2)
  | Sub,  VInt  v1, VInt  v2 -> VInt  (v1 - v2)
  | Mult, VInt  v1, VInt  v2 -> VInt  (v1 * v2)
  | Div,  VInt  v1, VInt  v2 -> VInt  (v1 / v2)
  | And,  VBool v1, VBool v2 -> VBool (v1 && v2)
  | Or,   VBool v1, VBool v2 -> VBool (v1 || v2)
  | Leq,  VInt  v1, VInt  v2 -> VBool (v1 <= v2)
  | Lt,   VInt  v1, VInt  v2 -> VBool (v1 < v2)
  | Gt,   VInt  v1, VInt  v2 -> VBool (v1 > v2)
  | Geq,  VInt  v1, VInt  v2 -> VBool (v1 >= v2)
  | Neq,  _,        _        -> VBool (val1 <> val2)
  | Eq,   _,        _        -> VBool (val1 = val2)
  | _,    _,        _        -> failwith "type error"

let rec eval_env (env : env) ((*new argument - spreadsheet values map*) sp_vals : env) (e : expr) : value =
  match e with
  | Int i -> VInt i
  | Bool b -> VBool b
  | Binop (op, e1, e2) ->
      eval_op op (eval_env env sp_vals e1) (eval_env env sp_vals e2)
  | If (b, t, e) ->
      (match eval_env env sp_vals b with
        | VBool true -> eval_env env sp_vals t
        | VBool false -> eval_env env sp_vals e
        | _ -> failwith "type error")
  | Var x ->
     (match M.find_opt x env with
       | Some v -> v
       | None -> failwith "unknown var")
  | Let (x, e1, e2) ->
      eval_env (M.add x (eval_env env sp_vals e1) env) sp_vals e2
  | Pair (e1, e2) -> VPair (eval_env env sp_vals e1, eval_env env sp_vals e2)
  | Unit -> VUnit
  | Fst e ->
      (match eval_env env sp_vals e with
        | VPair (v1, _) -> v1
        | _ -> failwith "Type error")
  | Snd e ->
      (match eval_env env sp_vals e with
        | VPair (_, v2) -> v2
        | _ -> failwith "Type error")
  | Match (_e1, _x, _y, _e2) ->
      failwith "Not implemented"
  | IsPair e ->
      (match eval_env env sp_vals e with
        | VPair _ -> VBool true
        | _ -> VBool false)
  | Fun (x, e) -> VClosure (x, e, env)
  | Funrec (f, x, e) -> VRecClosure (f, x, e, env)
  | App (e1, e2) ->
      let v1 = eval_env env sp_vals e1 in
      let v2 = eval_env env sp_vals e2 in
      (match v1 with
        | VClosure (x, body, clo_env) ->
            eval_env (M.add x v2 clo_env) sp_vals body
        | VRecClosure (f, x, body, clo_env) as c ->
            eval_env (clo_env |> M.add x v2 |> M.add f c) sp_vals body
        | _ -> failwith "not a function")
  (*handling the new expression case*)
  (*If the cell has been calculeted then I return its value from the map and otherwise I raise an exception*)
  | Cell (r, c) ->
      (match M.find_opt (cell_name_of_cords r c) sp_vals with
      | Some v -> v
      | None -> raise UncalculatedCell
      )

(*auxiliary function*)
let eval_cell (c : expr) (map : env) : value option =
    try Some (eval_env M.empty map c) with
    | UncalculatedCell -> None

(*This function adds evaluated values from a single row to the map*)    
let rec values_map_of_row (s : expr list) (map : env) (row : int) (col : int) : env =
    match s with
    | [] -> map
    | h :: t -> 
      let cell_name = cell_name_of_cords row col in
      let new_map = 
        begin match M.find_opt cell_name map with
        | Some _ -> map (*The cell has been already calculated*)
        | None ->
          begin match eval_cell h map with
          | Some v -> M.add cell_name v map (*Calculating the cell value was possible so we add it to the map*)
          | None -> map (*Calculating the cell is still not possible*)
          end
        end in
      values_map_of_row t new_map row (col + 1)

(*This function adds evaluated values from the whole spreadsheet to the map*)   
let rec values_map_of_spreadsheet (s : expr list list) (map : env) (row : int) : env =
    match s with
    | [] -> map
    | h :: t -> 
        let new_map = values_map_of_row h map row 0 in
        values_map_of_spreadsheet t new_map (row + 1)

(*This function goes throught the spreadsheet n times where n is the number of cells. This allows to evaluate all cells despite dependencies.*)
let iterator (s : expr list list) (h : int) (w : int) : env =
  let map = M.empty in
  let rec it (n : int) (map : env) =
    match n with
    | 0 -> map
    | _ -> it (n - 1) (values_map_of_spreadsheet s map 0)
  in it (h * w) map

(*This function takes the values map and creates a value list list*)
let value_list_list_of_map (map : env) (h : int) (w : int) : value list list =
  let get_cell_value r c = 
    M.find (cell_name_of_cords r c) map in
  let get_row r = List.init w (get_cell_value r) in
  List.init h get_row

let eval_spreadsheet (s : expr list list) : value list list option =
  let sp_height = List.length s in
  let sp_width =
    begin match s with
     [] -> 0
    | h :: _ -> List.length h
    end in
  let map_with_evaluated_values = iterator s sp_height sp_width in
  (*If not all of the cells are calculated then there is a cycle*)
  if M.cardinal map_with_evaluated_values = sp_height * sp_width
    then Some (value_list_list_of_map map_with_evaluated_values sp_height sp_width)
    else None
