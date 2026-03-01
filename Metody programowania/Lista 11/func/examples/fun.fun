(fun f -> fun g -> f (g 10))
  (let z = 1 in fun x -> x + z)
  (fun x -> x * 10)
