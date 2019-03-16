open Jest


module Async = struct
  open Expect
  let interrupt ~(stream : 'a Stream.t) ~(exhaust : 'a array) ~(delay : int) =
    Js.Promise.make (fun ~resolve ~reject:_ ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let unsubscribe = stream (MockJs.fn mock_fn) in
      let _ = Interop.setTimeout (fun () ->
        let _ = unsubscribe () in
        let calls = mock_fn |> MockJs.calls in
        resolve (expect calls |> toEqual exhaust) [@bs]
      ) delay in ()
    )

    let success_for_list ~(source : 'a list) ~(exhaust : 'a array) ~(delay : int)
      = Js.Promise.make (fun ~resolve ~reject:_ ->
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < List.length source then ()
          else resolve (expect calls |> toEqual exhaust) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_list delay
          |> Stream.subscribe subscriber
        in ()
      )
    
    let success_for_array ~(source : 'a array) ~(exhaust : 'a array) ~(delay : int) =
      Js.Promise.make (fun ~resolve ~reject:_ ->
        let mock_fn = JestJs.fn (fun _x -> ()) in
        let subscriber = fun x ->
          let _ = MockJs.fn mock_fn x in
          let calls = mock_fn |> MockJs.calls in 
          if Array.length calls < Array.length source then ()
          else resolve (expect calls |> toEqual exhaust) [@bs]
        in
        let _unsubscribe = source
          |> Stream.Async.of_array delay
          |> Stream.subscribe subscriber
        in ()
      )
end