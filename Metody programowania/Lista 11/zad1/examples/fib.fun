let fib =
  funrec fib (n : int) : int ->
    if n <= 1
      then n
      else fib (n - 1) + fib (n - 2)
in
  fib 24
