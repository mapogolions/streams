type 'a t = ('a -> unit) -> unit -> unit

let noop () = ()
let empty_stream = fun _f -> noop
let empty () = empty_stream
let of_item (value : 'a) = fun f -> let _ = f value in noop

let later ?(finish=noop) delay f = let tid = Interop.setTimeout f delay in
  fun () -> begin Interop.clearTimeout tid; finish () end

let prepend value stream = fun cb -> let _ = cb value in stream cb

let scan reducer seed stream =
  fun cb ->
    let acc = ref seed in
    let _ = cb seed in stream (fun elem ->
      let _ = acc := reducer !acc elem in cb !acc)

let skip n stream = fun cb ->
  let count = ref n in
  stream (fun x -> if !count > 0 then let _ = count := !count - 1 in () else cb x)

let chain f  stream = fun cb ->
  let spawned_disposers = ref [] in
  let base_disposer = ref noop in
  let _ = base_disposer :=
    stream (fun x ->
      let unsubscribe = (f x) cb in
      let _ = spawned_disposers := unsubscribe :: !spawned_disposers in ()
    )
  in
  fun () -> begin
    !base_disposer ();
    List.iter (fun f -> f ()) !spawned_disposers
  end

let chain_latest f stream = fun cb ->
  let spawned_unsubscribe = ref noop in
  let base_unsubscribe = ref noop in
  let _ = base_unsubscribe :=
    stream (fun x ->
      let _ = !spawned_unsubscribe () in
      let _ = spawned_unsubscribe := (f x) cb in ()
    )
  in
  fun () -> begin
    !base_unsubscribe ();
    !spawned_unsubscribe ()
  end

let take n stream = fun cb ->
  let count = ref n in
  let unsubscribe = ref noop in
  let _ = unsubscribe :=
    stream (fun x ->
      if !count <= 0 then !unsubscribe ()
      else if !count <= 1 then begin
        count := !count - 1;
        cb x;
        !unsubscribe ();
      end
      else begin
        count := !count - 1;
        cb x
      end
    )
  in
  fun () -> !unsubscribe ()

let take_while predicate stream = fun cb ->
  let unsubscribe = ref noop in
  let _ = unsubscribe :=
    stream (fun x ->
      if not (predicate x) then !unsubscribe () else cb x
    )
  in
  fun () -> !unsubscribe ()

let skip_while predicate stream = fun cb ->
  let miss = ref true in
  stream (fun x ->
    if !miss then
      let _ = miss := predicate x in
      if not !miss then cb x else ()
    else cb x)

let ap stream_f stream_x = fun cb ->
  let current_f = ref None in
  let current_x = ref None in
  let push () =
    match !current_f, !current_x with
    | Some f, Some x -> cb (f x)
    | _              -> ()
  in
  let unsubscribe_f = stream_f (fun f -> begin current_f := Some f; push () end) in
  let unsubscribe_x = stream_x (fun x -> begin current_x := Some x; push () end) in
  fun () -> begin unsubscribe_f (); unsubscribe_x () end

let subscribe cb stream = stream cb

let of_list xs =
  Base.List.fold_right (fun x stream -> prepend x stream) (empty ()) xs

let of_list_reverse xs =
  Base.List.fold_left (fun stream x -> prepend x stream) (empty ()) xs

let of_array xs =
  Base.Array.fold_right (fun x stream -> prepend x stream) (empty()) xs

let of_array_reverse xs =
  Base.Array.fold_left (fun stream x -> prepend x stream) (empty ()) xs

let map f stream =
  fun cb -> stream (fun x -> cb (f x))

let map2 f stream_a stream_b = ap (map (fun a b -> f a b) stream_a) stream_b

let map3 f stream_a stream_b stream_c =
  let stream_f = map (fun a b c -> f a b c) stream_a in
  let stream_ab = ap stream_f stream_b in
  ap stream_ab stream_c

let filter predicate stream =
  fun cb -> stream (fun x -> if predicate x then cb x else ())

let merge streams =
  let identity x = x in
  chain identity (of_array streams)

module Async = struct
  let of_list ?(delay=0) ?(finish=noop) xs = fun cb ->
    let stream = later ~finish:finish delay in
    let unsubscribe = ref noop in
      let rec iter xs =
        match xs with
        | []      -> finish ()
        | h :: t  -> begin
          unsubscribe := stream (fun () -> iter t);
          cb h
        end
      in
      begin
        unsubscribe := stream (fun () -> iter xs);
        fun () -> !unsubscribe ()
      end

  let of_array ?(delay=0) ?(finish=noop) xs = fun cb ->
    let stream = later ~finish:finish delay in
    let unsubscribe = ref noop in
      let rec iter index =
        if index >= Array.length xs then finish ()
        else begin
          unsubscribe := stream (fun () -> iter (index + 1));
          cb xs.(index)
        end
      in
      begin
        unsubscribe := stream (fun () -> iter 0);
        fun () -> !unsubscribe ();
      end
end
