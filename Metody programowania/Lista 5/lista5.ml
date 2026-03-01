let list_of_string s = String.to_seq s |> List.of_seq;;

(* Zadanie 3 *)
let parens_ok s =
    let rec it s_list o c =
        if c > o then false
        else
            match s_list with
            | [] -> if o = c then true else false
            | '(' :: s' -> it s' (o + 1) c
            | ')' :: s' -> it s' o (c + 1)
            | _ -> false
    in it (list_of_string s) 0 0;;

(* Zadanie 4 *)
let parens_ok s =
    let rec it s_list stack =
        match s_list with
        | [] -> stack = []
        | '(' :: s' -> it s' ('(' :: stack)
        | ')' :: s' -> (match stack with
            | '(' :: st' -> it s' st'
            | _ -> false)
        | '[' :: s' -> it s' ('[' :: stack)
        | ']' :: s' -> (match stack with
            | '[' :: st' -> it s' st'
            | _ -> false)
        | '{' :: s' -> it s' ('{' :: stack)
        | '}' :: s' -> (match stack with
            | '{' :: st' -> it s' st'
            | _ -> false)
        | _ -> false
    in it (list_of_string s) [];;

(* Zadanie 7 *)
type 'a symbol =
    | T of string
    | N of 'a ;;

type 'a grammar = ('a * ('a symbol list) list) list;;

let generate (grammar : 'a grammar) (starting_symbol : 'a) =
    let rec until_no_nonterminals expression = 
        match expression with
        | [] -> ""
        | T terminal :: rest -> terminal ^ (until_no_nonterminals rest)
        | N nonterminal :: rest -> 
            let productions = List.assoc nonterminal grammar in
            let rule = List.nth productions (Random.int (List.length productions)) in
            (until_no_nonterminals rule) ^ (until_no_nonterminals rest)
    in until_no_nonterminals [N starting_symbol];;


(*

let pol : string grammar =
 [ "zdanie", [[N "grupa-podmiotu"; N "grupa-orzeczenia"]]
 ; "grupa-podmiotu", [[N "przydawka"; N "podmiot"]]
 ; "grupa-orzeczenia", [[N "orzeczenie"; N "dopelnienie"]]
 ; "przydawka", [[T "Piekny "];
 [T "Bogaty "];
 [T "Wesoly "]]
 ; "podmiot", [[T "policjant "];
 [T "student "];
 [T "piekarz "]]
 ; "orzeczenie", [[T "zjadl "];
 [T "pokochal "];
 [T "zobaczyl "]]
 ; "dopelnienie", [[T "zupe."];
 [T "sam siebie."];
 [T "instytut informatyki."]]
];;

*)
    