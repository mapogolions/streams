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

    let stream_of_list_match ~source ~result ~delay =
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < List.length source then ()
          else resolve (expect calls |> toEqual result) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_list ~delay
          |> Stream.subscribe subscriber
        in ()
      )
    
    let stream_of_array_match ~source ~result ~delay =
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < Array.length source then ()
          else resolve (expect calls |> toEqual result) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_array ~delay
          |> Stream.subscribe subscriber
        in ()
      )
end