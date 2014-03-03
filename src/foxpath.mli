
type t

val of_string : string -> t
val test_data : Xml.xml -> t -> bool
val to_string : t -> string
