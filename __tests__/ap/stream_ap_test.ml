open Jest


let _ =
  describe "stream applicative" (fun () -> 
    let open Expect in

    testAsync "applicative" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source_a = [1; 2; 3; 4] in
      let delay_a = 14 in
      let source_f = [(fun x -> x + 1); (fun x -> x - 2)] in
      let delay_f = 10 in
      let time_for_checkout = 
        let time_a = delay_a * List.length source_a in
        let time_f = delay_f * List.length source_f in
        if time_a > time_f then delay_a + time_a else delay_f + time_f
      in
      let stream_a = source_a |> Stream.Async.of_list ~delay:delay_a in
      let stream_f = source_f |> Stream.Async.of_list ~delay:delay_f in
      let stream = Stream.ap stream_f stream_a in
      let _unsubscribe = stream |> Stream.subscribe (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|2; -1; 0; 1; 2|] |> finish
      ) time_for_checkout 
      in ()
    );
  )