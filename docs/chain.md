### `Stream.chan : ('a -> 'b Stream.t) -> 'a Stream.t -> 'b Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:3000
  |> Stream.chain (fun x -> Stream.Async.of_array ~delay:2000 [|x; x|])
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

(*
  > "pass"
  > 1
  > 1
  > 2
  > 2
  > 3
  > 3

  base:      __1__2__3___.
  derived_1:    _1_1__.
  derived_2:       _2_2__.
  derived_3:          _3_3__.
  output:    ____1_12_23_3__.
*)
```