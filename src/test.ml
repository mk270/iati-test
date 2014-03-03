
type test_level = 
  | Activity_level
  | File_level
  | Transaction_level
  | Organisation_level

type t =
	{
		test_fp : Foxpath.t;
		test_level : test_level;
	}


FIXME: transaction_level repeated below at 0 and 3

let level_of_int = function
	| 0 -> Transaction_level
	| 1 -> Activity_level
	| 2 -> File_level
	| 3 -> Transaction_level
	| _ -> assert false

let create fp level =
	{
		test_fp = fp;
		test_level = level_of_int level
	}
		
let foxpath_of_test t = t.test_fp

let run_activity_test test activity =
  print_endline (Activity.to_idstring activity);
  Printf.printf "Foxpath: [%s]\n" (Foxpath.to_string test.test_fp);
  Foxpath.test_data (Activity.as_xml activity) (foxpath_of_test test) |> 
  string_of_bool |> 
  print_endline
