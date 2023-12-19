(* Flatten: Introduce dummy variables to get rid of complex expressions*)

module PA = Smtlib_utils.V_2_6.Ast
open Context
open R2rewrite
open R5reduce_rules
exception UnsupportedQuery of string

let rewrite_ite = ref false
let inline_constants = ref false


  (*helper function that finds the terms in recursive funcstion*)
  let rec find_recursive_function_in_term (term :PA.term) = 
    begin match term with 
      | Eq (a, b) ->
          begin match a, b with 
            | PA.Const const, PA.App (s, [inside_term]) -> (*TODO: Add support for recursive functions with more htan one input*)
              begin match StrTbl.find_opt Ctx.t.recursive_functions s with
                | Some _ -> 
                  Ctx.save_recursive_application const s inside_term;
                  ()
                | None -> ()
              end
            | PA.App (s, [inside_term]), PA.Const const ->
              begin match StrTbl.find_opt Ctx.t.recursive_functions s with
                | Some _ -> 
                  Ctx.save_recursive_application const s inside_term;
                  ()
                | None -> ()
              end
            | _ -> ()
          end
        | _ -> ()
    end

let rec get_general_adt_vars stmts = 
  begin match stmts with
    | stmt :: rest -> 
        begin match stmt with
          | PA.Stmt_decl fun_decl ->
              begin match fun_decl.fun_args with
                | [] -> begin match fun_decl.fun_ret with
                          | Ty_app (name, []) ->
                              begin match StrTbl.find_opt Ctx.t.adts name with 
                                | Some _ -> (*print_string ("adding in adt_variable: " ^ fun_decl.fun_name ^ name ^ " \n");*)
                                            Ctx.add_general_variable_to_adt name fun_decl.fun_name fun_decl.fun_ret; 
                                            get_general_adt_vars rest
                                | None ->(* print_string ("didn't add adt_variable: " ^ fun_decl.fun_name ^ name ^ " \n");*) get_general_adt_vars rest
                              end
                          | _ -> get_general_adt_vars rest
                        end
                | _ -> get_general_adt_vars rest
              end
          | PA.Stmt_assert term -> find_recursive_function_in_term term; get_general_adt_vars rest
          | _ -> get_general_adt_vars rest
        end
    | _ -> ()
  end

let local_acyclicality_axioms term term_ty terms = 
  let rec aux original_term original_term_ty term = 
    begin match term with
      | PA.App (_, terms) ->
          let _ = List.map (aux original_term original_term_ty) terms in
          if ((get_type term) = original_term_ty) then (
            Ctx.add_general_statement ("skip" ^ (string_of_int Ctx.t.skip_counter)) PA.Ty_bool (PA.Stmt_assert (PA.Not (PA.Eq (original_term, term))));
            Ctx.increment_skip_counter ());
          ()
      | PA.Const _ ->
        if ((get_type term) = original_term_ty) then (
          Ctx.add_general_statement ("skip" ^ (string_of_int Ctx.t.skip_counter)) PA.Ty_bool (PA.Stmt_assert (PA.Not (PA.Eq (original_term, term))));
          Ctx.increment_skip_counter ());
        ()
      | _ -> ()
      end in
  let _ = List.map (aux term term_ty) terms in
  ()

let rec create_vars (term: PA.term) : PA.term = 
  begin match Hashtbl.find_opt Ctx.t.context_hashing term with
    | Some value -> PA.Const value 
    | None ->
        match term with
        | True -> True
        | False -> False
        | Const v -> Const v
        | Arith (op, terms) -> 
            let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
            Ctx.increment_vars_created ();
            Ctx.add_new_statement var_name (get_type term) (PA.Arith (op, List.map create_vars terms));
            PA.Const var_name
        | App (s, terms) -> 
          if (!inline_constants && (check_if_constant term)) then (
            (*If our term is a constant, then we don't need to iterate *)
            let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
            Ctx.increment_vars_created ();
            let term_ty = get_type term in
            Ctx.add_new_statement var_name term_ty term;
            local_acyclicality_axioms term term_ty terms;
            (* begin match term_ty with 
              | PA.App (ty_name, _) -> Ctx.add_depth_variable_to_adt ty_name var_name term_ty
              | _ -> raise (UnsupportedQuery ) *)
            PA.Const var_name
          ) else (
            (* if we have a selector applied to the wrong constructor then we can create a  new contrived variable*)
            let use_result, result =
              begin match StrTbl.find_opt Ctx.t.selectors s with 
                | Some (_, cstor, _) ->             
                    begin match terms with 
                      | [App (c, _)] ->
                          begin match StrTbl.find_opt Ctx.t.constructors c with 
                            | Some _->
                                if (cstor.cstor_name <> c) then (
                                    let var_name = "contrived_variable" ^ string_of_int (Ctx.t.vars_created) in
                                    Ctx.increment_vars_created ();
                                    Ctx.add_new_statement var_name (get_type term) term;
                                    true, var_name
                                ) else (false, "")
                            | None -> (false, "")
                          end
                      | _ -> false, ""
                    end  
                  | _ -> false, ""
                end in
                if use_result then (
                  begin match StrTbl.find_opt Ctx.t.recursive_functions s with 
                    | Some (_, _, output, _) -> 
                      begin match (get_type term) with
                        | PA.Ty_app (ty_name, _) -> 
                            Ctx.add_depth_variable_to_adt ty_name result output;
                            PA.Const result
                        | _ -> PA.Const result
                      end
                    | None -> PA.Const result
                  end
                )
                else (
                  let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
                  Ctx.increment_vars_created ();
                  let term_ty = get_type term in
                  let flattened_term = (PA.App (s, List.map create_vars terms)) in 
                  (*have to see if the flattened term has been saved anywhere*)
                  begin match Hashtbl.find_opt Ctx.t.context_hashing flattened_term with 
                    | Some var -> PA.Const var
                    | None ->
                        Ctx.add_new_statement var_name term_ty flattened_term;
                        begin match term_ty with
                          | PA.Ty_app (ty_name, _) -> 
                              begin match (StrTbl.find_opt Ctx.t.selectors s) with
                                | Some (ty, _, _) -> Ctx.add_depth_variable_to_adt ty_name var_name ty
                                | None -> ()
                              end
                          | _ -> ()
                        end;
                        PA.Const var_name
                  end
                )
           )
        | HO_app (_, _) -> raise (UnsupportedQuery "We do not support HO_App")
        | Match (_, _) -> raise (UnsupportedQuery "We should have reduced Match to ITE by now")
        | If (t1, t2, t3) ->
          if !rewrite_ite then (
            let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
            Ctx.increment_vars_created ();
            let v1, v2, v3 = flatten t1, create_vars t2, create_vars t3 in
            Ctx.add_general_statement var_name (get_type t2) (PA.Stmt_assert (PA.Or [PA.And [v1; PA.Eq ((PA.Const var_name), v2)]; PA.And [PA.Not v1; PA.Eq ((PA.Const var_name), v3)]]));
            PA.Const var_name
          ) else (
            (*TODO: Question, do I need to pull out a variable for the ite: I don't think I need to because I pull out for things inside the ite*)
            (* let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
            Ctx.increment_vars_created (); *)
            let v1, v2, v3 = flatten t1, create_vars t2, create_vars t3 in
            (* Ctx.add_general_statement var_name (get_type t2) (PA.Stmt_assert (PA.Eq (PA.Const var_name, If (v1, v2, v3))));
            PA.Const var_name *)
            If (v1, v2, v3)
          )
        | Let (_, _) -> raise (UnsupportedQuery "All Lets should be inlined")
        | Is_a (s, t) -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Is_a (s, create_vars t));
          PA.Const var_name
        | Fun (vt, t) -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Fun (vt, create_vars t));
          PA.Const var_name
        | Eq (t1, t2) -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Eq (create_vars t1, create_vars t2));
          PA.Const var_name
        | Imply (t1, t2) -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (PA.Or [PA.Not (flatten t1); (flatten t2)]);
          PA.Const var_name
        | And terms -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (And (List.map flatten terms)); (* note that we use flatten for and, or, not*)
          PA.Const var_name
        | Or terms ->
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Or (List.map flatten terms)); (* note that we use flatten for and, or, not*)
          PA.Const var_name
        | Not t -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Not (flatten t)); (* note that we use flatten for and, or, not*)
          PA.Const var_name
        | Distinct terms -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Distinct (List.map create_vars terms));
          PA.Const var_name
        | Cast (t, ty) -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Cast (create_vars t, ty));
          PA.Const var_name
        | Forall (_, _) -> raise (UnsupportedQuery "We do not support Forall")
        | Exists (_, _) -> raise (UnsupportedQuery "We do not support Exists")
        | Attr (t, attrs) -> 
          let var_name = "contrived_variable" ^ string_of_int(Ctx.t.vars_created) in
          Ctx.increment_vars_created ();
          Ctx.add_new_statement var_name (get_type term) (Attr (create_vars t, attrs));
          PA.Const var_name
    end

  (* function that takes in a PA.term and flattens it by adding variables for subterms to t.new_statemets using the function create_vars*)
and flatten (term: PA.term) : PA.term =
  begin match Hashtbl.find_opt Ctx.t.context_hashing term with
  | Some value -> PA.Const value 
  | None ->
    match term with
    | True -> True
    | False -> False
    | Const v -> Const v
    | Arith (op, terms) -> PA.Arith (op, (List.map create_vars terms))
    | App (s, terms) -> 
        if (check_if_constant term) then term  
        else App (s, (List.map create_vars terms)) 
    | HO_app (_, _) -> raise (UnsupportedQuery "We do not support HO_App")
    | Match (_, _) -> raise (UnsupportedQuery "We should have reduced Match to ITE by now")
    | If (t1, t2, t3) ->
      if !rewrite_ite then (
        let var_name = "contrived_variable" ^ string_of_int (Ctx.t.vars_created) in
        Ctx.increment_vars_created ();
        let v1, v2, v3 = flatten t1, create_vars t2, create_vars t3 in
        Ctx.add_general_statement var_name (get_type t2) (PA.Stmt_assert (PA.Or [PA.And [v1; PA.Eq ((PA.Const var_name), v2)]; PA.And [PA.Not v1; PA.Eq ((PA.Const var_name), v3)]]));
        PA.Const var_name
      ) else (
        let v1, v2, v3 = flatten t1, create_vars t2, create_vars t3 in
        If (v1, v2, v3)
      )
    | Let (_, _) -> raise (UnsupportedQuery "All Lets should be inlined")
    | Is_a (s, t) -> Is_a (s, create_vars t)
    | Fun (vt, t) -> Fun (vt, create_vars t)
    | Eq (t1, t2) -> 
      Eq (create_vars t1, create_vars t2) (*Note: replaced teh create_vars here with a flatten*)
    | Imply (t1, t2) -> PA.Or [PA.Not (flatten t1); (flatten t2)]
    | And terms -> And (List.map flatten terms) (* also doing flatten instead of create vars for And and Or but not sure if this is fully correct*)
    | Or terms ->  Or (List.map flatten terms)
    | Not t -> Not (flatten t) (*Note: significant that we apply flatten and not create_vars here*)
    | Distinct terms -> Distinct (List.map create_vars terms)
    | Cast (t, ty) -> Cast (create_vars t, ty)
    | Forall (_, _) -> raise (UnsupportedQuery "We do not support Forall")
    | Exists (_, _) -> raise (UnsupportedQuery "We do not support Exists")
    | Attr (t, attrs) -> Attr (create_vars t, attrs)
end

let create_new_statements_declares (keys: string list) : PA.stmt list =
  let rec aux (keys: string list) (acc) =
    begin match keys with
      | key :: rest ->
        let key_type, _ = Ctx.lookup_new_statement key in
        (aux rest (acc @ [PA.Stmt_decl {fun_ty_vars = []; fun_name = key; fun_args = []; fun_ret =  key_type} ]))
        (* if we wanted to do it as a smt_fun_def instead: PA.Stmt_fun_def  {PA.fr_decl={PA.fun_ty_vars=[]; fun_args=[]; fun_name = key; fun_ret=key_type}*)
      | _ -> acc
    end in
  (aux keys [])

let create_new_statements_asserts (keys: string list) =
  let rec aux (keys: string list) (acc) =
    begin match keys with
      | key :: rest ->
        let _, key_term = Ctx.lookup_new_statement key in
        (aux rest (acc @ [PA.Stmt_assert (PA.Eq (PA.Const key, key_term))]))
      | _ -> acc
    end in
  aux keys []

  let create_general_statement_declares (keys: string list) =
    let rec aux (keys: string list) (acc) =
      begin match keys with
        | key :: rest ->
          if (key.[0] = 's') then (aux rest acc)
          else (let key_type, _ = Ctx.lookup_general_statement key in
                (aux rest (acc @ [PA.Stmt_decl {fun_ty_vars = []; fun_name = key; fun_args = []; fun_ret =  key_type} ]))
          )
        | _ -> acc
      end in
    aux keys []

let create_general_statement_asserts (keys: string list) =
  let rec aux (keys: string list) (acc) =
    begin match keys with
      | key :: rest ->
        let _, stmt = Ctx.lookup_general_statement key in
        (aux rest (acc @ [stmt]))
      | _ -> acc
    end in
  aux keys []


(*We need to turn our datatype declarations into the appropriate decl_fun's,
   ,otherwise we won't be able to recognize it in the flatten statement step.
   This is done again in the R$reduce_rules, so it is possible to run just the
   reduction without flattening if we desire*)

let remove_datatype_decl (stmts : PA.stmt list) = 
  let rec aux (stmts : PA.stmt list) acc =
    begin match stmts with
      | stmt :: rest ->
          begin match stmt with
            | PA.Stmt_data data -> let reduced_adt_decl_sorts, reduced_adt_decl_funs = (add_adt_list_to_context data) in
                 (aux rest (acc @ reduced_adt_decl_sorts @ reduced_adt_decl_funs))
            | _ -> (aux rest (acc @ [stmt]))
          end
      | _ -> acc
    end in
  (aux stmts [])

(* Takes in as input a list of statements. Runs flatten on all of them and adds into it the statements
 from new_statements(at the beginning) and general statements (at the end) *)
let flatten_statements (stmts : PA.stmt list) = 
  let rec flatten_statements_helper (stmts: PA.stmt list) fun_decls asserts =
    begin match stmts with
      | stmt :: rest -> 
        begin match stmt with
        | Stmt_fun_def fun_def -> 
          Ctx.add_fun_def fun_def.fr_decl.fun_name (fun_def.fr_decl.fun_ret);
          (flatten_statements_helper rest (fun_decls @ [stmt]) asserts)
        | Stmt_decl fun_decl -> 
          Ctx.add_fun_def fun_decl.fun_name fun_decl.fun_ret;
          (flatten_statements_helper rest (fun_decls @ [stmt]) asserts)
        | Stmt_fun_rec _ -> raise (UnsupportedQuery "We do not support Stmt_fun_rec")
        | Stmt_funs_rec _ -> raise (UnsupportedQuery "We do not support funs_rec_def")
        | Stmt_assert term -> 
            let new_assert = (*if (flatten_peek term) then*) [PA.Stmt_assert (flatten term)] (*else [PA.Stmt_assert term]*) in
            (flatten_statements_helper rest fun_decls (asserts @ new_assert))
        | Stmt_check_sat ->  (flatten_statements_helper rest fun_decls asserts)
        | _ -> (flatten_statements_helper rest (fun_decls @ [stmt]) asserts)
        end
      | _ -> fun_decls, asserts
    end
  in
  let stmts = remove_datatype_decl stmts in
  let flattened_statements_decls, flattened_statement_asserts = flatten_statements_helper stmts [] [] in

  let new_statement_declares = (create_new_statements_declares (StrTbl.keys_list Ctx.t.new_statements)) in 

  let general_statement_declares = (create_general_statement_declares (StrTbl.keys_list Ctx.t.general_statements)) in 
  let new_statement_asserts = (create_new_statements_asserts (StrTbl.keys_list Ctx.t.new_statements)) in 
  let general_statement_asserts = (create_general_statement_asserts (StrTbl.keys_list Ctx.t.general_statements)) in
  
  let final_statements = flattened_statements_decls @ general_statement_declares @ new_statement_declares @
   flattened_statement_asserts @  new_statement_asserts @ general_statement_asserts @ [Stmt_check_sat] in
  final_statements
