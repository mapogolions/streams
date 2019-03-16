open Jest


let _ =
  describe "stream filter" (fun () -> 
    let open Expect in 
    test "leave those numbers that are greater than 0" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.filter (fun x -> x > 0) (Stream.of_list [-1; 2; -2; 3]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|2; 3|]
    );
    test "leave those numbers that are odd" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let odd = fun x -> x mod 2 <> 0 in
      let stream = Stream.filter odd (Stream.of_list [-1; 0; 1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|-1; 1; 3|]
    );

    (* testPromise "leave thos numbsers that are even" (fun () ->
      Test.Async.success_for_stream
        ~source:[-1; 0; 1; 2; 3; 4] 
        ~exhaust:[|-1; 0; 1; 2; 3; 4|]
        ~filters:[Stream.filter (fun x -> x mod 2 = 0)]
    ); *)
    (* testAsync "leave those numbers that are even" (fun finish ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let even = fun x -> x mod 2 = 0 in
      let stream = Stream.filter even (Stream.Async.of_list 0 [-1; 0; 1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let calls = mock_fn |> MockJs.calls in expect calls |> toEqual [|0; 2; 4|] |> finish
      ) 100 in ()
    ); *)
  )