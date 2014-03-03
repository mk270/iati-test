
exception Format_unrecognised
exception Not_implemented

type format =
| Exists of string

type format_t =
| T_Exists

type t = {
  fp_text : string;
  fp_format : format;
}

let arity = function
	| T_Exists -> 1

let matchers = 
	[
		("(\\S*) exists\\?", T_Exists) 
	] |> List.map (fun (re, fmt) -> (Pcre.regexp re, fmt))
		
let infer_format text =
	let rec match_format = function
		| [] -> raise Format_unrecognised
		| (rex, fmt) :: tl -> 
			try let substrings = Pcre.exec ~rex ~pos:0 text	in 
				let n = Pcre.num_of_subs substrings in
					assert (n - 1 = arity fmt);
					match fmt with
					| T_Exists -> 
						let xpath = Pcre.get_substring substrings 1 in
							Exists xpath
(*					| _ -> raise Not_found (* same as Pcre.exec *) *)
			with Not_found -> match_format tl
	in
		match_format matchers

let of_string text =
	let fmt = infer_format text in
		{
			fp_text = text;
			fp_format = fmt
		}

let positive = function
	| -1 | 0 -> false
	| _ -> true

let test_exists xpath data = 
	let s = Xml.to_string data in
	("//" ^ xpath) |> Xpath.xpath_matching s |> positive

let test_data data = function
	| { fp_format = Exists xpath } -> test_exists xpath data
(*	| _ -> raise Not_implemented *)
	
let string_of_format = function
	| Exists s -> Printf.sprintf "<format: \"%s\">" s

let to_string fp =
	Printf.sprintf "<< foxpath: %s %s >>" fp.fp_text (string_of_format fp.fp_format)
