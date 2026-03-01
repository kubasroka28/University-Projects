let pp_pos
    ((start_p, end_p) : Lexing.position * Lexing.position) =
  if start_p.pos_cnum + 1 < end_p.pos_cnum then
    Printf.sprintf "%s:%d:%d-%d"
      start_p.pos_fname
      start_p.pos_lnum
      (start_p.pos_cnum - start_p.pos_bol + 1)
      (end_p.pos_cnum - start_p.pos_bol)
  else
    Printf.sprintf "%s:%d:%d"
      start_p.pos_fname
      start_p.pos_lnum
      (start_p.pos_cnum - start_p.pos_bol + 1)

exception Parse_error of
  string * Fol.Syntax.position

let parse_file fname =
  let lexbuf = Lexing.from_channel (open_in fname) in
  Lexing.set_filename lexbuf fname;
  try 
    Fol.Parser.main Fol.Lexer.token lexbuf
  with
  | Fol.Parser.Error ->
    raise (Parse_error(
      Lexing.lexeme lexbuf,
      (lexbuf.lex_start_p, lexbuf.lex_curr_p)))

let () =
  if Array.length Sys.argv < 2 then
    Printf.eprintf "Usage: %s <filename>\n" Sys.argv.(0)
  else
    try
      Sys.argv.(1)
        |> parse_file
        |> Fol.TypeCheck.check_defs
    with
    | Sys_error msg ->
      Printf.eprintf "Error: %s\n" msg;
      exit 1
    | Parse_error(tok, pos) ->
      Printf.eprintf "Error at %s: Unexpected token `%s'\n"
        (pp_pos pos)
        tok;
      exit 1
    | Fol.Syntax.Type_error(pos, msg) ->
      Printf.eprintf "Error at %s: %s\n"
        (pp_pos pos)
        msg;
      exit 1

