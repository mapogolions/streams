### `Stream.scan : ('b -> 'a -> 'b) -> 'b -> 'a Stream.t -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:2000
  |> Stream.scan (fun acc x -> acc * x) 1
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > 1
  > "pass"
  > 1
  > 2
  > 6
  
  stream:  _1_2_3__.
  output: 1_1_2_6__.
*)
```