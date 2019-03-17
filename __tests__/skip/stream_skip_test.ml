open Jest


let _ =
  describe "skip `n` elements" (fun () -> 
    let open Expect in 
    test "skip if `n` is greater then zero and less than length of sequence" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip 2 (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|3; 4|]
    );
   
    testAsync "skip if `n` is less than zero" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source = [|1; 2; 3; 4; 5|] in
      let delay = 10 in
      let time_for_checkout = delay * Array.length source + delay in
      let _unsubscribe = source
        |> Stream.Async.of_array ~delay
        |> Stream.skip (-10)
        |> Stream.subscribe (MockJs.fn mock_fn)
      in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual source |> finish
      ) time_for_checkout
      in ()
    );

    test "skip if `n` is greater than length of sequence" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip 100 (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [||]
    );
  )