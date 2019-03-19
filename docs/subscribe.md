### `Stream.subscribe : ('a -> unit) -> 'a Stream.t -> (unit -> unit)`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:2000
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 1
  > 2
  > 3
*)
```