open Jest


let _ =
  describe "stream filter" (fun () -> 
    testPromise "leave those numbers that are greater than 0" (fun () ->
      let source = [|-1; 2; -2; 3|] in
      let predicate = fun x -> x > 0 in
      let exhaust = Base.Array.filter  predicate source in
      let base = Stream.Async.of_array 100 source in
      let stream = base |> Stream.filter predicate in
      Test.Async.check_subsequence ~stream ~exhaust
    );

    testPromise "leave those numbers that are odd" (fun () ->
      let source = [-1; 0; 1; 2; 3; 4] in
      let odd = fun x -> x mod 2 <> 0 in
      let exhaust = List.filter odd source in
      let base = Stream.Async.of_list 100 source in
      let stream = base |> Stream.filter odd in
      Test.Async.check_subsequence ~stream ~exhaust:(Base.List.array_of_list exhaust)
    );

    testPromise "leave those numbers that are odd" (fun () ->
      let source = [|-1; 0; 1; 2; 3; 4|] in
      let even = fun x -> x mod 2 = 0 in
      let exhaust = Base.Array.filter even source in
      let base = Stream.Async.of_array 100 source in
      let stream = base |> Stream.filter even in
      Test.Async.check_subsequence ~stream ~exhaust
    );
  )