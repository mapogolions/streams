#### `Stream.take : int -> 'a Stream.t -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:2000
  |> Stream.take 1
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 1
  
  stream: _1_2_3__.
  output: _1!
*)
```