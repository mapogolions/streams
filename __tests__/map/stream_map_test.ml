open Jest


let _ =
  describe "stream map" (fun () -> 
    let open Expect in 
    test "each number is multiplied by 10" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map (fun x -> x * 10) (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|10; 20; 30; 40|]
    );

    testPromise "stream of strings is mapped to stream of integers" (fun () ->
      let source = ["1"; "12"; "123"] in
      let result = List.map String.length source in
      let base = Stream.Async.of_list 0 source in
      let stream = base |> Stream.map String.length in
      Test.Async.check_subsequence ~stream ~result:(Base.List.array_of_list result)
    );
  )