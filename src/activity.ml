
type t = {
	activity_xml : Xml.xml;
}

exception Duplicate_iati_identifiers

let tag_is tag = function
	| Xml.Element (tagname, _, _) -> tag = tagname
	| _ -> false

let make_activity x =
	{
		activity_xml = x
	}

let all_in_string s =
  let is_relevant = tag_is "iati-activity" in
  let root = Xml.parse_string s in
    Xml.children root |>
	List.filter is_relevant |>
	List.map make_activity

let to_idstring a =
	let is_id = tag_is "iati-identifier" in
    let id_nodes =
		Xml.children a.activity_xml |>
		List.filter is_id
	in
		match id_nodes with
		| [elt] -> Xml.children elt |> List.hd |> Xml.pcdata
		| _ -> raise Duplicate_iati_identifiers

let as_xml a = a.activity_xml
