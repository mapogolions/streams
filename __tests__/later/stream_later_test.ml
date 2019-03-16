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
        let unsubscribe = stream (fun () -> failwith "The unsubscribe function must be called`") in
        let _ = unsubscribe () in
        let _ = resolve (expect 1 |> toBe 1) [@bs] in ()
      )
    );

    (* testPromise "Drop testAsync Pattern" (fun () ->
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let source = [1; 2; 3] in
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < List.length source then ()
          else resolve (expect calls |> toEqual [|1; 2; 3|]) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_list 100
          |> Stream.subscribe subscriber
        in ()
      )
    ); *)

    testPromise "call of unsubscribe function after stream gave all data" (fun () ->
      Js.Promise.make (fun ~resolve ~reject ->
        let stream = Stream.later 10 in
        let unsubscribe = stream (fun () -> resolve (expect 1 |> toBe 1) [@bs]) in
        let _ = Interop.setTimeout (fun () -> 
          let _ = unsubscribe () in reject (failwith "error") [@bs]
        ) 100 in ()
      )
    );
  )
