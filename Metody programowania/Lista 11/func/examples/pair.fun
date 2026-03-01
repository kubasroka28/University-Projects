let p = ((1,2),(3,4)) in
if pair? p
  then fst (fst p) + snd (snd p)
  else 0
