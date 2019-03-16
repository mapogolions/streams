open Jest


let _ =
  describe "stream take" (fun () ->
    let open Expect in
    test "take 2 items from a sync stream" (fun () ->
      let stream = Stream.take 1 (Stream.of_list [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1|]
    );
    testPromise "take 3 itesm from an async stream" (fun () ->
      let source = [|1; 2; 3; 4; 5|] in
      let stream = source 
        |> Stream.Async.of_array 10
        |> Stream.take 2 
      in Test.Async.check_subsequence  ~stream ~result:[|1; 2|]
    );
    test "take negative number of items from a sync stream" (fun () ->
      let stream = Stream.take (-1) (Stream.of_list [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [||]
    );
    
    test "take 10 of items from a sync stream" (fun () ->
      let stream = Stream.take 10 (Stream.of_list [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3; 4|]
    );
  )