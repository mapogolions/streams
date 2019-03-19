### `Stream.of_array : 'a array -> 'a Stream.t`

```ocaml
let unsubscribe = [|1; 2; 3|]
  |> Stream.of_array
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

> 1
> 2
> 3
> "pass"
```

### `Stream.Async.of_array : 'a array -> 'a Stream.t`

```ocaml
let unsubscribe = [|1; 2; 3|]
  |> Stream.Async.of_array ~delay:2000
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