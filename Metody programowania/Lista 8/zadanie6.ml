let rec matrix_expt_fast arg =
  let m = fst arg in
  let k = snd arg in
  let mod = fun x y -> (x - (x / y) * y) in
  let matrix_mult = fun m n ->
    let a = fst (fst m) in let b = snd (fst m) in let c = fst (snd m) in let d = snd (snd m) in
    let e = fst (fst n) in let f = snd (fst n) in let g = fst (snd n) in let h = snd (snd n) in
    ((a * e + b * g, a * f + b * h), (c * e + d * g, c * f + d * h)) in
  if k = 0 then ((1, 0), (0, 1))
  else if mod k 2 = 0 then
    let half = matrix_expt_fast (m, (k/2)) in
    matrix_mult half half
  else matrix_mult (matrix_expt_fast (m, (k - 1))) m
in matrix_expt_fast (((1, 2), (3, 4)), 2)


let fib_fast = fun k ->
  let rec matrix_expt_fast arg =
    let m = fst arg in
    let k = snd arg in
    let mod = fun x y -> (x - (x / y) * y) in
    let matrix_mult = fun m n ->
      let a = fst (fst m) in let b = snd (fst m) in let c = fst (snd m) in let d = snd (snd m) in
      let e = fst (fst n) in let f = snd (fst n) in let g = fst (snd n) in let h = snd (snd n) in
      ((a * e + b * g, a * f + b * h), (c * e + d * g, c * f + d * h)) in
    if k = 0 then ((1, 0), (0, 1))
    else if mod k 2 = 0 then
      let half = matrix_expt_fast (m, (k/2)) in
      matrix_mult half half
    else matrix_mult (matrix_expt_fast (m, (k - 1))) m in
  let b = snd (fst (matrix_expt_fast (((1, 1), (1, 0)), k))) in b
in fib_fast 10


