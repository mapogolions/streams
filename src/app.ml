let unsubscribe = [1; 2; 3; 4; 5; 6; 7; 8; 9; 10]
  |> Stream.Async.of_list ~delay:500
  |> Stream.map (fun x -> x + 1)
  |> Stream.filter (fun x -> x mod 2 <> 0)
  |> Stream.subscribe (fun x -> x |> string_of_int |> print_endline)