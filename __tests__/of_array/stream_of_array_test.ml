open Jest


let _ =
  describe "stream of array" (fun () -> 
    let open Expect in 
    test "usual order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_array [|"first"; "second"; "third"; "fourth"|] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"first"; "second"; "third"; "fourth"|]
    );
    test "reverse order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_array_reverse [|"first"; "second"; "third"; "fourth"|] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"fourth"; "third"; "second"; "first"|]
    )
  )