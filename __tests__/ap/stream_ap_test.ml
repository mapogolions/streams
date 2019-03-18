open Jest


let _ =
  describe "stream applicative" (fun () -> 
    let open Expect in

    testAsync "first" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let values = [1; 2; 3; 4] in
      let t1 = 12 in
      let fns = [(fun x -> x + 1); (fun x -> x - 2)] in
      let t2 = 10 in
      let time_for_checkout = 
        let value1 = t1 * List.length values in
        let value2 = t2 * List.length fns in
        if value1 > value2 then (value1 + t1) else (value2 + t2)
      in
      let streamx = values |> Stream.Async.of_list ~delay:t1 in
      let streamf = fns |> Stream.Async.of_list ~delay:t2 in
      let _unsubscribe = (Stream.ap streamf streamx)
        |> Stream.subscribe (MockJs.fn mock_fn)
      in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|2; -1; 0; 1; 2|] |> finish
      ) time_for_checkout 
      in ()
    );
  )