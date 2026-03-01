let alpha_num = 3
let alpha_denom = 4

type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree
type 'a sgtree = { tree : 'a tree; size : int; max_size: int }

let alpha_height (n : int) : int = int_of_float (log (float_of_int n) /. log ((float_of_int alpha_denom) /. (float_of_int alpha_num)))

let rebuild_balanced (t : 'a tree) : 'a tree =
    let flatten t =
        let rec aux t acc =
            match t with
            | Leaf -> acc
            | Node (l, v, r) -> aux l (v :: aux r acc)
        in aux t []
    in

    let rec balanced_tree_from_sorted_list (node_list : 'a list) (list_len : int) =
        let left_len = list_len / 2
        and right_len = list_len - (list_len / 2) - 1 in

        let left_subtree = if left_len = 0 then Leaf else (balanced_tree_from_sorted_list node_list left_len) in

        let rec shorten_list cutting_len list : 'a list =
            if cutting_len = 0 then list
            else match list with
            | [] -> []
            | h :: t -> shorten_list (cutting_len - 1) t
        in

        let (new_root, rest_of_list) = 
            match shorten_list left_len node_list with
            | [] -> failwith "impossible case"
            | h :: t -> (h, t)
        in
        
        let right_subtree = if right_len = 0 then Leaf else (balanced_tree_from_sorted_list rest_of_list right_len) in

        Node (left_subtree, new_root, right_subtree)
    in
    let tree_list = flatten t in
    balanced_tree_from_sorted_list tree_list (List.length tree_list)


let empty : 'a sgtree = { tree = Leaf; size = 0; max_size = 0 }


let find (x : 'a) (sgt : 'a sgtree) : bool =
    let rec find_bst x t =
        match t with
        | Leaf -> false
        | Node (l, v, r) -> 
            if x = v then true
            else find_bst x (if x < v then l else r)
    in find_bst x sgt.tree
            

let insert (x : 'a) (sgt : 'a sgtree) : 'a sgtree =
    if find x sgt = true then sgt else
    let rec tree_size t =
        match t with
        | Leaf -> 0
        | Node (l, _, r) -> tree_size l + tree_size r + 1
    in
    
    let is_balanced l_size r_size : bool=
        let sum = l_size + 1 + r_size in
        let limit = (alpha_num * sum) / alpha_denom in
        (l_size <= limit) && (r_size <= limit)
    in
    
    let rec insert_bst x t path path_len : 'a tree * 'a tree option * int =
      match t with
      | Leaf -> 
        if path_len <= alpha_height sgt.size then (Node(Leaf, x, Leaf), None, 0)
        else (Node(Leaf, x, Leaf), None, 1)
      | Node (l, v, r) ->
          if x < v then
              let (new_left, scapegoat, child_size) = insert_bst x l (t :: path) (path_len + 1) in
              match scapegoat with
              | None -> 
                  if child_size = 0 then (Node(new_left, v, r), scapegoat, child_size)
                  else 
                      let right_size = tree_size r in
                      if is_balanced child_size right_size then (Node(new_left, v, r), scapegoat , child_size + 1 + right_size)
                      else (Node(new_left, v, r), Some t , child_size)
              | _ -> (Node(new_left, v, r), scapegoat, child_size)  
          else 
              let (new_right, scapegoat, child_size) = insert_bst x r (t :: path) (path_len + 1) in
              match scapegoat with
              | None -> 
                  if child_size = 0 then (Node(l, v, new_right), scapegoat, child_size)
                  else 
                      let left_size = tree_size l in
                      if is_balanced left_size child_size then (Node(l, v, new_right), scapegoat, left_size + 1 + child_size)
                      else (Node(l, v, new_right), Some t , child_size)
              | _ -> (Node(l, v, new_right), scapegoat, child_size) 
    in

    let rec replace_with_rebuilt (t : 'a tree) (scapegoat : 'a tree) (rebuilt_tree : 'a tree) : 'a tree =
        match scapegoat with
        | Leaf -> failwith "impossible case"
        | Node (_, sgt_val, _) ->
            (match t with
            | Leaf -> Leaf
            | Node (l, v, r) ->
                if v = sgt_val then rebuilt_tree
                else Node (replace_with_rebuilt l scapegoat rebuilt_tree, v, replace_with_rebuilt r scapegoat rebuilt_tree)
            )
    in

    let (new_tree, scapegoat, _) = insert_bst x sgt.tree [] 0 in
    let new_size = sgt.size + 1 in
    match scapegoat with
        | None -> { tree = new_tree; size = new_size; max_size = max sgt.max_size new_size }
        | Some scpg->
            let rebuilt = rebuild_balanced scpg in
            let new_balanced_tree = replace_with_rebuilt new_tree scpg rebuilt in
            { tree = new_balanced_tree; size = new_size; max_size = max sgt.max_size new_size }


let remove (x : 'a) (sgt : 'a sgtree) : 'a sgtree = 
    let rec find_node_with_the_lowest_value (t : 'a tree) =
        match t with
        | Leaf -> None
        | Node (l, v, _) ->
            if l = Leaf then Some v else find_node_with_the_lowest_value l
    in
    let rec remove_bst (x : 'a) (t : 'a tree) = 
        match t with
        | Leaf -> Leaf
        | Node (l, v, r) -> 
            if x = v then 
                match t with
                | Leaf -> failwith "impossible case"
                | Node (Leaf, v, Leaf) -> Leaf
                | Node (l, v, Leaf) -> l
                | Node (Leaf, v, r) -> r
                | Node (l, v, r) -> 
                    (match find_node_with_the_lowest_value r with
                    | None -> failwith "impossible case"
                    | Some v' -> Node (l, v', remove_bst v' r)
                    )
            else if x < v then Node(remove_bst x l, v, r)
            else Node(l, v, remove_bst x r)
    in
    let new_size = sgt.size - 1 in
    if new_size < (sgt.max_size * alpha_num) / alpha_denom
      then { tree = rebuild_balanced (remove_bst x sgt.tree); size = new_size; max_size = new_size}
      else { tree = remove_bst x sgt.tree; size = new_size; max_size = sgt.max_size}


(*
let test = empty;;
let test = insert 50 test;;
let test = insert 75 test;;
let test = insert 100 test;;
let test = insert 125 test;;
let test = insert 150 test;;
let test = insert 175 test;;
let test = insert 200 test;;
let test = insert 225 test;;
let test = insert 250 test;;


*)


