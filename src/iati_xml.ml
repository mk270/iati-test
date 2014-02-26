
let tag_is tag = function
	| Xml.Element (tagname, _, _) -> tag = tagname
	| _ -> false
