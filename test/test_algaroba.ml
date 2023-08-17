open OUnit2
open Algaroba_lib.Context
open Algaroba_lib.R1inline
(* open Algaroba_lib.R2rewrite *)
open Algaroba_lib.R3flatten
open Algaroba_lib.R4normalize
open Algaroba_lib.R5reduce_rules
(* open Algaroba_lib.R6reduce_axioms
open Algaroba_lib.Z3_utils *)
module PA = Smtlib_utils.V_2_6.Ast

let check pre_reduction post_reduction func =
  let stmt_list_test =
    match
      Smtlib_utils.V_2_6.parse_file
        ( "/Users/amarshah/Desktop/ADT reduction project/GenericReduction/ADTReduction/test/unit_tests/"
        ^ pre_reduction )
    with
    | Ok f -> f
    | Error _ -> print_string "failure!!!" ; []
  in
  let inlined_stmt_list_test =
    func (List.map statement_to_stmt stmt_list_test)
  in
  let stmt_list_solution =
    match
      Smtlib_utils.V_2_6.parse_file
        ( "/Users/amarshah/Desktop/ADT reduction project/GenericReduction/ADTReduction/test/unit_tests/"
        ^ post_reduction )
    with
    | Ok f -> f
    | Error _ -> print_string "failure!!!" ; []
  in
  (inlined_stmt_list_test, stmt_list_solution)

let inline_test1 _ =
  let inlined_stmt_list_test, stmt_list_solution =
    check "T1inline/test1.smt2" "T1inline/test1solution.smt2" inline_statements
  in
  (* stmt_printer (List.map stmt_to_statement inlined_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal inlined_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let inline_test2 _ =
  let inlined_stmt_list_test, stmt_list_solution =
    check "T1inline/test2.smt2" "T1inline/test2solution.smt2" inline_statements
  in
  (* stmt_printer (List.map stmt_to_statement inlined_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal inlined_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let inline_test3 _ =
  let inlined_stmt_list_test, stmt_list_solution =
    check "T1inline/test3.smt2" "T1inline/test3solution.smt2" inline_statements
  in
  (* stmt_printer (List.map stmt_to_statement inlined_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal inlined_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let inline_test4 _ =
  let inlined_stmt_list_test, stmt_list_solution =
    check "T1inline/test4.smt2" "T1inline/test4solution.smt2" inline_statements
  in
  (* stmt_printer (List.map stmt_to_statement inlined_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal inlined_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let flatten_test1 _ =
  let flattend_stmt_list_test, stmt_list_solution =
    check "T2flatten/test1.smt2" "T2flatten/test1solution.smt2"
      flatten_statements
  in
  (* stmt_printer (List.map stmt_to_statement flattend_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let flatten_test2 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T2flatten/test2.smt2" "T2flatten/test2solution.smt2"
      flatten_statements
  in
  (* stmt_printer (List.map stmt_to_statement flattend_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let flatten_test3 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T2flatten/test3.smt2" "T2flatten/test3solution.smt2"
      flatten_statements
  in
  (* stmt_printer (List.map stmt_to_statement flattend_stmt_list_test);
     stmt_printer stmt_list_solution; *)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let flatten_test4 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T2flatten/test4.smt2" "T2flatten/test4solution.smt2"
      flatten_statements
  in
  (* stmt_printer (List.map stmt_to_statement
     flattend_stmt_list_test);stmt_printer stmt_list_solution;*)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let normalize_test1 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T3nnf/test1.smt2" "T3nnf/test1solution.smt2" normalize_statements
  in
  (* stmt_printer (List.map stmt_to_statement
     flattend_stmt_list_test);stmt_printer stmt_list_solution;*)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let combined_test1 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T3nnf/test2.smt2" "T3nnf/test2solution.smt2" (fun x ->
        normalize_statements (flatten_statements (inline_statements x)) )
  in
  (* stmt_printer (List.map stmt_to_statement
     flattend_stmt_list_test);stmt_printer stmt_list_solution;*)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let reduce_rules_test1 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T4reduce_rules/test1.smt2" "T4reduce_rules/test1solution.smt2"
      (fun x -> reduce_rule_statements x )
  in
  (* stmt_printer (List.map stmt_to_statement
     flattend_stmt_list_test);stmt_printer stmt_list_solution;*)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let reduce_rules_test2 _ =
  reset_ctx () ;
  (*need to reset the context beforehand*)
  let flattend_stmt_list_test, stmt_list_solution =
    check "T4reduce_rules/test2.smt2" "T4reduce_rules/test2solution.smt2"
      (fun x -> reduce_rule_statements x )
  in
  (* stmt_printer (List.map stmt_to_statement
     flattend_stmt_list_test);stmt_printer stmt_list_solution;*)
  assert_equal flattend_stmt_list_test
    (List.map statement_to_stmt stmt_list_solution)

let suite =
  "Reduction"
  >::: [ "test inline with constants" >:: inline_test1
       ; "test inline with functions" >:: inline_test2
       ; "test inline with lets" >:: inline_test3
       ; "test inline with lets with variable conflict" >:: inline_test4
       ; "test basic flatten" >:: flatten_test1
       ; "test flatten with user-define functions and compound expressions"
         >:: flatten_test2
       ; "test ITE statements" >:: flatten_test3
       ; "test implication" >:: flatten_test4
       ; "test NNF" >:: normalize_test1
       ; "testing inline, flatten, normalize" >:: combined_test1
       ; "testing reduce_rules on code with no ADTs" >:: reduce_rules_test1
       ; "testing full reduce_rules" >:: reduce_rules_test2 ]
(*TODO: make finding tests/solutions automatc*)

let () = run_test_tt_main suite