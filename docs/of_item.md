### `Stream.of_item : 'a -> 'a Stream.t`

```ocaml
let unsubscribe = "hello"
  |> Stream.of_item
  |> Stream.subscribe print_endline

(*
  > "hello"
*)
```