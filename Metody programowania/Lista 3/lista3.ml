(*Zadanie 1*)
let fold_left f a xs =
  let rec it xs acc =
    match xs with
    | [] -> acc
    | x::xs -> it xs (f acc x)
  in it xs a;;

let new_product xs = fold_left ( * ) 1 xs;;

(*Zadanie 2*)
let compose f g = fun x -> f (g x);;

(*Zadanie 3*)
(* let build_list n f =
  let rec it m =
    match m with
    | 0 -> []
    | _ -> (f (n - m)) :: (it (m - 1))
  in it n;; *)

let build_list n f =
  let rec it m =
    if m = n then []
    else (f m) :: (it (m + 1))
  in it 0;;

let negatives n = build_list n (fun x -> - x);;

let reciprocals n = build_list n (fun x -> 1. /. (float_of_int x +. 1.));;

let evens n = build_list n (fun x -> 2 * x);;

let identityM n = build_list n (fun x -> build_list n (fun y -> if y = x then 1 else 0));;

(*Zadanie 4*)
let empty_set = fun x -> false;;

let singleton a = fun x -> x = a;;

let in_set a s = s a;;

let union s t = fun x -> in_set x s || in_set x t;;

let intersect s t = fun x -> in_set x s && in_set x t;;

(*Zadanie 5*)
let rec insert_bst x t =
  match t with
  | Leaf -> Node (Leaf, x, Leaf)
  | Node (l, v, r) ->
      if x = v
      then t
      else if v < x
      then Node (l, v, insert_bst x r)
      else Node (insert_bst x l, v, r);;

(*Zadanie 6*)
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree;;
let ex_tree = Node (Node (Leaf, 1, Leaf), 2, Node (Leaf, 3, Leaf));;

let rec fold_tree f a t =
  match t with
  | Leaf -> a
  | Node (l, v, r) -> f (fold_tree f a l) v (fold_tree f a r);;

let rec insert_bst x t =
  match t with
  | Leaf -> Node (Leaf, x, Leaf)
  | Node (l, v, r) ->
      if x = v
      then t
      else if v < x
      then Node (l, v, insert_bst x r)
      else Node (insert_bst x l, v, r);; 

let tree_product t = fold_tree (fun vl v vr -> vl * v * vr) 1 t;;

let tree_flip t = fold_tree (fun l v r -> Node(r, v, l)) Leaf t;;

let tree_height t = fold_tree (fun hl v hr -> (if hl > hr then hl else hr) + 1) 0 t;;

let tree_span t = fold_tree (fun (l_min, l_max) v (r_min, r_max) -> (min l_min v, max r_max v)) (max_int, min_int) t;;

let rec append xs ys =
  match xs with
  | [] -> ys
  | x :: xs' -> x :: append xs' ys;;

let flatten t = fold_tree (fun ls v rs -> append ls (v :: rs)) ([]) t;;

(*Zadanie 8*)
let rec insert_bst x t =
  match t with
  | Leaf -> Node (Leaf, x, Leaf)
  | Node (l, v, r) ->
      if v <= x
      then Node (l, v, insert_bst x r)
      else Node (insert_bst x l, v, r);;

let tree_sort xs =
  let rec tree_create ys =
    match ys with
    | [] -> Leaf
    | h :: h' -> insert_bst h (tree_create h')
  in flatten (tree_create xs);;

