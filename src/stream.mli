type 'a t = ('a -> unit) -> unit -> unit

val noop : unit -> unit
val empty_stream : 'a t
val empty : unit -> 'a t
val of_item : 'a -> 'a t
val later : int -> unit t
val prepend : 'a -> 'a t -> 'a t
val scan : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b t
val skip : int -> 'a t -> 'a t
val skip_while : ('a -> bool) -> 'a t -> 'a t
val chain : ('a -> 'b t) -> 'a t -> 'b t
val chain_latest : ('a -> 'b t) -> 'a t -> 'b t
val take : int -> 'a t -> 'a t
val take_while : ('a -> bool) -> 'a t -> 'a t
val subscribe : ('a -> unit) -> 'a t -> (unit -> unit)
val of_list : 'a list -> 'a t
val of_list_reverse : 'a list -> 'a t
val of_array : 'a array -> 'a t
val of_array_reverse : 'a array -> 'a t
val map : ('a -> 'b) -> 'a t -> 'b t
val filter : ('a -> bool) -> 'a t -> 'a t
val ap : ('a -> 'b) t  -> 'a t -> 'b t

module Async : sig
  val of_list : ?delay:int -> 'a list -> 'a t
  val of_array : ?delay:int -> 'a array -> 'a t
end