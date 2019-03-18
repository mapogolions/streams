open Jest


let _ =
  describe "stream map2" (fun () ->
    let open Expect in

    testAsync "map2" (fun finish ->
      let source_a = [1; 2; 3] in
      let source_b = [|-3; -2; -1|] in
      let delay_a = 10 in
      let delay_b = 12 in
      let time_for_checkout =
        let time_a = delay_a * List.length source_a in
        let time_b = delay_b * Array.length source_b in
        if time_a > time_b then time_a + delay_a else time_b + delay_b
      in
      let stream_a = Stream.Async.of_list ~delay:delay_a source_a in
      let stream_b = Stream.Async.of_array ~delay:delay_b source_b in
      let stream = Stream.map2 (fun a b -> a + b) stream_a stream_b in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream |> Stream.subscribe (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|-2; -1; 0; 1; 2|] |> finish
      ) time_for_checkout
      in ()
    )
  )