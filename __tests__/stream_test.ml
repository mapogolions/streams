open Jest


let _ = 
  describe "stream later" (fun () -> 
    let open Expect in
    testAsync "delay = 200ms" (fun finish -> 
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.later 500 in
      let _ = stream (fun () -> 
        let _ = MockJs.fn mock_fn 1 in
        let calls = mock_fn |> MockJs.calls in
        expect calls |> toEqual [|1|] |> finish
      ) in ()
    )
  )

let _ =
  describe "stream scan" (fun () -> 
    let open Expect in 
    test "partial sums" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.scan (fun seed x -> seed + x) 0 (Stream.of_list [-1; 2; -2; 3]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|0; -1; 1; -1; 2|]
    );
    test "partial products" (fun () -> 
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.scan (fun seed x -> seed * x) 1 (Stream.of_array [|1; 2; 3; 4|]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 1; 2; 6; 24|]
    )
  )

let _ =
  describe "stream filter" (fun () -> 
    let open Expect in 
    test "stay integers that grather than 0" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.filter (fun x -> x > 0) (Stream.of_list [-1; 2; -2; 3]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|2; 3|]
    )
  )

let _ =
  describe "stream map" (fun () -> 
    let open Expect in 
    test "integers are multiplied by 10" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map (fun x -> x * 10) (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|10; 20; 30; 40|]
    );
    test "strings are mapped to integers" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.map String.length(Stream.of_list ["1"; "12"; "123"]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3|]
    )
  )

let _ =
  describe "skip `n` elements" (fun () -> 
    let open Expect in 
    test "if `n` is greater then zero and less than length of sequence" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip 2 (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|3; 4|]
    );
    test "if `n` less than zero" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip (-1) (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|1; 2; 3; 4|]
    );
    test "if `n` is greater than length of sequence" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.skip 100 (Stream.of_list [1; 2; 3; 4]) in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [||]
    )
  )

let _ =
  describe "stream of array" (fun () -> 
    let open Expect in 
    test "usual order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_array [|"first"; "second"; "third"; "fourth"|] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"first"; "second"; "third"; "fourth"|]
    );
    test "reverse order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_array_reverse [|"first"; "second"; "third"; "fourth"|] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"fourth"; "third"; "second"; "first"|]
    )
  )

let _ =
  describe "stream of list" (fun () -> 
    let open Expect in 
    test "usual order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_list ["first"; "second"; "third"; "fourth"] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"first"; "second"; "third"; "fourth"|]
    );
    test "reverse order" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_list_reverse ["first"; "second"; "third"; "fourth"] in
      let _ = stream (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|"fourth"; "third"; "second"; "first"|]
    );
  )


let _ =
  describe "stream prepend" (fun () -> 
    let open Expect in 
    test "chain of integers" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let stream = Stream.of_item 10 in
      let stream1 = Stream.prepend 9 stream in
      let stream2 = Stream.prepend 8 stream1 in
      let _ = stream2 (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|8; 9; 10|]
    );
  )

let _ =
  describe "stream of item" (fun () -> 
    let open Expect in 
    test "item has type integer" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _ = Stream.of_item 10 (MockJs.fn mock_fn) in
      let _ = Stream.of_item 0 (MockJs.fn mock_fn) in
      let _ = Stream.of_item (-1) (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [|10; 0; -1|]
    );
    test "item has type string" (fun () ->
      let mock_fn = JestJs.fn (fun _x -> ()) in
      let _ = Stream.of_item "" (MockJs.fn mock_fn) in
      let _ = Stream.of_item "some text" (MockJs.fn mock_fn) in
      let calls = mock_fn |> MockJs.calls in
      expect calls |> toEqual [| ""; "some text"|]
    )
  )

