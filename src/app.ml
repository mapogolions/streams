let base = Stream.Async.of_list 1000 [1; 2; 3; 4]
let stream = Stream.chain_latest (fun x -> Stream.Async.of_list 250 [x; x; x; x]) base
let _unsubscribe = stream (fun x -> x |> string_of_int |> print_endline)
let _ = print_endline "basic-stream"
