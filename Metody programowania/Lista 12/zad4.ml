let zad4 (nn : (('a -> unit) -> unit) -> 'a) : ((('a -> unit) -> 'a) -> 'a) =
  let prawo_Pierca (zał_np_implikuje_p : ('a -> unit) -> 'a) =
  let nnp zał_np = zał_np (zał_np_implikuje_p zał_np) in
  nn nnp in
  prawo_Pierca




let zad4 (nn : (('a -> unit) -> unit) -> 'a) : ((('a -> unit) -> 'a) -> 'a) =
  fun f -> nn (fun np -> np (f np))


  
  



type alt = P of 'a | NegP of ('a -> unit)
let zad4 (nn : (('a -> unit) -> unit) -> 'a) : ((('a -> unit) -> 'a) -> 'a) =
  let zał1 (f : ('a -> unit) -> 'a) : 'a = 
    let np p : ('a -> unit) = 
  in
  let b : alt in
  match b with
  | P p -> (fun x -> p)
  | NegP np -> (fun x -> q np)
