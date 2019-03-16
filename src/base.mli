module List : sig
  val fold_left : ('b -> 'a -> 'b) -> 'b -> 'a list -> 'b
  val fold_right : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b
  val array_of_list : 'a list -> 'a array
end

module Array : sig
  val fold_left : ('b -> 'a -> 'b) -> 'b -> 'a array -> 'b
  val fold_right : ('a -> 'b -> 'b) -> 'b -> 'a array -> 'b
  val map : ('a -> 'b) -> 'a array -> 'b array
  val filter : ('a -> bool) -> 'a array -> 'a array
  val list_of_array : 'a array -> 'a list
end