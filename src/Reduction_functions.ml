module PA = Smtlib_utils.V_2_6.Ast
open R1inline
open R2rewrite
open R3flatten
open R4normalize
open R5reduce_rules
open R6reduce_axioms
open Z3_utils
open Context
exception UnsupportedQuery of string

let full_reduction stmts =
  let start_stmts, is = inline_statements stmts in
  (* print_string "inline done \n"; *)
  let rs = rewrite_statements start_stmts is in
  (* print_string "rewrite done \n"; *)
  let fs = flatten_statements rs in 
  (* print_string "flatten done \n"; *)
  let ns = normalize_statements fs in 
  (* print_string "normalize done \n"; *)
  let rrs = reduce_rule_statements ns in 
  (* print_string "reduce_rule done \n"; *)
  let depths_list, ras = reduce_axioms_with_depths rrs in 
  (* print_string "reduce_axioms done \n"; *)
  let result, _, _ ,_, _ = evaluate_stmts_from_scratch ras in
  (* let () = Format.eprintf "@[<hv>%a@]@." (PA.pp_list PA.pp_stmt) (stmt_to_statements ras) in *)
  (* print_string (Z3.Solver.to_string solver); *)
  (depths_list, result) 


let full_reduction_without_depths stmts = 
  let _, reduced_stmts = full_reduction stmts in 
  reduced_stmts


  (*Some Functions to do an Iterative approach instead*)

  let iterative_reduction stmts =
    let start_stmts, is = inline_statements stmts in
    (* print_string "inline done \n"; *)
    let rs = rewrite_statements start_stmts is in
    (* print_string "rewrite done \n"; *)
    let fs = flatten_statements rs in 
    (* print_string "flatten done \n"; *)
    let ns = normalize_statements fs in 
    (* print_string "normalize done \n"; *)
    let rrs = reduce_rule_statements ns in 
    (* print_string "reduce_rule done \n"; *)
    let depths_list, _ = generate_depths () in
    get_general_adt_vars rrs; (* This creates a list with (adts, variables for that adt) in Context*)
    let tester_keys = StrTbl.keys_list Ctx.t.adt_with_all_variables in
    let tester_axioms = generate_tester_axioms tester_keys in
    let second_result, context, solver, sorts, func_decls  = evaluate_stmts_from_scratch (rrs @ tester_axioms)  in
    if (second_result = "unsat") then (("solved with tester axioms, but not ayclicality", "") :: depths_list, second_result)
    else (
      let acyclicality_keys = StrTbl.keys_list Ctx.t.adt_with_depth_variables in
      let _ = generate_acyclicality_axioms acyclicality_keys 0 (-1) in
      let acyclicality_axioms = Ctx.t.axioms in 
      (* print_int (List.length Ctx.t.axioms); *)
      (* stmt_printer acyclicality_axioms; *)
      let third_result, _, _, _, _ = evaluate_stmts acyclicality_axioms context solver sorts func_decls in
      depths_list, third_result
    )