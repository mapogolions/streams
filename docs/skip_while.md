### `Stream.skip_while : ('a -> bool) -> 'a Stream.t -> 'a Stream.t`

```ocaml
let unsubscribe = [|1; 2; 0; 3|]
  |> Stream.Async.of_array ~delay:2000
  |> Stream.skip_while (fun x -> x < 2)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

(*
  > 3
  > 4
  
  stream: _1_2_0_3__.
  output: ___2_0_3__.
*)
```