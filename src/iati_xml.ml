exception Duplicate_iati_identifiers

let tag_is tag = function
	| Xml.Element (tagname, _, _) -> tag = tagname
	| _ -> false

let get_activities text = 
  let is_relevant = tag_is "iati-activity" in
  let root = Xml.parse_string text in
    Xml.children root |>
    List.filter is_relevant |>
	List.map Xml.to_string

let idstring_of_activity text =
	let is_id = tag_is "iati-identifier" in
    let id_nodes =
		Xml.parse_string text |>
		Xml.children |>
		List.filter is_id
	in
		match id_nodes with
		| [elt] -> Xml.children elt |> List.hd |> Xml.pcdata
		| _ -> raise Duplicate_iati_identifiers
		
