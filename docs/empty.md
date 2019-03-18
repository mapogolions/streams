### `Stream.empty : unit -> 'a Stream.t`

```ocaml
let unsubscribe = Stream.empty ()
  |> Stream.subscribe (fun () -> print_endline "pass")

(* no output *)
```