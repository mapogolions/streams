open Jest

let _ =
  describe "stream chain" (fun () -> 
    let open Expect in 
    testAsync "Todo add description" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let base = Stream.Async.of_list 10 [1; 2; 3] in
      let triple = fun x -> Stream.Async.of_array 0 [|x; x; x|] in
      let stream = Stream.chain triple base in
      let _unsubscribe = stream (MockJs.fn mock_fn) in
      let _tid = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in 
        expect calls |> toEqual [|1; 1; 1; 2; 2; 2; 3; 3; 3|] |> finish
      ) 200 in ()
    );
    testAsync "Todo add description" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let base = Stream.Async.of_list 100 [1; 2; 3] in
      let triple = fun x -> Stream.Async.of_array 0 [|x; x; x|] in
      let stream = Stream.chain triple base in
      let unsubscribe = stream (MockJs.fn mock_fn) in
      let _tid = Interop.setTimeout (fun () ->
        let _ = unsubscribe () in
        let calls = mock_fn |> MockJs.calls in 
        expect calls |> toEqual [||] |> finish
      ) 0 in ()
    );
  )