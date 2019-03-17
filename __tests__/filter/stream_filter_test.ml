open Jest


let _ =
  describe "stream filter" (fun () ->
    let open Expect in
    test "leave those numbers that are less than 0" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _unsubscribe = [-1; 0; -2]
        |> Stream.of_list_reverse
        |> Stream.filter (fun x -> x < 0) 
        |> Stream.subscribe (MockJs.fn mock_fn)
      in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|-2; -1|]
    );

    testAsync "leave those numbers that are greater than 0" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source = [|-1; 2; -2; 3|] in
      let delay = 10 in
      let time_for_checkout = delay * Array.length source + delay in
      let predicate = fun x -> x > 0 in
      let _unsubscribe = source
        |> Stream.Async.of_array ~delay
        |> Stream.filter predicate
        |> Stream.subscribe (MockJs.fn mock_fn)
      in
      let _ = Interop.setTimeout (fun () -> 
        let calls = mock_fn |> MockJs.calls in
        let result = source |> Base.Array.filter predicate in
        expect calls |> toEqual result |> finish
      ) time_for_checkout 
      in ()
    );

    testAsync "leave those numbers that are odd" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source = [-1; 0; 1; 2; 3; 4] in
      let delay = 10 in
      let time_for_checkout = delay * List.length source + delay in
      let predicate = fun x -> x mod 2 <> 0 in
      let _unsubscribe = source
        |> Stream.Async.of_list ~delay
        |> Stream.filter predicate
        |> Stream.subscribe (MockJs.fn mock_fn)
      in
      let _ = Interop.setTimeout (fun () -> 
        let calls = mock_fn |> MockJs.calls in
        let result = source |> List.filter predicate |> Base.List.array_of_list in
        expect calls |> toEqual result |> finish
      ) time_for_checkout 
      in ()
    );

    testAsync "leave those numbers that are even" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let source = [-1; 0; 1; 2; 3; 4] in
      let delay = 10 in
      let time_for_checkout = delay * List.length source + delay in
      let predicate = fun x -> x mod 2 = 0 in
      let _unsubscribe = source
        |> Stream.Async.of_list ~delay
        |> Stream.filter predicate
        |> Stream.subscribe (MockJs.fn mock_fn)
      in
      let _ = Interop.setTimeout (fun () -> 
        let calls = mock_fn |> MockJs.calls in
        let result = source |> List.filter predicate |> Base.List.array_of_list in
        expect calls |> toEqual result |> finish
      ) time_for_checkout 
      in ()
    );
  )