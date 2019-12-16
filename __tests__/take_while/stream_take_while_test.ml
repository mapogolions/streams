open Jest


let _ =
  describe "stream take" (fun () ->
    let open Expect in

    test "take only negative numbers" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.take_while (fun x -> x < 0) (Stream.of_list [-1; -20; -2; 1; -3]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|-1; -20; -2; -3|]
    );

    testAsync "take items until a negative number will be encountered" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let check () =
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1; 20|] |> finish
      in
      let _unsubscribe = [|1; 20; -2; 1; 3|]
        |> Stream.Async.of_array ~delay:2 ~finish:check
        |> Stream.take_while (fun x -> x > 0)
        |> Stream.subscribe (MockJs.fn mock_fn)
      in ()
    );

    testPromise "take only 1 item because occurs interruption" (fun () ->
      let predicate = fun x -> x > 0 in
      let stream = [1; 2; 3]
        |> Stream.Async.of_list ~delay:10
        |> Stream.take_while predicate
      in
      let result = [| 1 |] in
      let delay = 15 in
      Test.Async.interrupt ~stream ~result ~delay
    )
  )
