let is_sorted_geq (xs : 'a list) : bool =
  match xs with
  | [] -> true
  | [x] -> true
  | x :: y :: rest -> (x <= y) && (is_sorted_geq (y :: rest))