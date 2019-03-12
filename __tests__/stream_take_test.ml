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

    testAsync "take 2 items from an async stream" (fun finish ->
      let stream = Stream.take 2 (Stream.Async.of_list 0 [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1; 2;|] |> finish
      ) 100 in ()
    );

    testAsync "take negative number of items from an async stream" (fun finish ->
      let stream = Stream.take (-1) (Stream.Async.of_list 0 [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [||] |> finish
      ) 100 in ()
    );

    testAsync "take big positive number of items from an async stream" (fun finish ->
      let stream = Stream.take 10 (Stream.Async.of_list 0 [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1; 2; 3; 4|] |> finish
      ) 100 in ()
    );
  )