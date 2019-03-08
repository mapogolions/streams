open Jest


let _ =
  describe "My first test in ocaml and javascript" (fun () ->
    let open Expect in
    test "to be" (fun () -> 
      expect (1 + 3) |> toBe 4);

    test "to be close to" (fun () -> 
      expect (1.1 +. 0.2) |> toBeCloseTo 1.3)
  )

let _ =
  describe "Expect"
    (fun ()  ->
       let open Expect in
         test "toBe" (fun ()  -> (expect (1 + 2)) |> (toBe 3)))
let _ =
  describe "Expect.Operators"
    (fun ()  ->
       let open Expect in
         let open! Expect.Operators in
           test "==" (fun ()  -> (expect (1 + 2)) == 3))