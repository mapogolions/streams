open Jest


let _ =
  describe "stream is created from list" (fun () -> 
    let open Expect in 
    test "synchronous version: usual order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_list ["first"; "second"; "third"; "fourth"] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"first"; "second"; "third"; "fourth"|]
    );
    testAsync "asynchronous version: usual order" (fun finish -> 
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.Async.of_array 0 [|true; false|] in
      let _ = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in expect calls |> toEqual [|true; false|] |> finish
      ) 100 in ()
    );
    test "synchronous version: reverse order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_list_reverse ["first"; "second"; "third"; "fourth"] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"fourth"; "third"; "second"; "first"|]
    );
  )
