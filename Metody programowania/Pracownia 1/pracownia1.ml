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
            else if x < v then find_bst x l
            else find_bst x r
    in find_bst x sgt.tree
            

let insert (x : 'a) (sgt : 'a sgtree) : 'a sgtree =
    let rec tree_size t =
        match t with
        | Leaf -> 0
        | Node (l, _, r) -> tree_size l + 1 + tree_size r
    in
    
    let is_balanced t (child_size : int) (child_side : char) : bool * int=
        match t with
        | Leaf-> (true, 0)
        | Node (l, _, r) ->
            let (l_size, r_size) = if child_side = 'l' then (child_size, tree_size r) else (tree_size l, child_size) in
            let sum = l_size + 1 + r_size in
            let limit = (alpha_num * sum) / alpha_denom in
            if (l_size <= limit) && (r_size <= limit) then (true, sum) else (false, sum)
    in

    let find_child_side parent child : char =
        match parent with
        | Leaf -> failwith "incorrect data"
        | Node (l, v, r) -> if child = l then 'l' else if child = r then 'r' else failwith "child not found" 
    in





    let find_scapegoat (path : 'a tree list) =
        match path with
        | [] -> None
        | first_node :: rest ->
            (match first_node with
            | Leaf -> None
            | Node (l, v, r) ->
                let first_node_child_size = tree_size l
                and first_node_child_side = 'l' in
                let rec aux (path : 'a tree list) (child_size : int) (child_side : char) : 'a tree option =
                    match path with
                    | [] -> None
                    | parent :: [] ->
                        (match (is_balanced parent child_size child_side) with
                        | (false, _) -> Some parent
                        | (true, _) -> None)
                    | parent :: grandparent :: rest -> 
                        (match (is_balanced parent child_size child_side) with
                        | (false, _) -> Some parent
                        | (true, size) -> aux (grandparent :: rest) size (find_child_side grandparent parent))
                in aux path first_node_child_size first_node_child_side
            )
    in





    (*let rec find_scapegoat (path : 'a tree list) (child_size : int) (child_side : char) : 'a tree option =
        match path with
        | [] -> None
        | parent :: [] ->
            (match (is_balanced parent child_size child_side) with
            | (false, _) -> Some parent
            | (true, _) -> None)
        | parent :: grandparent :: rest -> 
            (match (is_balanced parent child_size child_side) with
            | (false, _) -> Some parent
            | (true, size) -> find_scapegoat (grandparent :: rest) size (find_child_side grandparent parent))
    in*)
    
    let rec insert_bst x t (path_length : int) (path : 'a tree list) : 'a tree * int * 'a tree list =
        match t with
        | Leaf -> let new_tree = Node (Leaf, x, Leaf) in
            (new_tree, path_length, path)
        | Node (l, v, r) ->
            if x = v then (t, path_length, path)
            else if x < v then
                let (new_left, new_len, new_path) = insert_bst x l (path_length + 1) (t :: path) in
                (Node(new_left, v, r), new_len, new_path)
            else 
                let (new_right, new_len, new_path) = insert_bst x r (path_length + 1) (t :: path) in
                (Node(l, v, new_right), new_len, new_path)
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
        
        (*if t = scapegoat then rebuilt_tree
        else match t with
          | Leaf -> Leaf
          | Node (l, v, r) ->
              Node ( replace_with_rebuilt l scapegoat rebuilt_tree, v, replace_with_rebuilt r scapegoat rebuilt_tree )*)

    in

    let (new_tree, path_len, path) = (insert_bst x sgt.tree 0 []) in
        if(path_len <= alpha_height (sgt.size + 1)) then
            { tree = new_tree; size = sgt.size + 1; max_size = max sgt.max_size (sgt.size + 1) }
        else match find_scapegoat path with
            | None -> { tree = new_tree; size = sgt.size + 1; max_size = max sgt.max_size (sgt.size + 1) }
            | Some scapegoat->
                let rebuilt = rebuild_balanced scapegoat in
                let new_balanced_tree = replace_with_rebuilt new_tree scapegoat rebuilt in
                { tree = new_balanced_tree; size = sgt.size + 1; max_size = max sgt.max_size (sgt.size + 1) }


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
    { tree = remove_bst x sgt.tree; size = sgt.size - 1; max_size = sgt.max_size}