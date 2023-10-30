module PA = Smtlib_utils.V_2_6.Ast
open Core
open Algaroba_lib.Context
open Algaroba_lib.R1inline
open Algaroba_lib.R2rewrite
open Algaroba_lib.R3flatten
open Algaroba_lib.R4normalize
open Algaroba_lib.R5reduce_rules
open Algaroba_lib.R6reduce_axioms
open Algaroba_lib.Z3_utils
open Algaroba_lib.Bound

let usage_msg = "algaroba2 <query> [options]"

let input_file = ref ""

let output_file = ref ""
let measure = ref false

let depths_based_acyclicality = ref false
let acyclicality_pause = ref (-1)

let anon_fun filename = input_file := filename

let speclist =
  [ ("-o", Arg.Set_string output_file, "Write to an output file")
  ; ("-t", Arg.Int set_timeout, "Set a timeout for solving (in milliseconds)")
  ; ( "--z3-simplifier"
    , Arg.String set_simplifier
    , "Use a Z3 simplifier."
    )
  ; ("--dont-depth-based-acyclicality-pause",
    Arg.Set depths_based_acyclicality,
    "Normally, we do unrolling at half of the average depth. If set to true we don't do this")
  ; ( "--acyclicality-pause"
    , Arg.Set_int acyclicality_pause
    , "Point in depth to pause and check" )
  ; ("--measure", Arg.Set measure, "Measure time spent in each step")
  ; ( "--global-z3-parameter"
    , Arg.String set_global_parameter
    , "Use a Z3 global parameter." )
  ; ( "--set-z3-solver-flag"
    , Arg.String set_solver_flag
    , "Set a Z3 solver flag to true." )
  ; ( "--clear-z3-solver-flag"
    , Arg.String clear_solver_flag
    , "Set a Z3 solver flag to false." )
  ; ( "--assert-conjunctions"
    , Arg.Set assert_conjunctions
    , "Rewrite top-level conjunctions to assertions (default: false)" ) 
  ; ( "--simplify-ite"
    , Arg.Set rewrite_ite
    , "Rewrite if-then-else statements to use normal boolean operations  (default: false)" )
  ; ( "--constant-prop"
    , Arg.Set constant_prop
    , "Does propagation for variables set to symbolic constants  (default: false)" )
  ; ( "--inline-constants"
    , Arg.Set inline_constants
    , "Decides whether to inline constants (WARNING: choosing true is not sound as currently implemented) (default: false)" )
  ; ( "--use-enum-test-axioms"
    , Arg.Bool set_enum_test_axioms
    , "Decides whether to use the enum tester axioms or not (default: true)" )
    ; ( "--print-depths"
    , Arg.Set print_depths
    , "Decides whether to print depths to stderr (default: false)" )]
   
  let print_time before words =
    if !measure then
      Printf.printf "  - %s: %s\n%!" words
        (Core.Time.Span.to_short_string
            (Core.Time.diff (Core.Time.now ()) before) )


  let () =
    Arg.parse speclist anon_fun usage_msg ;
    try
      match !input_file with
      | "" -> failwith "No input file provided"
      | _ -> (
          if !measure then Printf.printf "Mesuring time:\n" ;
          let before = Core.Time.now () in
          let stmt_list =
            match Smtlib_utils.V_2_6.parse_file !input_file with
            | Ok f -> f
            | Error _ -> []
          in
          print_time before "Parsing time" ;
          let before = Core.Time.now () in
          let start_is, is = inline_statements (List.map stmt_list ~f:statement_to_stmt) in
          print_time before "Inline time" ;
          let before = Core.Time.now () in
          let rs = rewrite_statements start_is is in
          print_time before "Rewrite time" ;
          let before = Core.Time.now () in
          let fs = flatten_statements rs in
          print_time before "Flatten time" ;
          let before = Core.Time.now () in
          let ns = normalize_statements fs in
          print_time before "Normalize time" ;
          let before = Core.Time.now () in
          let rrs = reduce_rule_statements ns in
          print_time before "Reduce time" ;
          begin match !output_file with
          | "" -> 
              (let before = Core.Time.now () in
              let _, depths_list = generate_depths () in
              print_time before "Generate depths time" ;
              let before = Core.Time.now () in
              get_general_adt_vars rrs ;
              (* This creates a list with (adts, variables for that adt) in Context*)
              let tester_keys = StrTbl.keys_list Ctx.t.adt_with_all_variables in
              let tester_axioms = generate_tester_axioms tester_keys in
              let finite_adt_axioms = generate_finite_adt_axioms () in
              print_time before "Generate tester axioms time" ;
              let before = Core.Time.now () in
              let first_result, context, solver, sorts, func_decls = evaluate_stmts_from_scratch (rrs @ tester_axioms @ finite_adt_axioms) in
              print_time before "First solve time (no acyclicality)" ;
              begin match first_result with
              | "unsat" -> print_string first_result
              | _ -> (
                      let evaluate_unsat_result solver depth = 
                        let acyclicality_keys = StrTbl.keys_list Ctx.t.adt_with_depth_variables in
                        let _ = generate_acyclicality_axioms acyclicality_keys (depth - 1) depth in
                        let acyclicality_axioms = Ctx.t.axioms in
                        let before = Core.Time.now () in
                        let result, _, _, _, _= evaluate_stmts acyclicality_axioms context solver sorts func_decls in
                        print_time before ("UNSAT solve iteration " ^ (string_of_int depth)) ;
                        begin match result with
                          | "unsat" -> (*let _ = List.map (Z3.Solver.get_assertions solver) ~f:(fun x -> print_string (Z3.Expr.to_string x)) in*)
                                       print_string result; "unsat"
                          | _ -> "sat"
                        end
                      in
                      let evaluate_sat_result solver depth = 
                          let bounds =
                          bound
                            (List.concat_map
                                ~f:(fun (ls, t) ->
                                  List.filter_map
                                    ~f:(fun x -> Some (x, t)) (*TODO: the old filter is unsound, but this filter could be inefficient, need to figure out a better way to do this*)
                                    (* ~f:(fun x ->
                                      if
                                        String.is_prefix ~prefix:"contrived_variable"
                                          x
                                      then None
                                      else Some (x, t)) *)
                                    ls )
                                (StrTbl.values_list Ctx.t.adt_with_all_variables) )
                            (depth - 1)
                          in
                          let bounds = [PA.Stmt_assert bounds] in
                          print_time before "Bounding time" ;
                          let before = Core.Time.now () in
                          Z3.Solver.push solver ;
                          let result, _, _, _, _ = evaluate_stmts bounds context solver sorts func_decls in
                          print_time before ("SAT solve iteration " ^ (string_of_int depth)) ;
                          begin match result with 
                            | "sat" -> (*let _ = List.map (Z3.Solver.get_assertions solver) ~f:(fun x -> print_endline ("(assert " ^(Z3.Expr.to_string x) ^ ")")) in *)
                                        print_string result; "sat"
                            | _ -> Z3.Solver.pop solver 1; "unsat"
                          end
                        in
                      let rec evaluate_alternative current_depth max_depth =
                        (* if (current_depth > max_depth) then (print_string "unsat") *)
                        (* else ( *)
                          begin match (evaluate_unsat_result solver current_depth) with 
                            | "unsat" -> ()
                            | _ -> begin match (evaluate_sat_result solver current_depth) with 
                                        | "sat" -> ()
                                        | _ -> evaluate_alternative (current_depth + 1) max_depth
                                       end
                           end
                        (* ) *)
                        in
                        evaluate_alternative 1 (max_elt depths_list) (*TODO: make each depth ADT specific*)
              )
                end
              )
          | _ ->
              (let oc = Out_channel.create !output_file in
                let fmt = Format.formatter_of_out_channel oc in
                let before = Core.Time.now () in
                let _, ras = reduce_axioms_with_depths rrs in
                print_time before "Reduce axioms time" ;
                Format.fprintf fmt "@[<hv>%a@]" (PA.pp_list PA.pp_stmt)
                  (stmt_to_statements ras) ;
                Out_channel.close oc ) ;
              exit 0 
          end)
    with Failure s -> print_endline s ; exit 1