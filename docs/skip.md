#### `Stream.skip : int -> 'a Stream.t -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3; 4]
  |> Stream.Async.of_list ~delay:2000
  |> Stream.skip 2
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 3
  > 4
  
  stream: _1_2_3_4__.
  output: _____3_4__.
*)
```