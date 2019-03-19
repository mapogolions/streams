open Jest


let _ =
  describe "stream map3" (fun () ->
    let open Expect in

    testAsync "map3" (fun finish ->
      let source_a = [1; 2; 3] in
      let source_b = [|-3; -2; -1|] in
      let source_c = [11; 12] in
      let delay_a = 9 in
      let delay_b = 12 in
      let delay_c = 20 in
      let time_for_checkout =
        let time_a = delay_a * List.length source_a in
        let time_b = delay_b * Array.length source_b in
        let time_c = delay_c * List.length source_c in
        let times = time_a :: time_b :: time_c :: [] in
        let longest = times 
          |> List.fast_sort (fun a b -> -1 * (a - b))
          |> List.hd
        in
        longest + delay_c
      in
      let stream_a = Stream.Async.of_list ~delay:delay_a source_a in
      let stream_b = Stream.Async.of_array ~delay:delay_b source_b in
      let stream_c = Stream.Async.of_list ~delay:delay_c source_c in
      let stream = Stream.map3 (fun a b c -> a + b + c) stream_a stream_b stream_c in
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = stream |> Stream.subscribe (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|10; 11; 12; 13; 14|] |> finish
      ) time_for_checkout
      in ()
    )
  )