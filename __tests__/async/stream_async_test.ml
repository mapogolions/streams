open Jest


let _ = 
  describe "stream async" (fun () ->
    testPromise "Start every 10 ms" (fun () ->
      Test.Async.match_to_list
        ~source:["third"; "second"; "first"]  
        ~result:[|"third"; "second"; "first"|] 
        ~delay:10
    );

    testPromise "Start every 50 ms. Call unsubscribe ot the 120th ms" (fun () -> 
      Test.Async.interrupt 
        ~stream:(Stream.Async.of_list 50 [1; 2; 3]) 
        ~result:[|1; 2|] 
        ~delay:120
    );

    testPromise "Start every 10 ms. Call unsubscribe on the next tick of loop" (fun () -> 
      Test.Async.interrupt 
        ~stream:(Stream.Async.of_array 10 [|1; 2; 3; 4|]) 
        ~result:[||] 
        ~delay:0
    );
  )

