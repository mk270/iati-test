
(*
  save to db

  handle all 17 foxpath variants

  handle all 4 test levels
*)

open Postgresql
open Xpath


let read_whole_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = String.create n in
  really_input ic s 0 n;
  close_in ic;
  s

let db_connection () =
  let user = "iatidq" in
  let dbname = "iatidq" in
     new connection ~dbname ~user ()

let get_db_cell (c : Postgresql.connection) sql i1 =
	let params = [| (string_of_int i1) |] in
    let res = c#exec ~params sql in
    res#getvalue 0 0

let get_db_results (c : Postgresql.connection) sql =
	let res = c#exec sql in
    res#get_all

let get_tests_info () =
  let c = db_connection () in
  get_db_results c "select name from test where id > 0 and 
                      test_level = 1 and name like '%exists?' 
                      order by id;"

let run_test text test_code =
  let run_test = 
	  Test.create (Foxpath.of_string test_code) 1 |>
	  Test.run_activity_test
  in
	Activity.all_in_string text |>
    List.iter run_test

let test_file_data text tests =
  List.iter (fun test -> run_test text test) tests

let activity_tests () =
(*  let test_ids = [ 62; 59; ] in
    List.map get_test test_ids
*)
  get_tests_info () |>
  Array.map (fun i -> i.(0)) |>
  Array.to_list

let run_tests filename =
  let text = read_whole_file filename
  and tests = activity_tests () in
    test_file_data text tests

let cleanup_after_output () =
  print_endline "";
  flush stdout

let () =
  (match Sys.argv with
  | [| _; filename |] -> run_tests filename
  | _ -> print_endline "Usage: $0 filename"
  );
  cleanup_after_output ()
  
