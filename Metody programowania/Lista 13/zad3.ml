let insertion_sort xs =
  let rec insert x xs =
    match xs with
    | [] -> [x]
    | h :: t -> if x <= h then x :: xs else h :: (insert x t)
  in
  let rec iter xs ys =
    match xs with
    | [] -> ys
    | h :: t -> iter t (insert h ys)
  in iter xs []


  

let insertion_sort xs =
  let rec insert x xs =
    match xs with
    | [] -> [x]
    | h :: t -> if x <= h then x :: xs else h :: (insert x t)
  in match xs with
  | [] -> []
  | h :: t -> insert h (insertion_sort t)