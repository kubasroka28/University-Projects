type ty_name = string
type ctor_name = string

type ctor = Ctor of ctor_name * ty_name list
type ty_def = ty_name * ctor list




let print_induction (type_def : ty_name * ctor list) : unit =
  let (type_name, ctor_list) = type_def in
  print_endline ("Niech P będzie predykatem na zbiorze elementów typu " ^ type_name ^ ". Jeżeli:");
  let print_conditions ctor_list =
    begin match ctor_list with
    | [] -> ()
    | ctor :: rest ->
      print_string "-";
      let (ctor_name, ctor_elems) = ctor in
      let rec find_inductive_ctor_elems_and_print_quantifiers ctor_elems elems_counter =
        begin match ctor_elems with
        | [] -> []
        | elem_type_name :: rest -> 
          print_string "forall x"; print_int elems_counter; print_string (" : " ^ elem_type_name ^ ", ");
          (elem_type_name = type_name, "x" ^ (string_of_int elems_counter)) :: (find_inductive_ctor_elems_and_print_quantifiers rest (elems_counter + 1))
        end in
      let variables_elems_list = find_inductive_ctor_elems_and_print_quantifiers ctor_elems 0 in
      let rec print_assumptions variables_elems_list =
        begin match variables_elems_list with
        | [] -> ()
        | [(b, v)] -> if b then print_string ("P(" ^ v ^ ") implies") else (); print_assumptions []
        | (b, v) :: t -> if b then print_string ("P(" ^ v ^ ") and ") else (); print_assumptions t
        end
      in print_assumptions variables_elems_list;
      print_string ("P(" ^ ctor_name ^ "(");
      let rec print_ctor_elems variables_elems_list =
        begin match variables_elems_list with
        | [] -> ()
        | [(_, v)] -> print_string v; print_ctor_elems []
        | (_, v) :: t -> print_string (v ^ ", "); print_ctor_elems t
        end
      in print_ctor_elems variables_elems_list;
      print_endline "))"
    end
  in print_conditions ctor_list;
  print_endline ("Wówczas predykat P jest prawdziwy dla każdego elementu ze zbioru " ^ type_name)




      if ty_name_list = []
        then print_endline ("-P(" ^ ctor_name ^ ")")
      else 
      

      print_endline "-P()"  
      print_conditions t
  



  "Niech P będzie predykatem na zbiorze int list
  Jeżeli:
  -P(Nil)
  -forall x : int, forall xs : int_list, P(xs) to P(x::xs)
  Wtedy P jest prawdziwe dla każdego elementu zbioru X
  "








type ty_name = string
type ctor_name = string
type ctor = Ctor of ctor_name * ty_name list
type ty_def = ty_name * ctor list

let print_induction (type_def : ty_name * ctor list) : unit =
  let (type_name, ctor_list) = type_def in
  print_endline ("Niech P będzie predykatem na zbiorze elementów typu " ^ type_name ^ ". Jeżeli:");

  let print_condition (Ctor (ctor_name, ctor_elems)) =
    print_string "- ";
    let rec find_inductive_ctor_elems_and_print_quantifiers elems counter =
      match elems with
      | [] -> []
      | elem_type_name :: rest ->
        let var = "x" ^ string_of_int counter in
        print_string ("forall " ^ var ^ " : " ^ elem_type_name);
        if rest <> [] then print_string " ";
        let rest_result = find_inductive_ctor_elems_and_print_quantifiers rest (counter + 1) in
        (elem_type_name = type_name, var) :: rest_result
    in

    let variables_elems_list = find_inductive_ctor_elems_and_print_quantifiers ctor_elems 0 in
    if variables_elems_list <> [] then print_string ", ";

    let rec print_assumptions lst =
      match lst with
      | [] -> ()
      | [(true, v)] -> print_string ("P(" ^ v ^ ") => ")
      | (true, v) :: t -> print_string ("P(" ^ v ^ ") and "); print_assumptions t
      | (false, _) :: t -> print_assumptions t
    in

    print_assumptions variables_elems_list;

    print_string ("P(" ^ ctor_name ^ "(");
    let rec print_ctor_args lst =
      match lst with
      | [] -> ()
      | [(_, v)] -> print_string v
      | (_, v) :: t -> print_string (v ^ ", "); print_ctor_args t
    in
    print_ctor_args variables_elems_list;
    print_endline "))"
  in

  List.iter print_condition ctor_list;

  print_endline ("Wówczas predykat P jest prawdziwy dla każdego elementu ze zbioru " ^ type_name ^ ".")




(" int_list ",
  [ Ctor ("Nil", []) ;
    Ctor (" Cons ", [" int "; " int_list "])
  ])


("int_tree",
  [ Ctor ("Leaf", []) ;
  Ctor ("Node", ["int_tree"; "int"; "int_tree"])
  ])

("szalone_drzewo",
  [ Ctor ("Leaf1", []) ;
    Ctor ("Leaf2", ["bool"]) ;
    Ctor ("Node1", ["szalone_drzewo"; "int"; "string"; "szalone_drzewo"; "szalone_drzewo"]);
    Ctor ("Node2", ["szalone_drzewo"; "unit"])
  ])

