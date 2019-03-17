open Jest


let _ = 
  describe "stream later" (fun () -> 
    testPromise "call unsubscribe" (fun () ->
      let stream = Stream.later 20 in
      let result = [||] in
      let delay = 0 in
      Test.Async.interrupt ~stream ~result ~delay
    );
  )
