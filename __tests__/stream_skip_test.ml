open Jest


let _ =
  describe "skip `n` elements" (fun () -> 
    let open Expect in 
    test "if `n` is greater then zero and less than length of sequence" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip 2 (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|3; 4|]
    );
    test "if `n` less than zero" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip (-1) (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3; 4|]
    );
    test "if `n` is greater than length of sequence" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip 100 (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [||]
    )
  )