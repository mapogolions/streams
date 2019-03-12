open Jest


let _ = 
  describe "stream reverse" (fun () ->
    let open Expect in
    test "reverse stream that was created from a list" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.reverse (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|4; 3; 2; 1|]
    );
    test "reverse stream that was created from a reversed array" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.reverse (Stream.of_array_reverse [|1; 2; 3; 4|]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3; 4|]
    )
  )