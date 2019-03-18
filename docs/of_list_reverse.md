### `Stream.of_list_reverse : 'a list -> 'a Stream.t`

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.of_list_reverse
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

> 3
> 2
> 1
```