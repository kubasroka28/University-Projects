let read_file_to_string filename =
  let ic = open_in filename in
  let len = in_channel_length ic in
  let content = really_input_string ic len in
  close_in ic;
  content

let () =
  if Array.length Sys.argv < 2 then
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    try
      match
        Sys.argv.(1)
        |> read_file_to_string
        |> Csv.of_string ~has_header:false
        |> Csv.input_all
        |> Spreadsheet.Interp.parse_and_eval_spreadsheet
      with
        | Some t -> Csv.print t
        | None -> raise (Sys_error ("Circular dependency in spreadsheet"))
    with Sys_error msg ->
      Printf.eprintf "Error: %s\n" msg
