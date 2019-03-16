module List = struct
  type 'a t = 'a list
  let rec fold_left (f : 'b -> 'a -> 'b) (seed : 'b) (xs : 'a t) : 'b =
    match xs with
    | []     -> seed
    | h :: t -> fold_left f (f seed h) t

  let rec fold_right (f: 'a -> 'b -> 'b) (seed : 'b) (xs : 'a t) : 'b =
    match xs with
    | []     -> seed
    | h :: t -> f h (fold_right f seed t)

  let array_of_list (xs : 'a t) =
    fold_left (fun acc x -> Array.append acc [|x|]) [||] xs
end

module Array = struct
  type 'a t = 'a array
  let fold_left (f: 'b -> 'a -> 'b) (seed : 'b) (xs : 'a t) : 'b =
    let rec iter seed index =
      if index >= Array.length xs then seed
      else iter (f seed xs.(index)) (index + 1)
    in iter seed 0

  let fold_right (f: 'a -> 'b -> 'b) (seed : 'b) (xs : 'a t) : 'b =
    let rec iter seed index =
      if index < 0 then seed
      else iter (f xs.(index) seed) (index - 1)
    in iter seed (Array.length xs - 1)

  let map (f : 'a -> 'b) (xs : 'a t) : 'b t = 
    fold_left (fun acc x -> Array.append acc [|(f x)|]) [||] xs

  let filter (f : 'a -> bool) (xs : 'a t) : 'a t = 
    fold_left (fun acc x -> if f x then Array.append acc [|x|] else acc) [||] xs

  let list_of_array (xs : 'a t) = fold_right (fun x acc -> x :: acc) [] xs
end