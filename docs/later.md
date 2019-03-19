### `Stream.later : int -> unit Stream.t`

```ocaml
let unsubscribe = Stream.later 2000
  |> Stream.subscribe (fun () -> print_endline "pass")

(*
  > "pass"
*)
```