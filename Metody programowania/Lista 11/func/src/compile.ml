(* main compile function: concrete syntax -> C *)
let compile (s : string) : string =
  s
  |> Interp.parse
  |> Rpn.of_ast []
  |> Rpn.optimize
  |> Emit.emit
  |> Runtime.with_runtime
