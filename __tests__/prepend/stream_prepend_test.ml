open Jest


let _ =
  describe "stream prepend" (fun () -> 
    let open Expect in 
    test "chain of integers" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_item 10 in
      let stream1 = Stream.prepend 9 stream in
      let stream2 = Stream.prepend 8 stream1 in
      let _ = stream2 (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|8; 9; 10|]
    );
  )