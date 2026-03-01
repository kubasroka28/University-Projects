module I = Interp

(* RPN: syntax*)

type cmd =
  | PushInt  of int
  | PushBool of bool
  | PushPair
  | PushUnit
  | Fst
  | Snd
  | Is       of Ast.value_type
  | Binop    of Ast.bop
  | CndJmp   of prog * prog
  | Store
  | Load     of int
  | CleanUp  of int (* [1] *)
  | CopyEnv  of int (* [2] *)
  | Return
  | PushClo  of int list * prog (* [3] *)
  | PushRClo of int list * prog
  | Call

and prog = cmd list

(* Notes *)

(* [1] -- CleanUp pops n elems from the env stack to restore *)
(*        the environment from before let or entering a closure. *)
(* [2] -- CopyEnv copies the environemnt stored in the closure *)
(*        to the global env stack. This step would not be necessary *)
(*        in a grown-up compiler, since we statically know if a var *)
(*        is a let or a fun arg, or if it points to a closure. So it *)
(*        would be enough to keep a pointer to the current closure. *)
(*        CopEenv is done inside the body of the function, as it *)
(*        is the only place in the program that statically knows *)
(*        the size of the env stored in the closure. It can be *)
(*        dynamically read from the tag of course, but this method *)
(*        is used in gc only. *)
(* [3] -- the first arg is the list of indices that should be copied *)
(*        from env to the closure. *)

(* Compilation AST -> RPN *)

(* env during compilation keeps the current stack of bound *)
(* variables, so at they are compiled to de Bruijn indices *)
(* compiled to reading with an offset from runtime env. *)

and env = Ast.ident list

(* de Bruijn index of a var *)
let rec find_index (env : env) (x : Ast.ident) : int =
  match env with
  | y :: _ when x = y -> 0
  | _ :: ys -> find_index ys x + 1
  | [] -> failwith ("unknown var " ^ x)

let rec of_ast (env : env) (expr : Ast.expr) : prog =
  match expr with
  | Ast.Int n ->
      [PushInt n]
  | Ast.Bool b ->
      [PushBool b]
  | Ast.Binop (op, e1, e2) ->
      of_ast env e1 @ of_ast env e2 @ [Binop op]
  | Ast.If (b, t, e) ->
      of_ast env b @ [CndJmp (of_ast env t, of_ast env e)]
  | Ast.Pair (e1, e2) ->
      of_ast env e1 @ of_ast env e2 @ [PushPair]
  | Ast.Fst e ->
      of_ast env e @ [Fst]
  | Ast.Snd e ->
      of_ast env e @ [Snd]
  | Ast.Unit ->
      [PushUnit]
  | Ast.Is (t, e) ->
      of_ast env e @ [Is t]
  | Ast.Var x ->
      [Load (find_index env x)]
  | Ast.Let (x, e1, e2) ->
      of_ast env e1 @ [Store] @ of_ast (x :: env) e2 @ [CleanUp 1]
  | Ast.Fun (x, e) ->
      let fv = Ast.free_vars [x] e in
      let n = List.length fv in
      let body =
        [ CopyEnv n (* get env stored in closure *)
        ; Store ]   (* get argument that waits on the stack *)
        @ of_ast (x :: fv) e @
        [ CleanUp (n + 1)
        ; Return ]
      in
      [PushClo (List.map (find_index env) fv, body)]
  | Ast.Funrec (f, x, e) ->
      let fv = Ast.free_vars [x; f] e in
      let n = List.length fv in
      let body =
        [ CopyEnv (n + 1) (* get env stored in closure *)
        ; Store ]         (* get argument that waits on the stack *)
        @ of_ast (x :: f :: fv) e @
        [ CleanUp (n + 2)
        ; Return ]
      in
      [PushRClo (List.map (find_index env) fv, body)]
  | Ast.App (e1, e2) ->
      of_ast env e2 @ of_ast env e1 @ [Call]

(* RPN evaluator*)

(* not used in the compiler, but useful for debugging *)

type value =
  | VInt of int
  | VBool of bool
  | VUnit
  | VPair of value * value
  | VClosure of value list * prog
  | VRClosure of value list * prog
  | VRetAddr of prog

let rec show_value v =
  match v with
  | VInt n -> string_of_int n
  | VBool v -> string_of_bool v
  | VUnit -> "()"
  | VPair (v1,v2) -> "(" ^ show_value v1 ^ ", " ^ show_value v2 ^ ")"
  | VClosure _ -> "<fun>"
  | VRClosure _ -> "<fun>"
  | VRetAddr _ -> "<ret_addr>"

let eval_op (op : Ast.bop) (val1 : value) (val2 : value) : value =
  match op, val1, val2 with
  | Ast.Add,  VInt  v1, VInt  v2 -> VInt  (v1 + v2)
  | Ast.Sub,  VInt  v1, VInt  v2 -> VInt  (v1 - v2)
  | Ast.Mult, VInt  v1, VInt  v2 -> VInt  (v1 * v2)
  | Ast.Div,  VInt  v1, VInt  v2 -> VInt  (v1 / v2)
  | Ast.And,  VBool v1, VBool v2 -> VBool (v1 && v2)
  | Ast.Or,   VBool v1, VBool v2 -> VBool (v1 || v2)
  | Ast.Leq,  VInt  v1, VInt  v2 -> VBool (v1 <= v2)
  | Ast.Lt,   VInt  v1, VInt  v2 -> VBool (v1 < v2)
  | Ast.Gt,   VInt  v1, VInt  v2 -> VBool (v1 > v2)
  | Ast.Geq,  VInt  v1, VInt  v2 -> VBool (v1 >= v2)
  | Ast.Neq,  _,        _        -> VBool (val1 <> val2)
  | Ast.Eq,   _,        _        -> VBool (val1 = val2)
  | _,    _,        _        -> failwith "type error"

let rec eval (env : value list) (s : value list) (p : prog) : value =
  match p, s with
  | [], [n] -> n
  | [], _   -> failwith "error!"
  | (PushInt n :: p'), _ ->
      eval env (VInt n :: s) p'
  | (PushBool b :: p'), _ ->
      eval env (VBool b :: s) p'
  | (Binop op :: p'), (v2 :: v1 :: s') ->
      eval env (eval_op op v1 v2 :: s') p'
  | (CndJmp (t,_) :: p'), (VBool true :: s') ->
      eval env s' (t @ p')
  | (CndJmp (_,e) :: p'), (VBool false :: s') ->
      eval env s' (e @ p')
  | (PushPair :: p'), (v2 :: v1 :: s') ->
      eval env (VPair (v1, v2) :: s') p'
  | (Fst :: p'), (VPair (v1,_) :: s') ->
      eval env (v1 :: s') p'
  | (Snd :: p'), (VPair (_,v2) :: s') ->
      eval env (v2 :: s') p'
  | (PushUnit :: p'), s' ->
      eval env (VUnit :: s') p'
  | (Is t :: p'), (v :: s') ->
      let r =
        (match t, v with
        | Ast.TInt, VInt _
        | Ast.TBool, VBool _
        | Ast.TUnit, VUnit
        | Ast.TFun, VClosure _
        | Ast.TFun, VRClosure _ -> true
        | _ -> false)
      in
        eval env (VBool r :: s') p'
  | (Store :: p'), (v :: s') ->
      eval (v :: env) s' p'
  | (Load n :: p'), _ ->
      eval env (List.nth env n :: s) p'
  | (CleanUp n :: p'), _ ->
      eval (List.drop n env) s p'
  | (CopyEnv n :: p'), (VClosure (env', _) :: s') ->
      assert (n = List.length env');
      eval (env' @ env) s' p'
  | (CopyEnv n :: p'), (VRClosure (_ :: env', _) as c :: s') ->
      assert (n = List.length env' + 1);
      eval (c :: env' @ env) s' p'
  | (PushClo (fv, body) :: p'), _ ->
      eval env (VClosure (List.map (List.nth env) fv, body) :: s) p'
  | (PushRClo (fv, body) :: p'), _ ->
      eval env (VRClosure (VUnit :: List.map (List.nth env) fv, body) :: s) p'
  | (Return :: _), (v :: VRetAddr p' :: s') ->
      eval env (v :: s') p'
  | (Call :: p'), (VClosure (_, body) as c :: v :: s') ->
      eval env (c :: v :: VRetAddr p' :: s') body
  | (Call :: p'), (VRClosure (_, body) as c :: v :: s') ->
      eval env (c :: v :: VRetAddr p' :: s') body
  | _ -> failwith "error!"

(* Some super-simple optimizations *)

let rec optimize (p : prog) : prog =
  match p with
  | CndJmp (p1, p2) :: p' ->
      CndJmp (optimize p1, optimize p2) :: optimize p'
  | PushClo (n, body) :: p' ->
      PushClo (n, optimize body) :: optimize p'
  | CleanUp n :: CleanUp m :: p' ->
      optimize (CleanUp (n + m) :: p')
  | Store :: Load 0 :: CleanUp n :: p' ->
      optimize (CleanUp (n - 1) :: p')
  | CleanUp 0 :: p' -> optimize p'
  | c :: p' -> c :: optimize p'
  | [] -> []

