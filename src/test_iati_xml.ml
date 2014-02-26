
(*
  read foxpath tests ; parse them with regexps

  run test against requiste xml thingy

  execute xquery match (whatever that means)

  read/write postgres
*)

open Postgresql
open Xpath




let handle_test_code test data =
  let acts = Iati_xml.get_activities data in
  List.iter (fun activity ->
	  print_endline (Iati_xml.idstring_of_activity activity);
	  Foxpath.test_data activity test |> string_of_bool |> print_endline) acts
  

let read_whole_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = String.create n in
  really_input ic s 0 n;
  close_in ic;
  s

let get_tests () =
  let user = "iatidq" in
  let dbname = "iatidq" in
  let c = new connection ~dbname ~user () in
  let res = c#exec "select name from test where id > 0 and 
                      test_level = 1 and name like '%exists?' 
                      and id = 62 order by id;" in
(*    Printf.printf "ntuples: %d\nnfields: %d\n" res#ntuples res#nfields; *)

  res#getvalue 0 0

let run_tests filename =
  let test_code = get_tests () in
  let data = read_whole_file filename in
  print_endline test_code;
  handle_test_code (Foxpath.of_string test_code) data

let () =
  (match Sys.argv with
  | [| _; filename |] -> run_tests filename
  | _ -> print_endline "Usage: $0 filename"
  );
  print_endline "";
  flush stdout;
  
