(* Zadanie 1 *)
module type DICT = sig
  type ('a, 'b) dict
  val empty : ('a, 'b) dict
  val insert : 'a -> 'b -> ('a, 'b) dict -> ('a, 'b) dict
  val remove : 'a -> ('a, 'b) dict -> ('a, 'b) dict
  val find_opt : 'a -> ('a, 'b) dict -> 'b option
  val find : 'a -> ('a, 'b) dict -> 'b
  val to_list : ('a, 'b) dict -> ('a * 'b) list
  end;;

module ListDict : DICT = struct
  type ('a, 'b) dict = ListDict of ('a * 'b) list

  let empty = ListDict []

  let insert x y (ListDict d) = ListDict ((x, y) :: d)

  let remove x (ListDict d) = ListDict (List.filter (fun (a, _) -> a <> x) d)

  let rec find_opt x (ListDict d) = 
    match d with
    | [] -> None
    | (a, b) :: d' -> if x = a then Some b else find_opt x (ListDict d')

  let rec find x (ListDict d) =
    match d with
    | [] -> failwith "key not found"
    | (a, b) :: d' -> if x = a then b else find x (ListDict d')

  let rec to_list (ListDict d) = 
    match d with
    | [] -> []
    | (a, b) :: d' -> (a, b) :: to_list (ListDict d')
end;;

(* Zadanie 2 *)
module type KDICT = sig
  type key
  type 'a dict
  val empty : 'a dict
  val insert : key -> 'a -> 'a dict-> 'a dict
  val remove : key -> 'a dict -> 'a dict
  val find_opt : key -> 'a dict -> 'a option
  val find : key -> 'a dict -> 'a
  val to_list : 'a dict -> (key * 'a) list
  end;;

(* Zadanie 3 *)
module MakeListDict (Order : Map.OrderedType) : KDICT with type key = Order.t = struct
  type key = Order.t
  type 'a dict = (key * 'a) list
  
  let empty = []
  
  let insert k v d = (k, v) :: List.filter (fun (a, _) -> a <> k) d
  
  let remove k d = List.filter (fun (a, _) -> a <> k) d
  
  let rec find_opt k d =
    match d with
    | [] -> None
    | (a, b) :: d' -> if k = a then Some b else find_opt k d'

  let rec find k d =
    match d with
    | [] -> failwith "key not found"
    | (a, b) :: d' -> if k = a then b else find k d'
  
  let rec to_list d =
    match d with
    | [] -> []
    | (a, b) :: d' -> (a, b) :: to_list d' 
end 

module CharListDict = MakeListDict (struct
  type t = char
  let compare = Char.compare
end)

(* Zadanie 4 *)
module MakeMapDict (Order : Map.OrderedType) : KDICT with type key = Order.t = struct
  type key = Order.t
  module M = Map.Make(Order)
  type 'a dict = a; M.then

  let empty = M.empty
  let insert x y map = M.add x y map
  let remove x map = M.remove x map
  let find_opt x map = M.find_opt x map
  let find x map = M.find x map
  let to_list map = M.to_list map
end

(* Zadanie 5 *)
module Freq (D : KDICT) = struct
  let freq (xs : D.key list) : (D.key * int) list = 
    let rec aux xs dict =
      match xs with
      | [] -> D.to_list dict
      | h :: t ->
        let d = 
         match D.find_opt h (dict) with
         | None -> D.insert h 1 dict
         | Some count -> D.insert h (count + 1) (D.remove h dict)
        in aux t d
    in aux xs D.empty
end

let list_of_string s = String.to_seq s |> List.of_seq;;

module FreqChar = Freq(CharListDict);;

let char_freq s = FreqChar.freq (list_of_string s);;

(*
-mam funktor ktory ma przyjmowac modul kdict z kluczem key o danym typie
-zwraca on modul, ktory zawiera funkcje freq, ktora dla jakiejs listy
zwroci liste par (wartosc typu key wystepujaca w liscie * liczba wystapien

-funkcja freq przyjmuje liste typu D.key i zwraca słownik(D.key * int))
*)