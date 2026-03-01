open Ast

let parse (s : string) : prog =
  Parser.main Lexer.read (Lexing.from_string s)

type value =
  | VInt of int
  | VBool of bool

let show_value v =
  match v with
  | VInt n -> string_of_int n
  | VBool v -> string_of_bool v

(* Pamięć *)

module H = Map.Make(String)

type heap = value H.t

type 'a comp = heap -> 'a * heap

let return (v : 'a) : 'a comp =
  fun h -> (v, h)

let bind (c : 'a comp) (f : 'a -> 'b comp) : 'b comp =
  fun h -> let (v, h) = c h in f v h

let (let* ) = bind

let deref (l : ident) : value comp =
  fun h -> (H.find l h, h)

let assgn (l : ident) (v : value) : unit comp =
  fun h -> ((), H.add l v h)

let rec fold_m (f : 'a -> unit comp) (xs : 'a list)
  : unit comp =
  match xs with
  | [] -> return ()
  | x :: xs' ->
      let* _ = f x in
      fold_m f xs'

(* interpreter *)

let int_op op v1 v2 h =
  match v1, v2 with
  | VInt x, VInt y -> (VInt (op x y), h)
  | _ -> failwith "type error"

let cmp_op op v1 v2 h =
  match v1, v2 with
  | VInt x, VInt y -> (VBool (op x y), h)
  | _ -> failwith "type error"

let bool_op op v1 v2 h =
  match v1, v2 with
  | VBool x, VBool y -> (VBool (op x y), h)
  | _ -> failwith "type error"

let eval_op (op : bop) : value -> value -> value comp =
  match op with
  | Add  -> int_op ( + )
  | Sub  -> int_op ( - )
  | Mult -> int_op ( * )
  | Div  -> int_op ( / )
  | And  -> bool_op ( && )
  | Or   -> bool_op ( || )
  | Eq   -> (fun v1 v2 h -> (VBool (v1 = v2), h))
  | Neq  -> (fun v1 v2 h -> (VBool (v1 <> v2), h))
  | Leq  -> cmp_op ( <= )
  | Lt   -> cmp_op ( < )
  | Geq  -> cmp_op ( >= )
  | Gt   -> cmp_op ( > )

let rec eval_expr (e : expr) : value comp =
  match e with
  | Int i -> return (VInt i)
  | Bool b -> return (VBool b)
  | Binop (op, e1, e2) ->
     let* v1 = eval_expr e1 in
     let* v2 = eval_expr e2 in
     eval_op op v1 v2
  | Var x -> deref x

let rec eval_stmt (s : stmt) : unit comp =
  match s with
  | Skip -> return ()
  | Assign (x, e) ->
      let* r = eval_expr e in
      assgn x r
  | If (b, e1, e2) ->
      let* vb = eval_expr b in
      (match vb with
      | VBool true -> eval_stmt e1
      | VBool false -> eval_stmt e2
      | _ -> failwith "type error")
  | While (b, e) ->
      let* vb = eval_expr b in
      (match vb with
      | VBool true ->
          let* _ = eval_stmt e in
          eval_stmt s
      | VBool false -> return ()
      | _ -> failwith "type error")
  | Print e ->
      let* r = eval_expr e in
      print_string (show_value r);
      print_newline ();
      return ()
  | Block ss -> fold_m eval_stmt ss

let eval_prog (p : prog) : unit comp =
  fold_m eval_stmt p

let interp (s : string) : unit =
  ignore (eval_prog (parse s) H.empty)
