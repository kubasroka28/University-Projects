open Rpn

let lbl_cntr = ref 0 (* global ref to generate fresh labels *)

let fresh_lbl () =
  incr lbl_cntr;
  string_of_int !lbl_cntr

let emit_bop (op : Ast.bop) : string =
  Ast.(match op with
  | Add  -> "+"
  | Sub  -> "-"
  | Mult -> "*"
  | Div  -> "/"
  | And  -> "&&"
  | Or   -> "||"
  | Eq   -> "=="
  | Neq  -> "!="
  | Gt   -> ">"
  | Lt   -> "<"
  | Geq  -> ">="
  | Leq  -> "<=")

let emit_bop_res_tag (op : Ast.bop) : string =
  Ast.(match op with
  | Add | Sub | Mult | Div -> "INT"
  | _ -> "BOOL")

let emit_value_type (t : Ast.value_type) : string =
  match t with
  | Ast.TInt -> "INT"
  | Ast.TBool -> "BOOL"
  | Ast.TUnit -> "UNIT"
  | Ast.TPair -> "PAIR"
  | Ast.TFun -> "CLO"

let emit_line ?comment:(c="") (s : string) : string =
  "    " ^ s ^ ";" ^
  (if c = "" then "" else " // " ^ c) ^
  "\n"

let emit_comment (s : string) : string =
  "    // " ^ s ^ "\n"

let emit_lbl (s : string) : string =
  "  case " ^ s ^ ":\n"

(* allocate list of values, pop n elems from the stack*)
let alloc_pop (ss : string list) (to_pop : int) : string =
  emit_line "check_stack()" ^
  emit_line ("pre_alloc(" ^ string_of_int (List.length ss) ^ ")") ^
  (ss
   |> List.mapi (fun i s ->
        emit_line ("heap[heap_ptr+" ^ string_of_int i ^ "] = " ^ s))
   |> String.concat "") ^
  emit_line ("heap_ptr += " ^ string_of_int (List.length ss)) ^
  emit_line ("stack_ptr += " ^ string_of_int (1 - to_pop)) ^
  emit_line ("stack[stack_ptr] = heap_ptr - " ^ string_of_int (List.length ss - 1))

let show_cmd (c : cmd) : string =
  match c with
  | PushInt n -> emit_comment ("PushInt " ^ string_of_int n)
  | PushBool b -> emit_comment ("PushBool " ^ (if b then "true" else "false"))
  | Binop _op -> emit_comment "Binop"
  | PushPair -> emit_comment "PushPair"
  | CndJmp _ -> emit_comment "CndJmp"
  | Fst -> emit_comment "Fst"
  | Snd -> emit_comment "Snd"
  | PushUnit -> emit_comment "PushUnit"
  | Is t -> emit_comment ("Is " ^ emit_value_type t)
  | Load n -> emit_comment ("Load " ^ string_of_int n)
  | Store -> emit_comment "Store"
  | CleanUp n -> emit_comment ("CleanUp " ^ string_of_int n)
  | CopyEnv n -> emit_comment ("CopyEnv " ^ string_of_int n)
  | PushClo _ -> emit_comment "PushClo"
  | PushRClo _ -> emit_comment "PushRClo"
  | Return -> emit_comment "Return"
  | Call -> emit_comment "Call"

let rec emit_cmd (c : cmd) : string =
  show_cmd c ^
  match c with
  | PushInt n ->
      alloc_pop ["INT"; string_of_int n] 0
  | PushBool n ->
      alloc_pop ["BOOL"; if n then "1" else "0"] 0
  | PushPair ->
      alloc_pop ["PAIR"; "stack[stack_ptr-1]"; "stack[stack_ptr]"] 2
  | PushUnit ->
      alloc_pop ["UNIT"; "UNIT"] 0
  | Fst ->
      emit_line "stack[stack_ptr] = heap[stack[stack_ptr]]"
  | Snd ->
      emit_line "stack[stack_ptr] = heap[stack[stack_ptr]+1]"
  | Is Ast.TFun ->
      alloc_pop ["BOOL"; "heap[stack[stack_ptr] - 1] >= CLO"] 1
  | Is t ->
      alloc_pop ["BOOL"; "heap[stack[stack_ptr] - 1] == " ^ emit_value_type t] 1
  | Binop op ->
      alloc_pop
        [emit_bop_res_tag op;
         ("heap[stack[stack_ptr-1]] " ^ emit_bop op ^ " heap[stack[stack_ptr]]")]
        2
  | CndJmp (t, e) ->
      let lbl_t = fresh_lbl () in
      let lbl_end = fresh_lbl () in
      emit_line ("if (heap[stack[stack_ptr]]) GOTO(" ^ lbl_t ^ ")") ^
      emit_line "stack_ptr--" ^
      emit e ^
      emit_line ("GOTO(" ^ lbl_end ^ ")") ~comment:"jump over then branch"^
      emit_lbl lbl_t ^
      emit_line "stack_ptr--" ^
      emit t ^
      emit_lbl lbl_end
  | Load n ->
      emit_line "check_stack()" ^
      emit_line "stack_ptr++" ^
      emit_line ("stack[stack_ptr] = env[env_ptr-" ^ string_of_int n ^ "]")
  | Store ->
      emit_line "check_env()" ^
      emit_line "env_ptr++" ^
      emit_line "env[env_ptr] = stack[stack_ptr]" ^
      emit_line "stack_ptr--"
  | CleanUp n ->
      emit_line ("env_ptr -= " ^ string_of_int n)
  | CopyEnv n ->
      let rec copy m =
        if m = 0 then ""
        else emit_line ("env[env_ptr+" ^ string_of_int m ^ "] = heap[stack[stack_ptr]+" ^ string_of_int (n - m + 1) ^ "]") ^
             copy (m - 1)
      in
        copy n ^
        (if n > 0 then emit_line ("env_ptr += " ^ string_of_int n) else "") ^
        emit_line ("stack_ptr--") ~comment:"pop closure from stack"
  | PushClo (fv, b) ->
      let lbl_body = fresh_lbl () in
      let lbl_end = fresh_lbl () in
      alloc_pop (["CLO + " ^ string_of_int (List.length fv); lbl_body]
                 @ List.map (fun n -> "env[env_ptr-" ^ string_of_int n ^ "]") fv) 0 ^
      emit_line ("GOTO(" ^ lbl_end ^ ")") ^
      emit_lbl lbl_body ^
      emit b ^
      emit_lbl lbl_end
  | PushRClo (fv, b) ->
      let lbl_body = fresh_lbl () in
      let lbl_end = fresh_lbl () in
      alloc_pop (["CLO + " ^ string_of_int (List.length fv + 1); lbl_body; "heap_ptr + 1"]
                 @ List.map (fun n -> "env[env_ptr-" ^ string_of_int n ^ "]") fv) 0 ^
      emit_line ("GOTO(" ^ lbl_end ^ ")") ^
      emit_lbl lbl_body ^
      emit b ^
      emit_lbl lbl_end
  | Return ->
      emit_line "ret_ptr--" ^
      emit_line "GOTO(ret[ret_ptr+1])"
  | Call ->
      let ret_lbl = fresh_lbl () in
      emit_line "check_ret()" ^
      emit_line ("ret[ret_ptr+1] = " ^ ret_lbl) ^
      emit_line "ret_ptr++" ^
      emit_line "GOTO(heap[stack[stack_ptr]])" ^
      emit_lbl ret_lbl

and emit (p : prog) : string =
  List.fold_left (fun res cmd -> res ^ emit_cmd cmd) "" p

