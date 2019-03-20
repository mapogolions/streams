#### `Stream.map : ('a -> 'b) -> 'a Stream.t -> 'b Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:2000
  |> Stream.map (fun x -> x * x)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 1
  > 4
  > 9

  stream: _1_2_3__.
  output: _1_4_9__.
*)
```