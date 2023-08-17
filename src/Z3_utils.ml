module PA = Smtlib_utils.V_2_6.Ast
open Context
open Z3.Expr
open Z3.Boolean
open Z3.FuncDecl
open Z3.Solver
open Containers

exception UnsupportedQuery of string

module StrTbl = CCHashtbl.Make (CCString)

let counter = ref 0

let ctx_params = ref []

let global_params = ref []

let solver_flags = ref []

let simplifiers = ref []

let convert_smt_to_z3_ty context sorts (ty : PA.ty) =
  match (ty : PA.ty) with
  | Ty_bool -> Z3.Boolean.mk_sort context
  | Ty_real -> Z3.Arithmetic.Real.mk_sort context
  | Ty_app (s, []) -> (
    match Hashtbl.find_opt sorts s with
    | Some sort -> sort
    | None -> raise (UnsupportedQuery "trying to use a sort that does not exist")
    )
  | Ty_app _ ->
      raise (UnsupportedQuery "We do not currently support Polymorphic types")
  | Ty_arrow _ -> raise (UnsupportedQuery "We do not currently support Ty_arrow")

let rec convert_smt_to_z3_term context func_decls sorts (term : PA.term) : expr
    =
  match term with
  | True -> mk_true context
  | False -> mk_false context
  | Const v -> (
    match Hashtbl.find_opt func_decls v with
    | Some fun_decl -> Z3.Expr.mk_const_s context v (get_range fun_decl)
    | None ->
        raise (UnsupportedQuery ("using an undefined constant: " ^ v)) )
  | Arith (op, terms) -> (
    match op with
    | Leq ->
        Z3.Arithmetic.mk_le context
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 0))
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 1))
    | Lt ->
        Z3.Arithmetic.mk_lt context
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 0))
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 1))
    | Geq ->
        Z3.Arithmetic.mk_ge context
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 0))
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 1))
    | Gt ->
        Z3.Arithmetic.mk_gt context
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 0))
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 1))
    | Add ->
        Z3.Arithmetic.mk_add context
          (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
    | Minus ->
        Z3.Arithmetic.mk_sub context
          (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
    | Mult ->
        Z3.Arithmetic.mk_mul context
          (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
    | Div ->
        Z3.Arithmetic.mk_div context
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 0))
          (convert_smt_to_z3_term context func_decls sorts (List.nth terms 1)) )
  | App (s, terms) -> (
    match Hashtbl.find_opt func_decls s with
    | Some func_decl ->
        mk_app context func_decl
          (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
    | None ->
        raise
          (UnsupportedQuery
             "Trying to use a function that has not been declared" ) )
  | HO_app _ -> raise (UnsupportedQuery "we do not support HO_App yet")
  | Match _ ->
      raise
        (UnsupportedQuery "we should have simplified Match statements by now")
  | Eq (a, b) ->
      mk_eq context
        (convert_smt_to_z3_term context func_decls sorts a)
        (convert_smt_to_z3_term context func_decls sorts b)
  | And terms ->
      Z3.Boolean.mk_and context
        (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
  | Or terms ->
      Z3.Boolean.mk_or context
        (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
  | Not term ->
      Z3.Boolean.mk_not context
        (convert_smt_to_z3_term context func_decls sorts term)
  | Distinct terms ->
      mk_distinct context
        (List.map (convert_smt_to_z3_term context func_decls sorts) terms)
  | Cast _ -> raise (UnsupportedQuery "Don't currently hace Z3 Cast support")
  | Forall _ -> raise (UnsupportedQuery "We do not support Forall")
  | Exists _ -> raise (UnsupportedQuery "We don not support Exists")
  | Attr _ -> raise (UnsupportedQuery "Don't currently hace Z3 Attr support")
  | If (t1, t2, t3) ->
      Z3.Boolean.mk_ite context
        (convert_smt_to_z3_term context func_decls sorts t1)
        (convert_smt_to_z3_term context func_decls sorts t2)
        (convert_smt_to_z3_term context func_decls sorts t3)
  | Let _ -> raise (UnsupportedQuery "We should have already simplified Let")
  | Is_a _ ->
      raise (UnsupportedQuery "We should have already simplified is-a")
      (* tester: is-constructor(term) *)
  | Imply (t1, t2) ->
      Z3.Boolean.mk_implies context
        (convert_smt_to_z3_term context func_decls sorts t1)
        (convert_smt_to_z3_term context func_decls sorts t2)
  | _ ->
      (*print_string "here"; stmt_printer [(PA.Stmt_assert term)];
        Z3.Boolean.mk_true context *)
      raise (UnsupportedQuery "We should have already simplified this term")

let rec convert_smt_to_z3 context solver (stmts : PA.stmt list)
    (sorts : (string, Z3.Sort.sort) Hashtbl.t)
    (func_decls : (string, func_decl) Hashtbl.t) =
  match stmts with
  | stmt :: rest -> (
    match (stmt : PA.stmt) with
    (* | Stmt_set_logic s -> let set_logic_symbol = mk_string context s in let
       new_solver = Z3.Solver.mk_solver context (Some set_logic_symbol) in
       convert_smt_to_z3 context new_solver rest sorts func_decls *)
    (*WILL JUST HAVE THIS ALWAYS BE QFUF FOR RIGHT NOW *)
    (* | Stmt_set_info (s1, s2) -> () *)
    (* | Stmt_set_option string_list -> () *)
    | Stmt_decl_sort (s, _) ->
        let (sort_symbol : Z3.Symbol.symbol) = Z3.Symbol.mk_string context s in
        let (new_sort : Z3.Sort.sort) =
          Z3.Sort.mk_uninterpreted context sort_symbol
        in
        (*TODO: WHAT do i actually do with this sort??*)
        Hashtbl.add sorts s new_sort ;
        convert_smt_to_z3 context solver rest sorts func_decls
    | Stmt_decl fun_decl ->
        (*look at the z3 type fun_decl*)
        let func_name = Z3.Symbol.mk_string context fun_decl.fun_name in
        let input_sorts =
          List.map (convert_smt_to_z3_ty context sorts) fun_decl.fun_args
        in
        let output_sort = convert_smt_to_z3_ty context sorts fun_decl.fun_ret in
        let z3_func_decl =
          Z3.FuncDecl.mk_func_decl context func_name input_sorts output_sort
        in
        (*not sure if i need to do anything to this*)
        Hashtbl.add func_decls fun_decl.fun_name z3_func_decl ;
        convert_smt_to_z3 context solver rest sorts func_decls
    (* | Stmt_fun_def of fun_def | Stmt_fun_rec of fun_def | Stmt_funs_rec of
       funs_rec_def | Stmt_data of ((string * int) * cstor list) list *)
    | Stmt_assert term ->
        counter := !counter + 1 ;
        add solver [convert_smt_to_z3_term context func_decls sorts term] ;
        convert_smt_to_z3 context solver rest sorts func_decls
    (* | Stmt_get_assertions | Stmt_get_assignment | Stmt_get_info of string *)
    (*| Stmt_get_model (*This looks to be a parameter in the Context*)*)
    (* | Stmt_get_option of string | Stmt_get_proof | Stmt_get_unsat_assumptions
       | Stmt_get_unsat_core | Stmt_get_value of term list*)
    (* | Stmt_check_sat -> *)
    (* | Stmt_check_sat_assuming of prop_literal list | Stmt_pop of int |
       Stmt_push of int | Stmt_reset | Stmt_reset_assertions | Stmt_exit *)
    | _ -> convert_smt_to_z3 context solver rest sorts func_decls )
  | _ -> (context, solver, sorts, func_decls)

let evaluate_stmts (stmts : PA.stmt list) ctx solver sorts func_decls =
  (* push solver ; *)
  let context, solver, sorts, func_decls =
    convert_smt_to_z3 ctx solver stmts sorts func_decls
  in
  (*TODO: Have a terminal command that allows us to print out the assertions
    from z3: this would be very useful for debugging*)
  (* let _ = List.map (fun x -> output_string stderr (Z3.Expr.to_string x))
     (get_assertions solver) in *)
  let result = check solver [] in
  match result with
  | SATISFIABLE -> ("sat", context, solver, sorts, func_decls)
  | UNSATISFIABLE -> ("unsat", context, solver, sorts, func_decls)
  | UNKNOWN -> ("unknown", context, solver, sorts, func_decls)

let evaluate_stmts_from_scratch (stmts : PA.stmt list) =
  List.iter (fun (k, v) -> Z3.set_global_param k v) !global_params ;
  let ctx = Z3.mk_context !ctx_params in
  let solver = Z3.Solver.mk_solver_s ctx "QF_UF" in
  let solver =
    List.fold_left
      (fun acc simplifier ->
        add_simplifier ctx acc (Z3.Simplifier.mk_simplifier ctx simplifier) )
      solver !simplifiers
  in
  let params = Z3.Params.mk_params ctx in
  List.iter
    (fun (k, v) -> Z3.Params.add_bool params (Z3.Symbol.mk_string ctx k) v)
    !solver_flags ;
  Z3.Solver.set_parameters solver params ;
  let sorts = Hashtbl.create 16 in
  let func_decls = Hashtbl.create 256 in
  evaluate_stmts stmts ctx solver sorts func_decls

let set_timeout (timeout : int) =
  ctx_params := ("timeout", string_of_int timeout) :: !ctx_params

let set_simplifier (s : string) = simplifiers := s :: !simplifiers

let set_global_parameter (p : string) =
  let left = String.sub p 0 (String.index p '=') in
  let right =
    String.sub p
      (String.index p '=' + 1)
      (String.length p - String.index p '=' - 1)
  in
  global_params := (left, right) :: !global_params

let set_solver_flag (s : string) = solver_flags := (s, true) :: !solver_flags

let clear_solver_flag (s : string) = solver_flags := (s, false) :: !solver_flags