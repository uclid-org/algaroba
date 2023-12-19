(* Given a formula in flattened NNF form, we want to perform our reduction*)
module PA = Smtlib_utils.V_2_6.Ast
open Containers
exception UnsupportedQuery of string

module StrTbl = CCHashtbl.Make(CCString)


(* module Term = struct
  type t = PA.term
  let equal (t1 : PA.term) (t2 : PA.term) = (t1 = t2)  (* structural equality *)
  let hash = (fun term -> Hashtbl.hash term)
  (* | True -> 0
  | False -> 1
  | Const s -> Hashtbl.hash s  (* hash the string *)
  | _ -> failwith "not implemented"  Add cases for other constructors *)
end

module TermTbl = CCHashtbl.Make(Term) *)


module Ctx = struct
  type t = {
    mutable function_definition: PA.ty StrTbl.t;
    mutable new_statements: (PA.ty * PA.term) StrTbl.t; (*For new statements that we want to add of form: *variable* = (expression)*)
    mutable general_statements: (PA.ty * PA.stmt) StrTbl.t; (*for all other new statements taht we want to make*)
    mutable cone_of_influence_vars: string StrTbl.t; (*keeping track of all the variables for the  cone of infuence*)
    mutable adts:  (PA.cstor list) StrTbl.t; (*the idea is that when you declare a new adt sort you should store its constructors here*)
    mutable adt_vars: PA.ty StrTbl.t;
    mutable constructors: (PA.ty * PA.cstor) StrTbl.t;
    mutable selectors: (PA.ty * PA.cstor * int) StrTbl.t;
    mutable testers: (PA.ty * PA.cstor) StrTbl.t;
    mutable adt_with_depth_variables: (((string * int) list) * PA.ty) StrTbl.t; (*The adt variables relevant for depth calculation will be stored here. used in R6*)
    mutable adt_with_all_variables: ((string list) * PA.ty) StrTbl.t; (*all adt variables will be added here not just the depth variables*)
    mutable adt_with_selectors: (string (*selector name*) * PA.ty (*selector type*) * string (*cstor name*)) list StrTbl.t; (* way to look up the different selectors in Reduction%*)
    mutable mutually_recursive_datatypes: (bool * (string list) * int) StrTbl.t; (*boolean: will tell if a datatype is mutually recursive
                                                                                        list: contains a list of datatypes it references int:  max_depth*)
    mutable reverse_graph: (string list) StrTbl.t; (* creates a reverse graph of the graph given to us by mutually_recursive_datatypes*)
    mutable strongly_connected_components: (string list) StrTbl.t; (* *)
    mutable axioms: PA.stmt List.t;
    mutable vars_created: int;
    mutable enum_adts: ((PA.cstor list) * (string list)) StrTbl.t; (*list of constructors and then a list of functions that are just applied to that enum*)
    mutable enum_functions: (string * string) StrTbl.t; (*This just allows us to look up all functions that get applied to enums and it returns the enum that it returns*)
    mutable context_hashing: (PA.term, string) Hashtbl.t;
    mutable constants: (PA.term) StrTbl.t;(*keeps track of the constants we rewrite in R2rewriting*)
    mutable skip_counter: int; (* keeps track fo the skip variables in local_acylicality axioms*)
    mutable finite_adts: (PA.term list) StrTbl.t; (* keeps a list of all the finite adts and all terms in the universe*)
    mutable recursive_functions: (PA.fun_def * (PA.ty list) * PA.ty * (PA.term * ((string * PA.term * string) list * (string * (PA.term list -> PA.term) * string) list))) StrTbl.t; (* stores a list of defined recursive functions*)
    mutable terms_to_unroll_for_recursive_function: (string * PA.term) StrTbl.t; (*this is a list of terms to unroll for recursive functions given to us by the last such call*)
    mutable guards: bool StrTbl.t; (* this is a list of guards and true or false depending on whether it was in the last variable*)
    (* stuff for smart depths calculation (constructing a graph)*)
    (* mutable adt_var_graph : G; *)
    (* Options that get set by solver flags*)
    mutable set_logic: string; (*this will store our set-logic: The default is QF_UF*)
    mutable at_most_axiom: bool; (*this will tell us whether we want to instantiate our tester axioms using z3's at-most function: The default is false*)
    mutable return_depth: bool; (* option to get solver to just return the depths instead of actually solving anything*)
    mutable branch_depth: int; (* allows us to only solve via reduction if all of our depths < branch_depth: default -1 means that we should always reduce*)
    mutable print_smt: bool; (*if true we print the smt file out and use a solver, otherwise by default we use the z3 OCaml API*)
    mutable solver: string; (* Will tell us which solver to use; default: z3; only relevant if print_smt is true*)
  }

  let t : t = {
    function_definition=StrTbl.create 64;
    new_statements=StrTbl.create 64;
    general_statements=StrTbl.create 64;
    cone_of_influence_vars = StrTbl.create 64;
    adts = StrTbl.create 64;
    adt_vars = StrTbl.create 64;
    constructors=StrTbl.create 64;
    selectors=StrTbl.create 64;
    testers = StrTbl.create 64;
    adt_with_depth_variables = StrTbl.create 64;
    adt_with_all_variables = StrTbl.create 64;
    adt_with_selectors = StrTbl.create 64;
    mutually_recursive_datatypes = StrTbl.create 64;
    reverse_graph = StrTbl.create 64;
    strongly_connected_components = StrTbl.create 64;
    axioms = [PA.Stmt_check_sat];
    vars_created = 0;
    enum_adts = StrTbl.create 64;
    enum_functions = StrTbl.create 64;
    context_hashing = Hashtbl.create 64;
    constants = StrTbl.create 128;
    skip_counter = 0;
    finite_adts = StrTbl.create 8;
    recursive_functions = StrTbl.create 8;
    terms_to_unroll_for_recursive_function = StrTbl.create 64;
    guards = StrTbl.create 64;
    (* stuff for smart depths calculation (constructing a graph)*)
    (* adt_var_graph = G.empty; *)
    (* Options that get set by solver flags*)
    set_logic = "QF_UF";
    at_most_axiom = false;
    return_depth = false; 
    branch_depth = -1;
    print_smt = false;
    solver = "z3";
  }


  let increment_vars_created () : unit = 
    t.vars_created <- t.vars_created + 1

  let increment_skip_counter () : unit = 
  t.skip_counter <- t.skip_counter + 1
  let add_fun_def name var_type : unit = StrTbl.add t.function_definition name var_type

  let lookup_fun_def name : PA.ty = StrTbl.find t.function_definition name 

  let add_new_statement (name : string) var_type (term : PA.term) : unit = 
    Hashtbl.add t.context_hashing term name;
    StrTbl.add t.new_statements name (var_type, term)
  let lookup_new_statement name = StrTbl.find t.new_statements name
  
  let add_general_statement name var_type statement : unit = StrTbl.add t.general_statements name (var_type, statement)
  let lookup_general_statement name = StrTbl.find t.general_statements name

  let add_to_cone name = StrTbl.add t.cone_of_influence_vars name ""
  let in_cone name = 
    begin match StrTbl.find_opt t.cone_of_influence_vars name with
      | Some _ -> true
      | None -> false
    end

  let add_adt name cstor_list = StrTbl.add t.adts name cstor_list

  let add_constructor name cstor = StrTbl.add t.constructors name cstor
  let in_constructors name = 
    begin match StrTbl.find_opt t.constructors name with
      | Some _ -> true
      | None -> false
    end
  
  (* get's the selectors of a given constructor*)
  let get_selectors name =
    begin match StrTbl.find_opt t.constructors name with
      | Some (_, cstor) -> List.map fst cstor.cstor_args
      | None -> []
    end

  let add_selector name ty cstor selector_number = StrTbl.add t.selectors name (ty, cstor, selector_number)
  let has_selector name = 
    begin match (StrTbl.find_opt t.selectors name) with
      | Some (_, _, _ ) -> true
      | None -> false
    end

  let add_tester name ty cstor = StrTbl.add t.testers name (ty, cstor)

  (*will tell you if a string is the name of an adt, selector, constructor, or tester. Useful when we do cone of influence pruning*)
  let is_adt_selector_constructor_tester name = 
    begin match StrTbl.find_opt t.adts name with 
      | Some _ -> true 
      | None -> begin match StrTbl.find_opt t.selectors name with
                  | Some _ -> true
                  | None -> begin match StrTbl.find_opt t.constructors name with
                              | Some _ -> true 
                              | None -> begin match StrTbl.find_opt t.testers name with 
                                          | Some _ -> true
                                          | None -> false
                                        end
                              end
                  end
      end

    let is_constructor name = 
      begin match StrTbl.find_opt t.constructors name with 
        | Some _ -> true 
        | None -> false
      end

    let is_selector name = 
      begin match StrTbl.find_opt t.selectors name with 
        | Some _ -> true 
        | None -> false
      end
    


  let add_adt_var name typ = StrTbl.add t.adt_vars name typ
  let lookup_adt_var name = begin match StrTbl.find_opt t.adt_vars name with
                              | Some value -> value
                              | None -> PA.Ty_bool
                            end
  let rec contains (x : string) (lst: string list) =
    match lst with
    | [] -> false
    | h :: t -> if (String.equal h x) then true
                else  contains x t

  let add_depth_variable_to_adt name variable ty =
    begin match StrTbl.find_opt t.adt_with_depth_variables name with
      | Some (var_list, _) ->
        if (contains variable (List.map fst var_list)) then ()
        else  StrTbl.replace t.adt_with_depth_variables name (((variable, 0) :: var_list), ty)
      | None -> StrTbl.add t.adt_with_depth_variables name ([(variable, 0)], ty)
    end

  let update_depth new_depth name =
    begin match StrTbl.find_opt t.adt_with_depth_variables name with
      | Some (var_list, ty) ->
        StrTbl.replace t.adt_with_depth_variables name ((List.map (fun (s, i) -> print_string ("Updating " ^ s ^ " to " ^ (string_of_int (max i new_depth)));(s, (max i new_depth))) var_list), ty)
      | None -> ()
    end

  let add_general_variable_to_adt name variable ty =
    begin match StrTbl.find_opt t.adt_with_all_variables name with
      | Some (var_list, _) -> StrTbl.replace t.adt_with_all_variables name ((variable :: var_list), ty)
      | None -> StrTbl.add t.adt_with_all_variables name ([variable], ty)
    end


  let get_replace_term_func vars term =
    let rec process_term term (vars : string list) (replacements : PA.term list) : PA.term =
      begin match (term : PA.term) with 
        | PA.Const s ->
            begin match (List.find_idx (fun (x : string) -> String.equal x s) vars) with
              | Some (i, _) -> (List.nth replacements i)
              | None -> PA.Const s
            end
        | PA.Arith (op, term_list) -> Arith (op, List.map (fun t ->process_term t vars replacements) term_list)
        | PA.App (s, term_list) -> App (s, List.map (fun t ->process_term t vars replacements) term_list)
        | HO_app (t1, t2) -> HO_app (process_term t1 vars replacements, process_term t2 vars replacements)
        | If (t1, t2, t3) -> If (process_term t1 vars replacements, process_term t2 vars replacements, process_term t3 vars replacements)
        | Let _ -> raise (UnsupportedQuery "should have handled Lets by now")
        | Is_a (s, t) -> Is_a (s, process_term t vars replacements)
        | Fun (var, t) -> Fun (var, process_term t vars replacements)
        | Eq (t1, t2) -> Eq (process_term t1 vars replacements, process_term t2 vars replacements)
        | Imply (t1, t2) -> Imply (process_term t1 vars replacements, process_term t2 vars replacements)
        | And terms -> And (List.map (fun t ->process_term t vars replacements) terms)
        | Or terms -> Or (List.map (fun t ->process_term t vars replacements) terms)
        | Not t -> Not (process_term t vars replacements)
        | Distinct terms -> Distinct (List.map (fun t ->process_term t vars replacements) terms)
        | Cast (t, ty) -> Cast (process_term t vars replacements, ty)
        | Forall _ -> raise (UnsupportedQuery "We don not support universal quantifiers")
        | Exists _ -> raise (UnsupportedQuery "We don not support universal quantifiers")
        | Attr (t, attrs) -> Attr (process_term t vars replacements, attrs)
        | Match _ -> raise (UnsupportedQuery "We are not currently allowing recursive functions to have nested match statements") (*TODO: add nested match statements*)
        | term -> term (*catch all in the end*)
      end in
      (fun (l : PA.term list) -> process_term term vars l)

  let handle_recursive_func_cases (branches: PA.match_branch list) =
    let rec aux branches default case = 
      begin match branches with
        | PA.Match_case (name, [], term) :: rest -> 
          let term_constructor = 
            begin match term with 
              | PA.App (f, _) -> f
              | PA.Const c -> c
              | _ -> raise (UnsupportedQuery "Currently only support recursive functions with constructor applications in the match cases")
            end in
          aux rest ((name, term, term_constructor) :: default) case (*TODO: need to fix this to actually support multiple things*)
        | PA.Match_case (name, vars, term) :: rest ->
          let term_constructor = 
            begin match term with 
              | PA.App (f, _) -> f
              | PA.Const c -> c
              | _ -> raise (UnsupportedQuery "Currently only support recursive functions with constructor applications in the match cases")
            end in
            let replace_term_func = get_replace_term_func vars term in
            (aux rest default ((name, replace_term_func, term_constructor) :: case))
        | PA.Match_default term :: rest -> raise (UnsupportedQuery "We do not currently support defaults in match statements")
        | [] -> default, case
      end in
    aux branches [] []


  let add_recursive_function name (rec_fun : PA.fun_def) =
    print_endline ("adding a recursive function: " ^ name);
    let body = rec_fun.fr_body in
    let return = rec_fun.fr_decl.fun_ret in
    let inputs = List.map snd rec_fun.fr_decl.fun_args in
    let processed_body =
    begin match body with
      | PA.Match (t, branches) ->
          let cases = handle_recursive_func_cases branches in
          (t, cases)
      | _ -> raise (UnsupportedQuery "Algaroba does not support recursive functions in full generality") 
    end in
    StrTbl.add t.recursive_functions name (rec_fun, inputs, return, processed_body)

  let save_recursive_application (const : string) (s: string) (inside_term: PA.term) = 
    begin match inside_term with 
              | PA.Const c -> print_endline ("Saving recursive function" ^ const ^ "= " ^ s ^ "(" ^ c ^ ")")
              | _ -> ()
            end;
     StrTbl.add t.terms_to_unroll_for_recursive_function const (s, inside_term)

  let stmt_to_statement (s: PA.stmt) : PA.statement = {PA.stmt = s; loc = None}

  let statement_printer lst = Format.printf "@[<hv>%a@]@." (PA.pp_list PA.pp_stmt) lst

  let stmt_printer lst =  statement_printer (List.map stmt_to_statement lst)

  (* helper function that does polymorphic comparisons for PA.ty*)
  let rec ty_compare (a : PA.ty) (b : PA.ty) =
    begin match a, b with 
      | Ty_bool, Ty_bool-> true
      | Ty_real, Ty_real -> true
      | Ty_app (a_name, a_ty_list), Ty_app (b_name, b_ty_list) ->
          (String.equal a_name b_name) && (List.fold_left (fun acc comp -> acc && (ty_compare (fst comp) (snd comp))) true (List.combine a_ty_list b_ty_list))
      | Ty_arrow (a_left, a_right), Ty_arrow (b_left, b_right) ->
          (List.fold_left (fun acc comp -> acc && (ty_compare (fst comp) (snd comp))) true (List.combine a_left b_left)) && (ty_compare a_right b_right)
      | _ -> false
    end

    (*helper functions borrowed from R6 to get make my tester axioms*)
    let get_tester_axiom_term term (cstor_list : PA.cstor list) not_placement =
      let rec aux term (cstor_list : PA.cstor list) not_placement acc =
        match cstor_list with
        | cstor :: rest ->
            if not_placement = 1 then
              aux term rest (not_placement - 1)
                (acc @ [PA.App ("is-" ^ cstor.cstor_name, term)])
            else
              aux term rest (not_placement - 1)
                ( acc
                @ [PA.Not (PA.App ("is-" ^ cstor.cstor_name, term))]
                )
        | _ -> acc
      in
      aux term (cstor_list : PA.cstor list) not_placement []
    
    (*Note: I am only currently doing this with constants, but I may need to do this
      with all constructors. Don't think I need this will all constructors*)
    let rec get_tester_and value cstor_list not_placement =
      if not_placement = 1 then
        [PA.And (get_tester_axiom_term value cstor_list not_placement)]
      else
        PA.And (get_tester_axiom_term value cstor_list not_placement)
        :: get_tester_and value cstor_list (not_placement - 1)

  (*helper function that creates contrived variables of the correct type in unrolling*)
  let create_cv_unrolling cstor_name term rec_fun return_ty =
    begin match StrTbl.find_opt t.constructors cstor_name with
      | Some (ty, cstor) ->
          let selector = cstor.cstor_args in 
          let contrived_variables = List.map (fun sel -> let cv1 = "contrived_variable" ^ (string_of_int t.vars_created) in increment_vars_created ();
                                                         let cv2 = "contrived_variable" ^ (string_of_int t.vars_created) in increment_vars_created (); ((cv1, cv2), sel)) selector in 
          (*TODO: add new contrived variables to the adt_with_depth variables and also add these new contrived variables to *)
          let asserts = List.flat_map  
                      (fun cv -> 
                        begin match (snd (snd cv)) with 
                          | PA.Ty_app (ty_name, _) ->
                               add_depth_variable_to_adt ty_name (fst (fst cv)) (snd (snd cv)); (*adding the new contrived variable for depth*)
                               print_endline ("Adding depth variable " ^ (fst (fst cv)) ^ " of type " ^ty_name);
                               print_endline ("adding a term to unroll " ^ (fst (fst cv)) ^" equal to an application of " ^ (rec_fun) ^ " on "); (stmt_printer [PA.Stmt_assert term]);
                                if (ty_compare ty (snd (snd cv))) then save_recursive_application (snd (fst cv)) rec_fun (PA.Const (fst (fst cv))); (*adding the new contrived variable to unrolling*)
                               [PA.Stmt_decl {fun_ty_vars = []; fun_name = snd (fst cv); fun_args = []; fun_ret = return_ty}  ; PA.Stmt_assert (PA.Eq (PA.Const (fst (fst cv)), PA.App ((fst (snd cv)), [term])))](*generating asserts*)
                          | _ -> raise (UnsupportedQuery "Incorrect typed term")
                        end)
                      contrived_variables in
          let constructor_assert = PA.Stmt_assert (PA.Eq (PA.App ("is-" ^ cstor.cstor_name, [term]), PA.Eq (PA.App (cstor.cstor_name, List.map (fun x -> PA.Const (fst (fst x))) contrived_variables), term))) (*adding that if the term satisfies the correct tester, then it can be constructed*) in
          let cstor_list = 
            begin match ty with 
              | PA.Ty_app (name, _) -> StrTbl.find t.adts name
              | _ -> raise (UnsupportedQuery "this doesn't work")
            end in
          let satisfies_one_tester_assert = PA.Stmt_assert (PA.Or (get_tester_and [term] cstor_list (List.length cstor_list))) in (*adding the assert that this guy only satisfies one tester*)
          List.map (fun ((w, _), (_, z)) -> (w, z)) contrived_variables, constructor_assert :: satisfies_one_tester_assert :: asserts (*TODO: these asserts need all of the normal axioms ugh*)
      | _ -> raise (UnsupportedQuery "Match statement where one of the options was not a constructor")
    end

  let remove_all_guards () =
    let keys = StrTbl.keys_list t.guards in 
    List.map (fun key -> StrTbl.remove t.guards key) keys

  (*helper function copied from Z3_utils*)
  let convert_smt_to_z3_ty context sorts (ty : PA.ty) =
    match (ty : PA.ty) with
    | Ty_bool -> Z3.Boolean.mk_sort context
    | Ty_real -> Z3.Arithmetic.Real.mk_sort context
    | Ty_app (s, []) -> (
      match Hashtbl.find_opt sorts s with
      | Some sort -> sort
      | None -> raise (UnsupportedQuery ("trying to use a sort" ^ s ^ " that does not exist. The sorts are: "))
      )
    | Ty_app _ ->
        raise (UnsupportedQuery "We do not currently support Polymorphic types")
      | Ty_arrow _ -> raise (UnsupportedQuery "We do not currently support Ty_arrow")

  let add_to_func_decls fun_name fun_ret context sorts func_decls = 
    let func_name = Z3.Symbol.mk_string context fun_name in
    let input_sorts = [] in
    let output_sort = convert_smt_to_z3_ty context sorts fun_ret in
    let z3_func_decl =
      Z3.FuncDecl.mk_func_decl context func_name input_sorts output_sort
    in
    (*not sure if i need to do anything to this*)
    Hashtbl.add func_decls fun_name z3_func_decl ;
    ()


  
  (*Note that adt_with_depth_variables is where the variables whose depths we care about *)
  let unroll_recursive_functions context sorts func_decls = 
    let keys = StrTbl.keys_list t.terms_to_unroll_for_recursive_function in 
    let _ = remove_all_guards () in
    let rec iterate keys axioms = 
      begin match keys with 
        | key :: rest ->
            let recursive_function, inside_term = StrTbl.find t.terms_to_unroll_for_recursive_function key in
            begin match inside_term with 
              | PA.Const c -> print_endline ("Doing this for " ^ key ^ "= " ^ recursive_function ^ "(" ^ c ^ ")")
              | _ -> ()
            end;
            begin match StrTbl.find_opt t.recursive_functions recursive_function with 
              | Some (rec_fun, inputs_ty, return_ty, (match_term, ((base_case_name, base_case_term, base_case_constructor) :: _, (iterative_case_name, iterative_case_function, iterative_case_function_constructor) :: _))) -> (*TODO: add support for multiple base cases and iterative cases*)
                  let bool_var = "contrived_variable" ^(string_of_int t.vars_created) in 
                  let bool_declaration = (PA.Stmt_decl {fun_ty_vars = []; fun_name = bool_var; fun_args = []; fun_ret = Ty_bool}) in
                  add_to_func_decls bool_var PA.Ty_bool context sorts func_decls;
                  increment_vars_created ();
                  let subterm_vars, subterm_asserts = create_cv_unrolling iterative_case_name inside_term recursive_function return_ty in
                  let subterm_declarations = List.filter_map 
                                            (fun subterm -> add_to_func_decls (fst subterm) (snd subterm) context sorts func_decls;
                                                              Some ((PA.Stmt_decl {fun_ty_vars = []; fun_name = (fst subterm); fun_args = []; fun_ret = snd subterm})))
                                             subterm_vars in
                  let new_axioms = [PA.Stmt_assert (PA.Eq (PA.App (recursive_function, [inside_term]), PA.Const key))
                                   ; PA.Stmt_assert (PA.Eq (PA.Const bool_var, PA.Eq (inside_term, PA.Const base_case_name)))
                                   ; PA.Stmt_assert (PA.Imply (PA.Const bool_var, PA.And [PA.Eq (PA.Const key, base_case_term); 
                                                        (PA.App ("is-" ^ base_case_constructor, [PA.Const key]))]))
                                   ; PA.Stmt_assert (PA.Imply (PA.Not (PA.Const bool_var), 
                                                    (PA.And [PA.Eq (PA.Const key, iterative_case_function (List.map (fun x -> PA.Const (fst x)) subterm_vars));
                                                            (PA.App ("is-" ^ iterative_case_function_constructor, [PA.Const key]))])))] in
                  StrTbl.add t.guards bool_var true;
                  iterate rest (axioms @ [bool_declaration] @ subterm_declarations @ subterm_asserts @ new_axioms)
              | _ -> raise (UnsupportedQuery ("somehow unrolling a non-recursive function: " ^ recursive_function))
            end;
        | _ -> axioms
      end
    in
    let new_axioms = iterate keys [] in
    let _ = List.map (fun key -> StrTbl.remove t.terms_to_unroll_for_recursive_function key) keys in
    new_axioms



  (*BEGIN: here I will try and rewrite find_max_depths to actually find the strongly connected components (Kosaraju's algorithm) and then calculate max depths*)
  let get_vertex_weight vertex = 
    match (StrTbl.find_opt t.mutually_recursive_datatypes vertex) with 
      | Some (_, _, weight) -> weight
      | None -> 0 

  (*helper function for debugging*)
  let get_adt_depths () =
    let vertices = StrTbl.keys_list t.mutually_recursive_datatypes in
    List.iter (fun (vertex : string) ->
      Printf.printf "Vertex %s: the ADT depth = %d\n" vertex (get_vertex_weight vertex)
    ) vertices
  
  let add_reverse_edges () =
    let rec add_values (values : (string list)) (key : string) = 
      begin match values with
        | value :: rest -> 
            begin match (StrTbl.find_opt t.reverse_graph value) with
              | Some previous_children -> StrTbl.replace t.reverse_graph value (key :: previous_children)
              | None -> raise (UnsupportedQuery "Should have already added the key into reverse_garph")(*StrTbl.add t.reverse_graph value [key]*)
            end; 
            add_values rest key
        | _ -> ()
      end in

    let rec helper keys = 
      begin match keys with
        | key :: rest -> 
            let values = (fun (_, y, _) -> y) (StrTbl.find t.mutually_recursive_datatypes key) in 
            add_values values key;
            helper rest
        | _ -> ()
      end in
    
    let keys = StrTbl.keys_list t.mutually_recursive_datatypes in
    let _ = List.map (fun key -> StrTbl.add t.reverse_graph key []) keys in (*adding in all the keys into reverse graph*)
    helper keys
    
  (*this is the first dfs that we do: designed to get the order_stack that we consider in the second dfs*)  
  let rec first_dfs_helper (vertex : string) visited stack order_stack= 
    let _, neighbours, _ = StrTbl.find t.mutually_recursive_datatypes vertex in
    StrTbl.replace visited vertex true;
    let _ = List.map (fun neighbour -> if (not (StrTbl.find visited neighbour)) then (Stack.push neighbour stack)) neighbours in (*adding non visited neighbours to stack*)
    if Stack.is_empty stack then Stack.push vertex order_stack
    else 
      (let next = (Stack.pop stack) in
      first_dfs_helper next visited stack order_stack;
      Stack.push vertex order_stack;
      ()
      )
  
  let rec first_dfs visited default_stack order_stack = 
    if (Stack.is_empty default_stack) then ()
    else (
      let next = Stack.pop default_stack in
      if (StrTbl.find visited next) then first_dfs visited default_stack order_stack 
      else (
        let stack = Stack.create () in 
        first_dfs_helper next visited stack order_stack;
        first_dfs visited default_stack order_stack;
      )
    )

  let rec second_dfs_helper vertex visited stack component = 
    let neighbours = StrTbl.find t.reverse_graph vertex in
    StrTbl.replace visited vertex true; 
    let _ = List.map (fun neighbour -> if (not (StrTbl.find visited neighbour)) then Stack.push neighbour stack) neighbours in (*adding non visited neighbours to stack*)
    if (Stack.is_empty stack)
      then vertex :: component, visited
    else second_dfs_helper (Stack.pop stack) visited stack (vertex :: component)

  let rec second_dfs order_stack visited = 
    if (Stack.is_empty order_stack) then ()
      else
      (let stack = Stack.create () in
      let next = Stack.pop order_stack in 
      if (StrTbl.find visited next) then (second_dfs order_stack visited)
      else
        (let component, new_visited = second_dfs_helper next visited stack [] in 
        StrTbl.add t.strongly_connected_components next component;
        second_dfs order_stack new_visited
    ))
  

  let find_strongly_connected_components () = 
    let _ = add_reverse_edges () in 
    let visited = StrTbl.create 10 in
    let default_stack = Stack.create () in
    let order_stack = Stack.create () in
    let vertices = StrTbl.keys_list t.mutually_recursive_datatypes in
    let _ = List.map (fun vertex -> StrTbl.add visited vertex false; Stack.push vertex default_stack) vertices in 
    first_dfs visited default_stack order_stack;
    let second_visited = StrTbl.create 10 in
    let _ = List.map (fun vertex -> StrTbl.add second_visited vertex false) vertices in 
    second_dfs order_stack second_visited

  let rec find_depth_of_scc values = 
    begin match values with
      | value :: rest ->
          let _, _, value_depth = StrTbl.find t.mutually_recursive_datatypes value in 
          value_depth + (find_depth_of_scc rest)
      | _ -> 0
      end 

  let find_max_depths () = 
    let rec helper keys = 
      begin match keys with
        | key :: rest ->
            let values = StrTbl.find t.strongly_connected_components key in 
            let new_depth = find_depth_of_scc values in 
            let _ = List.map (fun value -> let a,b,_ = StrTbl.find t.mutually_recursive_datatypes value in 
                                           StrTbl.replace t.mutually_recursive_datatypes value (a, b, new_depth)) values in 
            helper rest 
        | _ -> ()
      end in 

      let vertices = StrTbl.keys_list t.mutually_recursive_datatypes in

      List.iter (fun vertex ->
        begin match StrTbl.find_opt t.adt_with_depth_variables vertex with
          | Some _ -> ()
          | None -> StrTbl.add t.adt_with_depth_variables vertex ([], Ty_bool)
        end
        ) vertices;



      List.iter (fun vertex ->
        let values, _ =  StrTbl.find t.adt_with_depth_variables vertex in
        begin match StrTbl.find_opt t.mutually_recursive_datatypes vertex with
          | Some (b, l, _) -> 
              StrTbl.replace t.mutually_recursive_datatypes vertex (b, l, (List.length values))
          | None -> ()
        end
      ) vertices;


    (* print_string "ADT DEPTHS BEFORE:"; get_adt_depths (); *)
    find_strongly_connected_components ();
    let keys = StrTbl.keys_list t.strongly_connected_components in 
    (* print_endline " The strongly connected components are: ";
    let _ = List.map (fun key -> print_string "    |"; print_string_list (StrTbl.find t.strongly_connected_components key)) keys in *)

    helper keys
    (* print_string "ADT DEPTHS AFTER:"; get_adt_depths () *)




    (*END*)


  (*This should be used when reading in the *)
  let check_mutually_recursive (adt_list: ((string * int) * PA.cstor list) list) =
    let rec cmr_helper_helper_helper (adt_name :string) (cstor_args : PA.ty list) adt_names = 
      begin match cstor_args with
        | ty :: rest ->
          begin match ty with 
            | PA.Ty_app (cstor_name, _) ->
                      if (String.equal cstor_name adt_name) then (cmr_helper_helper_helper adt_name rest adt_names)
                      else (if (List.mem cstor_name adt_names) then 
                              ((match (StrTbl.find_opt t.mutually_recursive_datatypes adt_name) with
                                | Some (_, mutual_list, n) -> StrTbl.replace t.mutually_recursive_datatypes adt_name (true, (cstor_name :: mutual_list), n)
                                | None ->  StrTbl.add t.mutually_recursive_datatypes adt_name (true, [cstor_name], 0)
                              );
                              (cmr_helper_helper_helper adt_name rest adt_names))
                          else (cmr_helper_helper_helper adt_name rest adt_names))
            | _ -> (cmr_helper_helper_helper adt_name rest adt_names)
          end
        | _ -> ()
      end in

    let rec cmr_helper_helper (adt_name :string) (cstor_list : PA.cstor list) adt_names = 
      begin match cstor_list with
        | cstor :: rest ->
            let arg_names = (List.map snd cstor.cstor_args) in
            cmr_helper_helper_helper adt_name arg_names adt_names;
            cmr_helper_helper adt_name rest adt_names
        | [] -> ()
      end
    in

    let rec cmr_helper (adt_list: ((string * int) * PA.cstor list) list) adt_names =
      begin match adt_list with
        | ((adt_name, _), cstor_list) :: rest ->
          cmr_helper_helper adt_name cstor_list adt_names;
          cmr_helper rest adt_names
        | _ -> ()
      end in

    let rec initialize_adts adt_names = 
      begin match adt_names with
        | adt_name :: rest ->  
            StrTbl.add t.mutually_recursive_datatypes adt_name (false, [], 0);
            initialize_adts rest
        | [] -> ()
      end in
    
    let adt_names = (List.map (fun x -> fst (fst x)) adt_list) in 
    initialize_adts adt_names;
    cmr_helper adt_list adt_names

    let print_string_list s =
      let rec print_string_list_helper = function
        | [] -> ()
        | h::t -> print_string (h ^ ", ") ; print_string_list_helper t
      in
      print_string "["; print_string_list_helper s; print_endline "]"
    
(* function that does a DFS to find if a data type is inductive*)
(*not tail recursive at all, but we shouldn't have more than a few adts*)
  let check_inductive_datatype (adt :string) =
    let rec aux adt parents = 
      if ((List.exists (fun x -> (String.equal x adt)) parents)) then true
      else (
        let children = 
          begin match StrTbl.find_opt t.adts adt with 
            | Some cstor_list -> List.flat_map 
                                    (fun (cstor : PA.cstor) ->  List.map (fun x -> match (snd x) with 
                                                                                      |PA.Ty_app (s, _) -> s
                                                                                      | _ -> raise (UnsupportedQuery ("check_inductive_datatypes given incorrect adt: "^ adt)))
                                                                           cstor.cstor_args)
                                    cstor_list
            | None -> raise (UnsupportedQuery ("check_inductive_datatypes given incorrect adt: "^ adt))
        end in
        List.fold_left 
          (fun acc child -> (aux child (adt::parents)) || acc) 
          false 
          children
      )
      in
    aux adt []

    
  let add_axiom new_axiom = 
    t.axioms <- new_axiom :: t.axioms
  let add_axioms new_axioms = 
    t.axioms <- t.axioms @ new_axioms

  
end

(*TODO: add all the new things to reset_ctx*)
let reset_ctx () = 
  Ctx.t.function_definition <- StrTbl.create 64;
  Ctx.t.new_statements <- StrTbl.create 64;
  Ctx.t.general_statements <- StrTbl.create 64;
  Ctx.t.adts <- StrTbl.create 64;
  Ctx.t.adt_vars <- StrTbl.create 64;
  Ctx.t.constructors <- StrTbl.create 64;
  Ctx.t.selectors <- StrTbl.create 64;
  Ctx.t.testers <- StrTbl.create 64;
  Ctx.t.adt_with_depth_variables <- StrTbl.create 64;
  Ctx.t.adt_with_selectors <- StrTbl.create 64;
  Ctx.t.vars_created <- 0;
;;

let get_match_term (match_term : PA.match_branch) = 
  begin match match_term with
  | Match_default t -> t
  | Match_case (_, _, t) -> t
end

(* here is a function that will tell you the type of a term. Not sure if there is a faster way to do this*)
(* also *)
let rec get_type (term: PA.term) : PA.ty = 
  begin match term with
    | True -> PA.Ty_bool
    | False -> PA.Ty_bool
    | Const v -> (Ctx.lookup_fun_def v) (*TODO*)
    | Arith (op, _) -> 
        begin match op with
        | Leq -> PA.Ty_bool
        | Lt -> PA.Ty_bool
        | Geq -> PA.Ty_bool
        | Gt -> PA.Ty_bool
        | Add -> PA.Ty_real
        | Minus -> PA.Ty_real
        | Mult -> PA.Ty_real
        | Div -> PA.Ty_real
        end
    | App (s, _) -> Ctx.lookup_fun_def s (*PA.Ty_app (s, (List.map (fun x -> get_type x) terms))*) (*TODO*)
    | HO_app (_,_) -> PA.Ty_bool(*raise (UnsupportedQuery "We do not support HO_App")*)
    | Match (_, branches) -> get_type (get_match_term (List.hd branches))
    | If (_, t2, _) -> get_type t2
    | Is_a (_, _) -> PA.Ty_bool
    | Fun (_, t) -> get_type t
    | Eq (_, _) -> PA.Ty_bool
    | Imply (_, _) -> PA.Ty_bool
    | And _ -> PA.Ty_bool
    | Or _ -> PA.Ty_bool
    | Not _ -> PA.Ty_bool
    | Distinct _ -> PA.Ty_bool
    | Cast (_, ty) -> ty
    | Forall (_, _) -> raise (UnsupportedQuery "We do not support Forall")
    | Exists (_, _) -> raise (UnsupportedQuery "We do not support Exists")
    | Attr (t, _) -> get_type t
    | _ -> PA.ty_bool
  end


(* General Helper Functions *)

let print_string_list s =
  let rec print_string_list_helper = function
    | [] -> ()
    | h::t -> print_string (h ^ ", ") ; print_string_list_helper t
  in
  print_string "["; print_string_list_helper s; print_endline "]"

let print_int_list (l : int list) = 
  let rec print_int_list_helper = function
    | [] -> ()
    | h::t -> print_string ((string_of_int h) ^ ", ") ; print_int_list_helper t
  in
  print_string "["; print_int_list_helper l; print_endline "]"

let statement_to_stmt (s: PA.statement) = s.PA.stmt

let statement_to_stmts (statements : PA.statement list) : PA.stmt list = 
  let rec aux statements acc = 
    begin match statements with
      | statement :: rest -> aux rest ((statement.PA.stmt) :: acc)
      | _ -> acc
    end in 
  List.rev (aux statements [])

(*Goes from PA.stmt to PA.statement with the location being None*)
let stmt_to_statement (s: PA.stmt) : PA.statement = {PA.stmt = s; loc = None}

let stmt_to_statements (stmts : PA.stmt list) : PA.statement list = 
  let rec aux stmts acc = 
    begin match stmts with
      | stmt :: rest -> aux rest (acc @ [{PA.stmt = stmt; loc = None}])
      | _ -> acc
    end in 
  aux stmts []

let statement_printer lst = Format.printf "@[<hv>%a@]@." (PA.pp_list PA.pp_stmt) lst

let stmt_printer lst =  statement_printer (List.map stmt_to_statement lst)

let ty_printer ty = PA.pp_ty Format.std_formatter ty

let alt_ty_printer ty =  match ty with
  | PA.Ty_bool -> print_string "Bool"
  | Ty_real -> print_string "Real"
  | Ty_app (s,[]) -> print_string s
  | _ -> print_string "other"

let max_elt l =
  let rec aux l m = 
    match l with
      | head :: tail -> aux tail (max m head)
      | [] -> m
  in 
  aux l 0

let print_hashtbl_keys hashtbl = 
  print_string_list (Hashtbl.keys_list hashtbl)
  

(* will tell you if two PA.ty are equal*)

(*I think this is not necessary since we can ue the built in equaity*)
let rec ty_equal (ty1 : PA.ty) (ty2 : PA.ty) : bool = 
begin match ty1 with
  | Ty_bool ->
      begin match ty2 with
        | Ty_bool -> true
        | _ -> false
      end
  | Ty_real ->
      begin match ty2 with
        | Ty_real -> true
        | _ -> false
      end
  | Ty_app (f1, terms1) -> 
    begin match ty2 with 
      | Ty_app (f2, terms2) -> (String.equal f1 f2) && (List.fold_left2 (fun acc term1 term2 -> acc && (ty_equal term1 term2)) true terms1 terms2)
      | _ -> false 
    end

  | Ty_arrow (terms1, result1) ->
      begin match ty2 with 
        | Ty_arrow (terms2, result2) -> (ty_equal result1 result2) && (List.fold_left2 (fun acc term1 term2 -> acc && (ty_equal term1 term2)) true terms1 terms2)
        | _ -> false 
      end
  end