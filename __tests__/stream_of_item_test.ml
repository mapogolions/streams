open Jest


let _ =
  describe "stream of item" (fun () -> 
    let open Expect in 
    test "item has type integer" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _ = Stream.of_item 10 (MockJs.fn mock_fn) in
      let _ = Stream.of_item 0 (MockJs.fn mock_fn) in
      let _ = Stream.of_item (-1) (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|10; 0; -1|]
    );
    test "item has type string" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _ = Stream.of_item "" (MockJs.fn mock_fn) in
      let _ = Stream.of_item "some text" (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [| ""; "some text"|]
    )
  )