
type 'a t = ('a -> unit) -> (unit -> unit)

let noop () = ()
let empty_stream : 'a t = fun _f -> noop
let empty () = empty_stream
let of_item (value : 'a) : 'a t = fun f -> let _ = f value in noop

let later (delay : int) : unit t =
  fun f -> let tid = Interop.setTimeout f delay in
  fun () -> Interop.clearTimeout tid

let prepend (value : 'a) (stream : 'a t) = fun cb -> let _ = cb value in stream cb

let scan (reducer : 'b -> 'a -> 'b) (seed : 'b) (stream : 'a t) : 'b t =
  fun cb ->
    let acc = ref seed in
    let _ = cb seed in stream (fun elem -> 
      let _ = acc := reducer !acc elem in cb !acc)

let skip (n : int) (stream : 'a t) = fun cb -> 
  let count = ref n in
  stream (fun x -> if !count > 0 then let _ = count := !count - 1 in () else cb x)

let chain (f : 'a -> 'b t) (stream : 'a t) : 'b t = fun cb ->
  let spawned_disposers = ref [] and base_disposer = ref noop in
  let _ = base_disposer := stream (fun x -> 
    let unsubscribe = (f x) cb in
    let _ = spawned_disposers := unsubscribe :: !spawned_disposers in ()
  ) in fun () -> begin !base_disposer (); List.iter (fun f -> f ()) !spawned_disposers end

let chain_latest (f : 'a -> 'b t) (stream : 'a t) : 'b t = fun cb ->
  let spawned_unsubscribe = ref noop and base_unsubscribe = ref noop in
  let _ = base_unsubscribe := stream (fun x ->
    let _ = !spawned_unsubscribe () in
    let _ = spawned_unsubscribe := (f x) cb in ()
  ) in fun () -> begin !base_unsubscribe (); !spawned_unsubscribe () end

let take (n : int) (stream : 'a t) = fun cb ->
  let count = ref n
  and unsubscribe = ref noop in
  let _ = unsubscribe := stream (fun x -> 
    if !count <= 0 then !unsubscribe () 
    else if !count <= 1 then begin !unsubscribe (); count := !count - 1; cb x end
    else begin count := !count - 1; cb x end
  ) in fun () -> !unsubscribe ()

let take_while (predicate : 'a -> bool) (stream : 'a t) = fun cb ->
  let unsubscribe = ref noop in
  let _ = unsubscribe := stream (fun x ->
    if not (predicate x) then !unsubscribe () else cb x
  ) in fun () -> !unsubscribe ()

let reverse (stream : 'a t) : 'a t =
  let acc = ref (empty ()) in
  let _ = stream (fun x -> let _ = acc := prepend x !acc in ()) in !acc

let skip_while (predicate : 'a -> bool) (stream : 'a t) = fun cb ->
  let miss = ref true in
  stream (fun x -> 
    if !miss then 
      let _ = miss := predicate x in
      if not !miss then cb x else ()
    else cb x)

let subscribe (cb : 'a -> unit) (stream : 'a t) = stream cb

let of_list (xs : 'a list) = 
  Foldable.List.fold_right (fun x stream -> prepend x stream) (empty ()) xs

let of_list_reverse (xs : 'a list) =
  Foldable.List.fold_left (fun stream x -> prepend x stream) (empty ()) xs

let of_array (xs : 'a array) : 'a t =
  Foldable.Array.fold_right (fun x stream -> prepend x stream) (empty()) xs

let of_array_reverse (xs : 'a array) : 'a t =
  Foldable.Array.fold_left (fun stream x -> prepend x stream) (empty ()) xs

let map (f : 'a -> 'b) (stream : 'a t) : 'b t = 
  fun cb -> stream (fun x -> cb (f x))

let filter (predicate : 'a -> bool) (stream : 'a t) : 'a t =
  fun cb -> stream (fun x -> if predicate x then cb x else ())


module Async = struct
  let of_list (delay : int) (xs : 'a list) = fun cb -> 
    let stream = later delay and unsubscribe = ref noop in
      let rec iter xs =
        match xs with
        | []      -> ()
        | h :: t  -> begin unsubscribe := stream (fun () -> iter t); cb h end
      in begin unsubscribe := stream (fun () -> iter xs); fun () -> !unsubscribe () end

  let of_array (delay : int) (xs : 'a array) = fun cb -> 
    let stream = later delay and unsubscribe = ref noop in
      let rec iter index =
        if index >= Array.length xs then ()
        else begin unsubscribe := stream (fun () -> iter (index + 1)); cb xs.(index) end
      in begin unsubscribe := stream (fun () -> iter 0); fun () -> !unsubscribe () end
end
