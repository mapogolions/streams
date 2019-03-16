open Jest


let _ =
  describe "stream scan" (fun () -> 
    let open Expect in 
    test "partial sums" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.scan (fun seed x -> seed + x) 0 (Stream.of_list [-1; 2; -2; 3]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|0; -1; 1; -1; 2|]
    );
    test "partial products" (fun () -> 
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.scan (fun seed x -> seed * x) 1 (Stream.of_array [|1; 2; 3; 4|]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 1; 2; 6; 24|]
    )
  )