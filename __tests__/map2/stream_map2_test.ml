open Jest


let _ =
  describe "stream map2" (fun () ->
    let open Expect in

    testAsync "map2" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let check () =
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|-2; -1; 0; 1; 2|] |> finish
      in
      let stream_a = Stream.Async.of_list ~delay:10 [1; 2; 3] in
      let stream_b = Stream.Async.of_array ~delay:12 [|-3; -2; -1|] ~finish:check in
      let stream = Stream.map2 (fun a b -> a + b) stream_a stream_b in
      let _unsubscribe = stream |> Stream.subscribe (MockJs.fn mock_fn) in ()
    )
  )
