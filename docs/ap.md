#### `Stream.ap : ('a -> 'b) Stream.t -> 'a Stream.t -> 'b Stream.t`

```ocaml
let h = fun x -> x + 1
let g = fun x -> x - 1
let stream_f = Stream.Async.of_list ~delay:2000 [h; g]
let stream_a = Stream.Async.of_array ~delay:3000 [|1; 2|]
let stream = Stream.ap stream_f stream_a
let unsubscribe = stream
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 2
  > 0
  > 1

  stream_f: _h_g__.
  stream_b: __1__2__.
  output:   __20_1__.
*)
```