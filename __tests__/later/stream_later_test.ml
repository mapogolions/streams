open Jest


let _ = 
  describe "stream later" (fun () -> 
    testPromise "call unsubscribe" (fun () ->
      Test.Async.interrupt
        ~stream:(Stream.later 500)
        ~result:[||]
        ~delay:0
    );
  )
