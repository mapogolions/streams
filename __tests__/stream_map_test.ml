open Jest


let _ =
  describe "stream map" (fun () -> 
    let open Expect in 
    test "integers are multiplied by 10" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map (fun x -> x * 10) (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|10; 20; 30; 40|]
    );
    test "strings are mapped to integers" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map String.length(Stream.of_list ["1"; "12"; "123"]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3|]
    )
  )