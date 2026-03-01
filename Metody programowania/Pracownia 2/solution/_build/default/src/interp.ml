(* Added or modified elements of the code will be signalized by a simple (**) sign for clarity *)

open Ast

(**)
exception UncalculatedCell

(**)
let cords_to_cell_name x y =
  "r" ^ string_of_int x ^ "c" ^ string_of_int y

let parse (s : string) : expr =
  Parser.main Lexer.read (Lexing.from_string s)

module M = Map.Make(String)

type env = value M.t

and value =
  | VInt of int
  | VBool of bool
  | VUnit
  | VPair of value * value
  | VClosure of ident * expr * env
  | VRecClosure of ident * ident * expr * env

(*
let spreadsheet_values = M.empty
*)

let rec show_value v =
  match v with
  | VInt n -> string_of_int n
  | VBool v -> string_of_bool v
  | VUnit -> "()"
  | VPair (v1,v2) -> "(" ^ show_value v1 ^ ", " ^ show_value v2 ^ ")"
  | VClosure _ | VRecClosure _ -> "<fun>"

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

let rec eval_env (env : env) ((*spreadsheet values*) sp_vals : env) (e : expr) : value =
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
  (* *)
  | Cell (r, c) ->
      (match M.find_opt (cords_to_cell_name r c) sp_vals with
      | Some v -> v
      | None -> raise UncalculatedCell
      )
(*
let rec eval_cell (c : expr) : value = (eval_env M.empty) c

let create_map (s : expr list list) : env =
  match s with
  | [] -> 
  | row :: rest ->
    (match row with
    | c :: rest' ->
      (try M.add (*nazwa komórki*) (eval_cell c) sheet_values with
      | UncalculatedCell (r, c) ->)
    )*)

(*
let rec list_vals_to_map (s : expr list) (map : env) (row : int) (col : int) : env =
    match s with
    | [] -> map
    | h :: t -> 
      let evaluated_cell = eval_env M.empty h in
      let new_cell_name = cords_to_cell_name row col in
      let new_map = (M.add new_cell_name evaluated_cell map) in
      list_vals_to_map t new_map row (col + 1)-

let rec list_lists_vals_to_map (s : expr list list) (map : env) (row : int) : env =
    match s with
    | [] -> map
    | h :: t -> 
      let new_map = list_vals_to_map h map row 0 in
      list_lists_vals_to_map t new_map (row + 1)
*)

(* version without global values map *)
let eval_cell (c : expr) (map : env) : value option =
    try Some (eval_env M.empty map c) with
    | UncalculatedCell -> None

let rec list_vals_to_map (s : expr list) (map : env) (row : int) (col : int) : env =
    match s with
    | [] -> map
    | h :: t -> 
      let cell_name = cords_to_cell_name row col in
      let new_map = 
        begin match M.find_opt cell_name map with
        | Some _ -> map (* To już było kiedyś policzone *)
        | None ->
          begin match eval_cell h map with
          | Some v -> M.add cell_name v map (* Udało się policzyć, więc dodaję jako nową wartość do mapy *)
          | None -> map (* Póki co nie da się policzyć, więc zostawiam na później *)
          end
        end in
      list_vals_to_map t new_map row (col + 1)

let cyclel (s : expr list) : env =
  let map = M.empty in
  let rec it (n : int) (map : env) =
    match n with
    | 0 -> map
    | _ -> it (n - 1) (list_vals_to_map s map 0 0)
  in it (List.length s) map

let rec list_lists_vals_to_map (s : expr list list) (map : env) (row : int) : env =
    match s with
    | [] -> map
    | h :: t -> 
        let new_map = list_vals_to_map h map row 0 in
        list_lists_vals_to_map t new_map (row + 1)

let cyclell (s : expr list list) (h : int) (w : int) : env =
  let map = M.empty in
  let rec it (n : int) (map : env) =
    match n with
    | 0 -> map
    | _ -> it (n - 1) (list_lists_vals_to_map s map 0)
  in it (h * w) map

(* Chyba naprawdę będę musiał zrobić to tak jak jest w tej funkcji na górze, ale jeszcze rozszerzyć to do expr list list,
a potem zrobić pętlę, która przejdzie n razy. Wtedy jeżeli nie ma cyklu to wszystko powinno być policzone ponieważ
najdłuższa ścieżka w grafi n komórek ma n-1 krawędzi, które opisują zależności. Jako dodatkowy parametr mogę mieć listę,
w której będę zapisywał jakie komórki się udało policzyć. Wtedy na końcu mogę sprawdzić, czy tak lista ma n elementków
i jeżeli nie ma to znaczy, że gdzieś jest cykl i mogę to zgłosić.*)


(*
List.init n f = [f 0; f 1; ...; f (n-1)]
List.init width (get_cell_value vals_map 0)



let map_to_value_list (map : env) (r : int) (w : int) : value list =
  let vl = [] in
  let rec it (c : int) (vl : value list) =
    let new_elem = cords_to_cell_name r (c - 1) in
    match c with
    | 0 -> vl
    | _ -> it (c - 1) ( :: vl)
    *)


let map_to_value_list_list (map : env) (h : int) (w : int) : value list list =
  let get_cell_value r c = 
    M.find (cords_to_cell_name r c) map in
  let get_row r = List.init w (get_cell_value r) in
  List.init h get_row



let eval_spreadsheet (s : expr list list) : value list list option =
  let sp_height = List.length s in
  let sp_width =
    begin match s with
     [] -> 0
    | h :: _ -> List.length h
    end in
  let map_with_evaluated_values = cyclell s sp_height sp_width in
  if M.cardinal map_with_evaluated_values = sp_height * sp_width
    then Some (map_to_value_list_list map_with_evaluated_values sp_height sp_width)
    else None

(*let values_map = list_lists_vals_to_map s M.epmty 0 in

  | cykl zależności -> None*)


let parse_and_eval_spreadsheet (s : string list list) : string list list option =
  let es = List.map (List.map parse) s in
  let vs = eval_spreadsheet es in
  Option.map (List.map (List.map show_value)) vs

(*list_vals_to_map test*)
(*let vals_map = list_vals_to_map (List.map parse ["snd {0,1}"; "(1, 2)"; "fst {0,1} * 10 - {0,0}"]) M.empty 0 0;;*)

(*cyclel test*)
(*let vals_map = cyclel (List.map parse ["snd {0,1}"; "(1, 2)"; "fst {0,1} * 10 - {0,0}"]);;*)

(*list_lists_vals_to_map test*)
(*let vals_map = list_lists_vals_to_map (List.map (List.map parse) [["snd {0,1}"; "(1, 2)"; "fst {0,1} * 10 - {0,0}"]; ["1"; "2"; "{1,0} + {1,1}"]]) M.empty 0;;*)

(*cyclell test*)
(*let vals_map = cyclell (List.map (List.map parse) [["snd {0,1}"; "(1, 2)"; "fst {0,1} * 10 - {0,0}"]]);;*)

(* Uważać, bo tu są zależności spoza pierwszego wiersza, więc nie można tego testować na samym list_vals_to_map*)
(*let vals_map = cyclell (List.map (List.map parse) [["snd {1,0}"; "(1, 2)"; "fst {0,1} * 10 - {0,0}"]; ["(3,2*6 - 1)"; "{0,2}"; "if false then 3 else 7"]; ["{1, 2} + 3"; "true"; "if {2,1} then 1 else 2"]]);;*)
(*let vals_map = cyclell (List.map (List.map parse) );;*)


(*
let print_map map =
  M.iter (fun key value ->
    Printf.printf "%s -> %s\n" key (show_value value)
  ) map;;
*)

(*

[["funrec fib n -> if n <= 1 then n else fib (n - 1) + fib (n - 2)";"0"];["{0,0} 1";"1"];["{0,0} 2";"{0,1} + {1,1}"];["{0,0} 3";"{1,1} + {2,1}"];["{0,0} 4";"{2,1} + {3,1}"];["{0,0} 5";"{3,1} + {4,1}"];["{0,0} 6";"{4,1} + {5,1}"]]

*)