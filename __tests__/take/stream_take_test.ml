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

    testAsync "take 3 items from an async stream" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let check () =
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1; 2; 3|] |> finish
      in
      let _unsubscribe = [|1; 2; 3; 4; 5|]
        |> Stream.Async.of_array ~delay:10 ~finish:check
        |> Stream.take 3
        |> Stream.subscribe (MockJs.fn mock_fn)
      in ()
    );

    test "take negative number of items from a sync stream" (fun () ->
      let stream = Stream.take (-1) (Stream.of_list [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [||]
    );

    testAsync "take negative number of items from an async stream" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let check () =
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [||] |> finish
      in
      let _unsubscribe = [1; 2; 3; 4; 5]
        |> Stream.Async.of_list ~delay:10 ~finish:check
        |> Stream.take (-20)
        |> Stream.subscribe (MockJs.fn mock_fn)
      in ()
    );

    test "take big positive number of items from a sync stream" (fun () ->
      let stream = Stream.take 10 (Stream.of_list [1; 2; 3; 4]) in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3; 4|]
    );

    testAsync "take big positive number of items from an async stream" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source = [1; 2; 3; 4; 5] in
      let check () =
        let calls = mock_fn |> MockJs.calls in
        let result = Base.List.array_of_list source in
        expect calls |> toEqual result |> finish
      in
      let _unsubscribe = source
        |> Stream.Async.of_list ~delay:10 ~finish:check
        |> Stream.take 20
        |> Stream.subscribe (MockJs.fn mock_fn)
      in ()
    );

    testPromise "take 0 items because occurs interruption" (fun () ->
      let stream = [1; 2; 3] |> Stream.Async.of_list ~delay:20 |> Stream.take 2 in
      let result = [||] in
      let delay = 5 in
      Test.Async.interrupt ~stream ~result ~delay
    )
  )
