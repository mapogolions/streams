open Jest


let _ =
  describe "stream is created from list" (fun () -> 
    let open Expect in 
    test "A sync stream is created from list of strings" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_list ["first"; "second"; "third"; "fourth"] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"first"; "second"; "third"; "fourth"|]
    );
    test "A sync stream is created from reversed list of strings" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_list_reverse ["first"; "second"; "third"; "fourth"] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"fourth"; "third"; "second"; "first"|]
    );
  )
