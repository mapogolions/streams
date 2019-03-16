let unsubscribe = 
  Stream.Async.of_list 1000 [1; 2; 3]
  |> Stream.map (fun x -> x + 1)
  |> Stream.filter (fun x -> x mod 2 <> 0)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)
let _ = print_endline "basic-stream"
