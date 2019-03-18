### `Stream.of_list : 'a list -> 'a Stream.t`

__Synchronous version__

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.of_list
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

> 1
> 2
> 3
> "pass"
```

__Asynchronous version__

```ocaml
let unsubscribe = [1; 2; 3]
  |> Stream.Async.of_list ~delay:2000
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)

let _ = print_endline "pass"

> "pass"
> 1
> 2
> 3

stream: __1__2__3__.
```