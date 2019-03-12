open Jest


let _ = 
  describe "stream later" (fun () -> 
    let open Expect in
    testAsync "delay 200ms" (fun finish -> 
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.later 200 in
      let _ = stream (fun () -> 
        let _ = MockJs.fn mock_fn 1 in
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1|] |> finish
      ) in ()
    );

    testPromise "call unsubscribe" (fun () ->
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let stream = Stream.later 500 in
        let unsubscribe = stream (fun () -> failwith "Unsubscribe must be called`") in
        let _ = unsubscribe () in
        let _ = resolve (expect 1 |> toBe 1) [@bs] in
        ()
      )
    );

    testPromise "late call of unsubscribe" (fun () ->
      Js.Promise.make (fun ~resolve ~reject ->
        let stream = Stream.later 50 in
        let unsubscribe = stream (fun () -> resolve (expect 1 |> toBe 1) [@bs]) in
        let _ = Interop.setTimeout (fun () -> 
          unsubscribe ();
          reject (failwith "Later call of unsubscribe") [@bs]
        ) 300 in 
        ()
      )
    )
  )
