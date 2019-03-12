open Jest


let _ = 
  describe "stream async" (fun () ->
    let open Expect in
    testAsync "Start every 500 ms. Call unsubscribe on the 900th ms" (fun finish ->
      let stream = Stream.Async.of_list 500 [1; 2; 3; 4] in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let _ = unsubscribe () in
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1|] |> finish
      ) 900 in ()
    );

    testAsync "Start every 10 ms. Immediate call of unsubscribe method" (fun finish ->
      let stream = Stream.Async.of_array 10 [|1; 2; 3; 4|] in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = unsubscribe () in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [||] |> finish
      ) 500 in ()
    );
  )

