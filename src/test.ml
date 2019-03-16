open Jest


module Async = struct
  open Expect
  let interrupt ~stream ~result ~delay =
    Js.Promise.make (fun ~resolve ~reject:_ ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let _ = unsubscribe () in
        let calls = mock_fn |> MockJs.calls in
        resolve (expect calls |> toEqual result) [@bs]
      ) delay in ()
    )

    let match_to_list ~source ~result ~delay=
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < List.length source then ()
          else resolve (expect calls |> toEqual result) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_list delay
          |> Stream.subscribe subscriber
        in ()
      )
    
    let match_to_array ~source ~result ~delay =
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < Array.length source then ()
          else resolve (expect calls |> toEqual result) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_array delay
          |> Stream.subscribe subscriber
        in ()
      )

      let check_subsequence  ~stream ~result =
        Js.Promise.make (fun ~resolve ~reject:_ ->
          let mock_fn = JestJs.fn (fun _x -> ()) in
          let subscriber = fun x ->
            let _ = MockJs.fn mock_fn x in
            let calls = mock_fn |> MockJs.calls in
            if calls <> result then () else resolve (expect 1 |> toBe 1) [@bs]
          in
          let _unsubscribe = stream |> Stream.subscribe subscriber in ()
      )
end