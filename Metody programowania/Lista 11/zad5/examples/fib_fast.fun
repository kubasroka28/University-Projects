let fib =
  (funrec go(p : int * int) : (int -> int) -> fun (n : int) ->
    if n <= 0
      then (snd p)
      else go (fst p + snd p, fst p) (n - 1))
  (1, 0)
in
  fib 35
