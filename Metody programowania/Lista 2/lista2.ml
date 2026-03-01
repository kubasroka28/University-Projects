(*Zadanie 1*)
let rec fib n = 
  if n = 0 then 0
  else if n = 1 then 1
  else fib (n-1) + fib (n-2);;

let fib_iter n =
  let rec it n (f1, f2) =
    if n = 0 then f1
    else it (n-1) (f2, f2 + f1) in 
  it n (0, 1);;

(*Zadanie 2*)
let matrix_mult m n =
  let (a, b, c, d) = m
  and (e, f, g, h) = n in
  (a * e + b * g, a * f + b * h, c * e + d * g, c * f + d * h);;

let matrix_id = (1, 0, 0, 1);;

let rec matrix_expt m k =
  if k = 0 then matrix_id
  else matrix_mult m (matrix_expt m (k - 1));;

let rec fib_matrix k =
  let (a, b, c, d) = matrix_expt (1, 1, 1, 0) k in b;;

(*Zadanie 3*)
let rec matrix_expt_fast m k =
  if k = 0 then matrix_id
  else if k mod 2 = 0 then 
    let half = matrix_expt_fast m (k/2) in
    matrix_mult half half
  else matrix_mult (matrix_expt_fast m (k-1)) m;;

let rec fib_fast k =
  let (a, b, c, d) = matrix_expt_fast (1, 1, 1, 0) k in b;;

(*Zadanie 4*)
let rec mem x xs =
  match xs with
  | [] -> false
  | h :: t -> if x = h then true else mem x t;;

(*Zadanie 5*)
let rec maximum xs =
  match xs with
  | [] -> neg_infinity
  | h :: t -> max h (maximum t);;

(*Zadanie 6*)
let rec suffixes xs =
  match xs with
  | [] -> [[]]
  | h :: t -> xs :: (suffixes t);;

(*Zadanie 7*)
let rec is_sorted xs =
  match xs with
  | [] -> true
  | [a] -> true
  | h :: h' :: t -> if h <= h' then is_sorted (h' :: t) else false;;

(*Zadanie 8 *)
let select xs =
  let rec minimum xs =
    match xs with
    | [] -> infinity
    | h :: t -> min h (minimum t)
  in
  let rec skip_x x xs =
    match xs with
    | [] -> []
    | h :: t -> if h = x then t else h :: (skip_x x t)
  in 
  let x = minimum xs in
  let xs' = skip_x x xs in
  (x, xs');;

(*to nie dziala, ale może jest blisko*)
(*let rec select xs =
  match xs with
  | [] -> (neg_infinity, [])
  | [x] -> (x, [])
  | h :: t -> let (min_val,rest) = select t in
    if h < min_val
    then (h, min_val :: rest)
    else(min_val, h :: rest)*)

let rec select_sort xs =
  if xs = [] then [] else
  let selection = select xs in
  (fst selection) :: select_sort (snd selection);;

