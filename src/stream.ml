
type 'a t = ('a -> unit) -> (unit -> unit)

external clearTimeout : (float -> unit) = "" [@@bs.val]
external setTimeout : (unit -> unit) -> int -> float = "" [@@bs.val]

let noop () = ()
let empty_stream : 'a t = fun _f -> noop
let empty () = empty_stream
let of_item (value : 'a) : 'a t = fun f -> f value; noop
let prepend (value : 'a) (stream : 'a t) = fun f -> f value; stream f
let later (delay : int) : unit t =
  fun cb -> let tid = setTimeout cb delay in
  fun () -> clearTimeout tid


let rec of_list (xs : 'a list) : 'a t =
  match xs with
  | [] -> empty ()
  | h :: t -> prepend h (of_list t)

let rec fold_right (f : 'a -> 'b -> 'b) (seed : 'b) (xs : 'a list) : 'b =
  match xs with
  | [] -> seed
  | h :: t -> f h (fold_right f seed t)

let rec fold_left (f : 'b -> 'a -> 'b) (seed : 'b) (xs : 'a list) : 'b =
  match xs with
  | [] -> seed
  | h :: t -> fold_left f (f seed h) t

let of_list_iter (xs : 'a list) = fold_right (fun x stream -> prepend x stream) (empty ()) xs

let of_array (xs : 'a array) : 'a t =
  let rec iter index =
    if index >= Array.length xs then empty ()
    else prepend xs.(index) (iter (index + 1))
  in iter 0

let of_array_iter (xs : 'a array) : 'a t =
  let rec iter index stream = 
    if index < 0 then stream
    else iter (index - 1) (prepend xs.(index) stream)
  in iter (Array.length xs - 1) (empty ())

let map (f : 'a -> 'b) (stream : 'a t) : 'b t = 
  fun cb -> stream (fun x -> cb (f x))

let filter (predicate : 'a -> bool) (stream : 'a t) : 'a t =
  fun cb -> stream (fun x -> if predicate x then cb x else ())

let async_of_list (later : int -> unit t) (delay : int) (xs : 'a list) =
  fun cb -> let stream = later delay in
            let cleanup = ref (fun () -> ()) in
            let rec iter xs =
              match xs with
              | [] -> ()
              | h :: [] -> cb h;
              | h :: t -> cleanup := stream (fun () -> iter t); cb h; in
            let _ = cleanup := stream (fun () -> iter xs) in
            fun () -> !cleanup ()