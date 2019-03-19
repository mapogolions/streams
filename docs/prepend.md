### `Stream.prepend : 'a -> 'a Stream.t -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:3000
  |> Stream.prepend 0
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > 0
  > "pass"
  > 1
  > 2
  > 3
  
  stream:  __1__2__3___.
  output: 0__1__2__3___.
*)
```