#### `Stream.of_list : 'a list -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.of_list
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > 1
  > 2
  > 3
  > "pass"
*)
```

### `Stream.Async.of_list : 'a list -> 'a Stream.t`

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

  stream: _1_2_3__.
*)
```