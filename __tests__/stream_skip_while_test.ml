open Jest


let _ = 
  describe "stream skip while" (fun () -> 
    let open Expect in
    test "skip items until a positive number will be encountered" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip_while (fun x -> x < 0) (Stream.of_list [-1; -20; -2; 1; -3; 5; -10]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; -3; 5; -10|]
    )
  )