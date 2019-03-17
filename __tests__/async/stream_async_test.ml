open Jest


let _ = 
  describe "stream async" (fun () ->
    testPromise "Start every 10 ms" (fun () ->
      let source = ["third"; "second"; "first"] in
      let result = [|"third"; "second"; "first"|] in
      let delay = 10 in
      Test.Async.stream_of_list_match ~source ~result ~delay
    );

    testPromise "Start every 50 ms. Call unsubscribe ot the 120th ms" (fun () ->
      let stream = [1; 2; 3] |> Stream.Async.of_list ~delay:50 in
      let result = [|1; 2|] in
      let delay = 120 in
      Test.Async.interrupt ~stream ~result ~delay
    );

    testPromise "Start every 10 ms. Call unsubscribe on the next tick of loop" (fun () -> 
      let stream = [|1; 2; 3; 4|] |> Stream.Async.of_array ~delay:10 in
      let result = [||] in
      let delay = 0 in
      Test.Async.interrupt ~stream ~result ~delay
    );
  )

