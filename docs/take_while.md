### `Stream.take_while : ('a -> bool) -> 'a Stream.t -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:3000
  |> Stream.take_while (fun x -> x < 2)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

(*
  > 1
  > 2
  
  stream: __1__2__3___.
  output: __1__2___!
*)
```