let s1 = Stream.of_item "hello"
let s2 = Stream.of_list ["one"; "two"; "tree"]
let s3 = Stream.of_array [| "first"; "second"; "third"; "fourth" |]
let s4 = Stream.of_array_iter [| 1; 2; 3; 4 |]
let s5 = Stream.of_list_iter ["Dmitry Bale"; "Dina Blin"; "Alina Rina Ruinnna"]
(* let s2 = Stream.of_array [| "first"; "second"; "third"; "fourth" |]
let prepend_s1 = Stream.prepend "Before" s1
let s3 = Stream.empty ()
let s5 = Stream.prepend "hell" s3 *)

let s6 = s4 |> Stream.filter (fun x -> x mod 2 = 0)
let s7 = Stream.async_of_list Stream.later 1000 ["one"; "two"; "three"; "four"; "five"; "six"; "seven"]
let unsubscribe = s7 (fun x -> print_endline x)
let _ = Stream.setTimeout (fun () -> unsubscribe ()) 3500

(* let _ = s6 (fun x -> print_endline (string_of_int x)) *)

(* let _ = s5 (fun x -> print_endline x) *)