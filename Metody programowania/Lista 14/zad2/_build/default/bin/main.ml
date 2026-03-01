(* Entry point: interpreter *)

let () =
  if Array.length Sys.argv < 2 then
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    try
      Sys.argv.(1)
        |> Io.read_file_to_string
        |> While.Interp.interp
    with Sys_error msg ->
      Printf.eprintf "Error: %s\n" msg
