let f = funrec fact (n : int) (r : int) : int ->
if n = 0 then r
else fact (n - 1) (r * n) in f 5 2
