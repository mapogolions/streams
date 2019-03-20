#### `Stream.merge : ('a Stream.t) array -> 'a t`

```ocaml
let stream_a = Stream.Async.of_list ~delay:5000 [2; 4]
let stream_b = Stream.Async.of_array ~delay:3000 [|1; 3|]
let stream = Stream.merge [|stream_a; stream_b|]
let unsubscribe = stream
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 1
  > 2
  > 3
  > 4

  stream_a: ____2____4_____.
  stream_b: __1__3___.
  output:   __1_23___4_____.
*)
```