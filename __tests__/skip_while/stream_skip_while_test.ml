open Jest


let _ =
  describe "stream skip while" (fun () ->
    let open Expect in
    test "skip items until a positive number will be encountered" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip_while (fun x -> x < 0) (Stream.of_list [-1; -20; -2; 1; -3; 5; -10]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; -3; 5; -10|]
    );

    testAsync "skip if item is less than zero" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source = [|1; 2; 3; 4; 5|] in
      let check () =
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual source |> finish
      in
      let _unsubscribe = source
        |> Stream.Async.of_array ~delay:10 ~finish:check
        |> Stream.skip_while (fun x -> x < 0)
        |> Stream.subscribe (MockJs.fn mock_fn)
      in ()
    );
  )
