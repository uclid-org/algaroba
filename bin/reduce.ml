module PA = Smtlib_utils.V_2_6.Ast
open Algaroba_lib.Context
open Algaroba_lib.R1inline
open Algaroba_lib.R2rewrite
open Algaroba_lib.R3flatten
open Algaroba_lib.R4normalize
open Algaroba_lib.R5reduce_rules
open Algaroba_lib.R6reduce_axioms
open Algaroba_lib.Z3_utils
open Algaroba_lib.Bound



(* Substitute a term for a variable in a term *)

let _ = reset_ctx () (*need to reset the context beforehand*)
let stmt_list = begin match (Smtlib_utils.V_2_6.parse_file "test/QF_DT2/20172804-Barrett/barrett-jsat/tests/v3/v3l30054.cvc.smt2") with
|Ok(f) -> f
|Error(_) -> print_string "failure!!!"; []
end

(*Printing the AST*)
(* Format.printf "@[<hv>%a@]@." (PA.pp_list PA.pp_stmt) stmt_list; *)

(* let () = Format.printf "@[<hv>%a@]@." (PA.pp_list PA.pp_stmt) stmt_list *)
let start_stmts, inlined_stmt_list = inline_statements (List.map statement_to_stmt stmt_list) 
let rewrite_statements = (rewrite_statements start_stmts inlined_stmt_list)

(* let _ = print_int (find_largest_constant inlined_stmt_list) *)
(* let _ = (reduce_rule_statements (normalize_statements (flatten_statements inlined_stmt_list)))
let _  = generate_depths () *)

(* let () = print_string_list (List.map string_of_int (List.nth depths 0)) *)



let () = Format.printf "@[<hv>%a@]@." (PA.pp_list PA.pp_stmt) (stmt_to_statements rewrite_statements)