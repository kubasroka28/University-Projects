let f = funrec test (a : int) (b : int) (c : int) : int ->
if a = 0 then b + c
else test (a - 1) (b + b) (c + c) in
f 3 2 3
