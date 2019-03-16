open Jest


let _ =
  describe "stream map" (fun () -> 
    let open Expect in 
    test "Each number is multiplied by 10" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map (fun x -> x * 10) (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|10; 20; 30; 40|]
    );

    testAsync "stream of strings is mapped to stream of integers" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map String.length (Stream.Async.of_list 0 ["1"; "12"; "123"]) in
      let _ = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in expect calls |> toEqual [|1; 2; 3|] |> finish
      ) 100 in ()
    )
  )