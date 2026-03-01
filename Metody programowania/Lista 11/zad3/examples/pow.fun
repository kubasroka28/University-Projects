let pow = funrec pow (p : int * int) : int ->
  if snd p = 0 then 1
  else fst p * pow (fst p, snd p - 1)
in
pow (3, 4)
