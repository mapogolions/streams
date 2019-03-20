#### `Stream.map2 : ('a -> 'b -> 'c) -> 'a Stream.t -> 'b Stream.t -> 'c Stream.t`

```ocaml
let stream_a = Stream.Async.of_list ~delay:3000 [2; 4]
let stream_b = Stream.Async.of_array ~delay:2000 [|1; 3|]
let stream = Stream.map2 (fun a b -> a + b) stream_a stream_b
let unsubscribe = stream
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 3
  > 5
  > 7

  stream_a: __2__4___.
  stream_b: _1_3__.
  output:   __35_7___.
*)
```