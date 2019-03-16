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

    testPromise "leave those numbers that are greater than 0" (fun () ->
      let source = [|-1; 2; -2; 3|] in
      let predicate = fun x -> x > 0 in
      let result = Base.Array.filter  predicate source in
      let base = Stream.Async.of_array 100 source in
      let stream = base |> Stream.filter predicate in
      Test.Async.check_subsequence ~stream ~result
    );

    testPromise "leave those numbers that are odd" (fun () ->
      let source = [-1; 0; 1; 2; 3; 4] in
      let odd = fun x -> x mod 2 <> 0 in
      let result = List.filter odd source in
      let base = Stream.Async.of_list 100 source in
      let stream = base |> Stream.filter odd in
      Test.Async.check_subsequence ~stream ~result:(Base.List.array_of_list result)
    );

    testPromise "leave those numbers that are even" (fun () ->
      let source = [|-1; 0; 1; 2; 3; 4|] in
      let even = fun x -> x mod 2 = 0 in
      let result = Base.Array.filter even source in
      let base = Stream.Async.of_array 100 source in
      let stream = base |> Stream.filter even in
      Test.Async.check_subsequence ~stream ~result
    );
  )