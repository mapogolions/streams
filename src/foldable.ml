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
end

module Array = struct
  type 'a t = 'a array
  let fold_left (f: 'b -> 'a -> 'b) (seed : 'b) (xs : 'a t) : 'b =
    let rec iter acc index =
      if index >= Array.length xs then acc
      else iter (f seed xs.(index)) (index + 1)
    in iter seed 0

  let fold_right (f: 'a -> 'b -> 'b) (seed : 'b) (xs : 'a t) : 'b =
    let rec iter acc index = 
      if index < 0 then acc
      else iter (f xs.(index) seed) (index - 1)
    in iter seed (Array.length xs - 1)
end