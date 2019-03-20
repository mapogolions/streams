#### `Stream.map3 : ('a -> 'b -> 'c -> 'd) -> 'a Stream.t -> 'b Stream.t -> 'c Stream.t -> 'd Stream.t`

```ocaml
let stream_a = Stream.Async.of_list ~delay:5000 [2; 4]
let stream_b = Stream.Async.of_array ~delay:4000 [|1; 3|]
let stream_c = Stream.Async.of_list ~delay:2000 [0]
let stream = Stream.map3 (fun a b c -> a + b + c) stream_a stream_b stream_c
let unsubscribe = stream
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 3
  > 5
  > 7

  stream_a: ____2____4_____.
  stream_b: __1__3___.
  stream_c: _0__.
  output:   ____3__5_7_____.
*)
```