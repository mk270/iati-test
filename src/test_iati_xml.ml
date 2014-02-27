
(*
  read foxpath tests ; parse them with regexps

  run test against requiste xml thingy

  execute xquery match (whatever that means)

  read/write postgres
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

let get_test () =
  let c = db_connection () in
  get_db_cell c "select name from test where id > 0 and 
                      test_level = 1 and name like '%exists?' 
                      and id = $1 order by id;" 62

let run_test text test_code =
  let run_test = 
	  Test.create (Foxpath.of_string test_code) 1 |>
	  Test.run_activity_test
  in
	Activity.all_in_string text |>
    List.iter run_test

let run_tests filename =
  let text = read_whole_file filename in
    [ get_test () ] |>
    List.iter (fun test -> run_test text test)

let () =
  (match Sys.argv with
  | [| _; filename |] -> run_tests filename
  | _ -> print_endline "Usage: $0 filename"
  );
  print_endline "";
  flush stdout
  
