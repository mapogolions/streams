open Jest


let _ =
  describe "stream filter" (fun () -> 
    let open Expect in 
    test "stay integers that grather than 0" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.filter (fun x -> x > 0) (Stream.of_list [-1; 2; -2; 3]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|2; 3|]
    )
  )