(* Given a flat NNF formula where we already reduced the Rules in R4, we want to
   add in extra axioms saying: 1. Each ADT term can only be satisfied by a
   single tester 2. There are no ADT cycles*)

   module PA = Smtlib_utils.V_2_6.Ast
   open R3flatten
   open Context
   
   exception UnsupportedQuery of string
   (* open Z3 open Z3.Symbol open Z3.Sort open Z3.Expr open Z3.Boolean open
      Z3.FuncDecl open Z3.Goal open Z3.Tactic open Z3.Tactic.ApplyResult open
      Z3.Probe open Z3.Solver open Z3.Arithmetic open Z3.Arithmetic.Integer open
      Z3.Arithmetic.Real open Z3.BitVector *)
   
   (*Step 1: Go through the entire query and tally the variables that are ADTs ->
     moved to R2rewrite*)
   
   (* Step 2: Use list of vars to implement tester axiom*)

  let print_depths = ref false
   
   let get_tester_axiom_term var_name (cstor_list : PA.cstor list) not_placement =
     let rec aux var_name (cstor_list : PA.cstor list) not_placement acc =
       match cstor_list with
       | cstor :: rest ->
           if not_placement = 1 then
             aux var_name rest (not_placement - 1)
               (acc @ [PA.App ("is-" ^ cstor.cstor_name, [PA.Const var_name])])
           else
             aux var_name rest (not_placement - 1)
               ( acc
               @ [PA.Not (PA.App ("is-" ^ cstor.cstor_name, [PA.Const var_name]))]
               )
       | _ -> acc
     in
     aux var_name (cstor_list : PA.cstor list) not_placement []
   
   (*Note: I am only currently doing this with constants, but I may need to do this
     with all constructors. Don't think I need this will all constructors*)
   let rec get_tester_and value cstor_list not_placement =
     if not_placement = 1 then
       [PA.And (get_tester_axiom_term value cstor_list not_placement)]
     else
       PA.And (get_tester_axiom_term value cstor_list not_placement)
       :: get_tester_and value cstor_list (not_placement - 1)
   
   (*This is a version of get_tester_and that uses the z3 at-most contraint*)
   let z3_get_tester_and value (cstor_list : PA.cstor list) =
     let list_of_tester_apps =
       List.map
         (fun (cstor : PA.cstor) ->
           PA.App ("is-" ^ cstor.cstor_name, [PA.Const value]) )
         cstor_list
     in
     let at_most_constraint = PA.App ("(_ at-most 1)", list_of_tester_apps) in
     let or_constraint = PA.Or list_of_tester_apps in
     [PA.Stmt_assert at_most_constraint; PA.Stmt_assert or_constraint]
   
   let tester_with_constructor (value : string) (cstor_list : PA.cstor list) =
     let rec aux (value : string) (cstor_list : PA.cstor list) acc =
       match cstor_list with
       | cstor :: rest ->
           if cstor.cstor_args = [] then
             let term =
               PA.Stmt_assert
                 (PA.Imply
                    ( PA.App ("is-" ^ cstor.cstor_name, [PA.Const value])
                    , PA.Eq (PA.Const value, PA.Const cstor.cstor_name) ) )
             in
             aux value rest (acc @ [term])
           else aux value rest acc
       | _ -> acc
     in
     aux value cstor_list []
   
   let get_tester_axioms values (cstor_list : PA.cstor list) adt_name =
     let rec aux values (cstor_list : PA.cstor list) acc =
       match values with
       | value :: rest ->
           if not (Ctx.is_constructor value) then
             match StrTbl.find_opt Ctx.t.enum_adts adt_name with
             | Some (cstor_list, _) ->
                 let current_stmt =
                   PA.Stmt_assert
                     (PA.Or
                        (List.map
                           (fun (cstor : PA.cstor) ->
                             PA.Eq (PA.Const cstor.cstor_name, PA.Const value) )
                           cstor_list ) )
                 in
                 aux rest cstor_list (acc @ [current_stmt])
             | None ->
                 let tester_cstor_axioms =
                   tester_with_constructor value cstor_list
                 in
                 (* let axioms = [PA.Stmt_assert (PA.Or (get_tester_and value
                    cstor_list (List.length cstor_list)))] @ tester_cstor_axioms
                    in *)
                 let tester_and =
                   if Ctx.t.at_most_axiom then z3_get_tester_and value cstor_list
                   else
                     [ PA.Stmt_assert
                         (PA.Or
                            (get_tester_and value cstor_list
                               (List.length cstor_list) ) ) ]
                 in
                 let axioms = tester_and @ tester_cstor_axioms in
                 aux rest cstor_list (acc @ axioms)
           else aux rest cstor_list acc
       | _ -> acc
     in
     aux values cstor_list []
   
   let generate_tester_axioms keys =
     let rec aux keys acc =
       match keys with
       | key :: rest ->
           let values, _ = StrTbl.find Ctx.t.adt_with_all_variables key in
           let constructor_list = StrTbl.find Ctx.t.adts key in
           let tester_axioms = get_tester_axioms values constructor_list key in
           aux rest (acc @ tester_axioms)
       | _ -> acc
     in
     aux keys []

  (*Step 3: Find the finite ADTs and instantiate an axiom that says each element of a finite ADT is one of the things from the universe*)

  (*Cartesian product helper function*)
  let cartesian_product lists =
    let rec aux acc lists =
      match lists with
      | [] -> acc
      | list :: rest ->
          let new_acc = List.flatten (List.map (fun x -> List.map (fun y -> x :: y) acc) list) in
          aux new_acc rest
    in aux [[]] (List.rev lists)
  
  

  (*helper function that given a constructor name and a list of lists of arguments, constructs all possible arguments in those respective positions*)
  let construct_all_terms (cstor_name) (term_list_list: (PA.term list) list) = 
    (* let rec helper cstor_name terms (term_list_list) =
      begin match term_list_list with 
        | fst :: rest -> List.flatten (List.map (fun term -> helper cstor_name (terms @ [term]) rest) fst)
        | [] -> [PA.App (cstor_name, terms)]
      end in  *)
    let cartesian_product_terms = cartesian_product term_list_list in 
    List.map (fun x -> PA.App (cstor_name, x)) cartesian_product_terms
    
    (* helper cstor_name [] term_list_list *)

        
  let get_name ty =
    begin match ty with 
      | PA.Ty_app (f, _) -> f 
      | _ -> raise (UnsupportedQuery "Not given a Ty_app")
    end

  let rec check_cstors_finite (cstors : PA.cstor list) = 
    begin match cstors with 
      | cstor :: rest ->
          if (List.fold_left (fun acc x -> acc && (StrTbl.mem Ctx.t.finite_adts (get_name (snd x)))) true cstor.cstor_args) then (check_cstors_finite rest)
          else false
      | _ -> true
    end
      

  let add_to_finite_adts adt = 
    if (StrTbl.mem Ctx.t.finite_adts adt) then false
    else (
      begin match StrTbl.find_opt Ctx.t.enum_adts adt with
        | Some (constructors, _) -> StrTbl.replace Ctx.t.finite_adts adt (List.map (fun (x : PA.cstor) -> (PA.const x.cstor_name)) constructors); true
        | None ->
            begin match StrTbl.find_opt Ctx.t.adts adt with 
              | Some cstors -> 
                  if (check_cstors_finite cstors) then (
                    let adt_terms = List.flatten (List.map 
                                                    (fun (cstor: PA.cstor) -> (construct_all_terms cstor.cstor_name (List.map (fun x -> (StrTbl.find Ctx.t.finite_adts (get_name (snd x)))) cstor.cstor_args))) 
                                                    cstors) in
                    StrTbl.replace Ctx.t.finite_adts adt adt_terms;
                    true
                  )
                  else false
              | None -> raise (UnsupportedQuery "We somehow did not add an adt to Ctx.t.adts")
            end
        end
    )

  let rec find_finite_adts_iteration adts = 
    begin match adts with
      | adt :: rest -> 
          let rest_iteration = find_finite_adts_iteration rest in 
          (add_to_finite_adts adt) || rest_iteration
      | _ -> false
    end
  
  let rec find_finite_adts adts = 
    let found = find_finite_adts_iteration adts in 
    if found then (find_finite_adts adts)
    else ()

  let rec finite_adt_axioms adt variables : PA.stmt list = 
    begin match variables with 
      | variable :: rest ->
          let finite_adts = (StrTbl.find Ctx.t.finite_adts adt) in
          let equalities = List.map (fun x -> (PA.Eq ((PA.Const variable), x))) finite_adts in
          let assert_stmt = (PA.Stmt_assert (PA.Or equalities)) in 
          assert_stmt :: (finite_adt_axioms adt rest)
      | _ -> []
    end

  
  
  let generate_finite_adt_axioms () : PA.stmt list = 
    find_finite_adts (StrTbl.keys_list Ctx.t.adts);
    let adts_for_axioms = List.filter (fun x -> not (StrTbl.mem Ctx.t.enum_adts x)) (StrTbl.keys_list Ctx.t.finite_adts) in
    let asserts = List.flatten (List.map (fun adt ->  
                                            (finite_adt_axioms adt (match (StrTbl.find_opt Ctx.t.adt_with_all_variables adt) with 
                                                                      | Some (variables, _) -> variables
                                                                      | None -> []))) 
                                                                      adts_for_axioms) in
    asserts

    
   
   (* Step 4: Use list of vars to implement acyclicality axiom*)
   
   let generate_disequalities term (term_ty : PA.ty) parents guards =
     if parents = [] then ()
     else
       let parent_term, parent_ty = fst (List.nth parents 0) in
       if parent_ty = term_ty then
         let stmt =
           PA.Stmt_assert
             (PA.Imply (PA.And guards, PA.Not (PA.Eq (term, parent_term))))
         in
         Ctx.add_axiom stmt
       else ()
   
   let generate_acyclicality_axioms_term term term_ty min_depth max_depth selector_list =
     let rec loop stack =
       match stack with
       | [] -> ()
       | (term, term_ty, selection_depth, selector_list, parents, guards) :: rest
         -> (
           if
             List.length selector_list = 0
             && selection_depth - max_depth <= min_depth
           then generate_disequalities term term_ty parents guards ;
           (*NOTE: I did not have the if here before and this created multiple of
             the same axioms*)
           if selection_depth = 0 then (loop [@tailcall]) rest
           else
             match selector_list with
             | (selector_name, selector_ty, cstor_name) :: selectors' -> (
               match selector_ty with
               | PA.Ty_app (adt_name, _) -> (
                 match StrTbl.find_opt Ctx.t.adt_with_selectors adt_name with
                 | Some new_selectors ->
                     let new_parents =
                       if List.length parents = 0 then
                         [((term, term_ty), "is-" ^ cstor_name)]
                       else parents
                     in
                     (loop [@tailcall])
                       ( ( PA.App (selector_name, [term])
                         , selector_ty
                         , selection_depth - 1
                         , new_selectors
                         , new_parents
                         , PA.App ("is-" ^ cstor_name, [term]) :: guards )
                       :: ( term
                          , term_ty
                          , selection_depth
                          , selectors'
                          , parents
                          , guards )
                       :: rest )
                 | None ->
                     (loop [@tailcall])
                       ( ( term
                         , term_ty
                         , selection_depth
                         , selectors'
                         , parents
                         , guards )
                       :: rest ) )
               | _ ->
                   (loop [@tailcall])
                     ( (term, term_ty, selection_depth, selectors', parents, guards)
                     :: rest ) )
             | _ -> (loop [@tailcall]) rest )
     in
     loop [(term, term_ty, max_depth, selector_list, [], [])]
   

   let generate_recursive_functions_up_to_depth depth context sorts func_decls =
      let rec aux depth context sorts func_decls =
        if (depth = 0) then ()
        else 
          let iteration = Ctx.unroll_recursive_functions context sorts func_decls in 
          Ctx.add_axioms iteration;
          aux (depth -1) context sorts func_decls
        in 
      aux depth context sorts func_decls

   let generate_acyclicality_axioms_adt terms_with_ty start_depth end_depth
       (selector_list : (string * PA.ty * string) list) =
     let rec aux terms_with_ty min_depth max_depth
         (selector_list : (string * PA.ty * string) list) =
       match terms_with_ty with
       | value :: rest ->
           let _ =
             generate_acyclicality_axioms_term (fst value) (snd value)
               min_depth max_depth selector_list
           in
           aux rest min_depth max_depth selector_list
       | _ -> ()
     in
     aux terms_with_ty start_depth end_depth selector_list (*acyclicality part*)
     (*generate_recursive_functions_up_to_depth (end_depth - start_depth) (*recursive function part*)*)
   
   let generate_selector_list (constructor_list : PA.cstor list) =
     let rec aux constructor_list acc =
       match (constructor_list : PA.cstor list) with
       | cstor :: rest ->
           aux rest
             ( acc
             @ List.map (fun (x, y) -> (x, y, cstor.cstor_name)) cstor.cstor_args
             )
       | _ -> acc
     in
     aux constructor_list []
   
   let rec create_selector_values keys =
     match keys with
     | key :: rest ->
         let thing = generate_selector_list (StrTbl.find Ctx.t.adts key) in
         StrTbl.add Ctx.t.adt_with_selectors key thing ;
         create_selector_values rest
     | _ -> ()
   
   let generate_depths () =
     Ctx.find_max_depths () ;
     let depths_list = List.map
                          (fun key -> (key, string_of_int (Ctx.get_vertex_weight key)))
                          (StrTbl.keys_list Ctx.t.adts)
    in
    if !print_depths then (
        output_string stderr "{";
        let _ = List.map (fun key_weight -> output_string stderr ((fst key_weight) ^ ": " ^ (snd key_weight) ^ ", ")) depths_list in
        output_string stderr "}";
        flush stderr;);
    let int_depths_list = List.map (fun x -> (int_of_string (snd x))) depths_list in
    depths_list, int_depths_list

    let is_prefix ~prefix str =
      let prefix_len = String.length prefix in
      let str_len = String.length str in
      if prefix_len > str_len then false
      else
        let rec loop i =
          if i = prefix_len then true
          else if String.get prefix i <> String.get str i then false
          else loop (i + 1)
        in
        loop 0
   
   let generate_acyclicality_axioms_up_to_stop_depth keys stop_depth =
    let rec aux keys =
      match keys with
      | key :: rest ->
          let values, ty = StrTbl.find Ctx.t.adt_with_depth_variables key in
          print_endline "GENERATING FOR THESE VALUES: "; print_string_list (List.map fst values); print_string_list (List.map (fun x -> (string_of_int (snd x))) values);
          let values_len = Ctx.get_vertex_weight key in
          let stop =
            if stop_depth <= 0 || stop_depth > values_len + 1 then values_len + 1
            else stop_depth
          in
          let constructor_list = StrTbl.find Ctx.t.adts key in
          let selector_list = generate_selector_list constructor_list in
          let _ = create_selector_values (StrTbl.keys_list Ctx.t.adts) in
          let _ =
            List.map 
              (fun x ->
                   if ((snd x) < stop) then (print_endline ("GENERATING ACYCLIC AXIOM FOR " ^ (fst x) ^ " from " ^ (string_of_int (snd x)) ^ " to " ^ (string_of_int stop));generate_acyclicality_axioms_adt [(PA.Const (fst x), ty)] (snd x)
               stop selector_list)) values in
          let _ = Ctx.update_depth stop_depth key
          in
          print_endline "END";
          aux rest
      | _ -> []
    in
    let _ = aux keys in
    ()

   let generate_acyclicality_axioms keys start_depth stop_depth =
     let rec aux keys =
       match keys with
       | key :: rest ->
           let values, ty = StrTbl.find Ctx.t.adt_with_depth_variables key in
           let values_len = Ctx.get_vertex_weight key in
           let stop =
             if stop_depth <= 0 || stop_depth > values_len + 1 then values_len + 1
             else stop_depth
           in
           let constructor_list = StrTbl.find Ctx.t.adts key in
           let selector_list = generate_selector_list constructor_list in
           let _ = create_selector_values (StrTbl.keys_list Ctx.t.adts) in
           let _ =
             generate_acyclicality_axioms_adt
               (List.map (fun x -> (PA.Const (fst x), ty)) values)
               start_depth stop selector_list
           in
           aux rest
       | _ -> []
     in
     (* Ctx.find_max_depths (); let depths_list = List.map (fun key -> (key,
        string_of_int (Ctx.get_vertex_weight key))) (StrTbl.keys_list Ctx.t.adts)
        in *)
     (* print_string "{"; let _ = List.map (fun key_weight -> print_string ((fst
        key_weight) ^ ": " ^ (snd key_weight) ^ ", ")) depths_list in print_string
        "}"; *)
     let _ = aux keys in
     ()
   
   (* Step 4: Add these extra axioms to the end of our query*)
   let reduce_axioms_with_depths stmts =
     get_general_adt_vars stmts ;
     let acyclicality_keys = StrTbl.keys_list Ctx.t.adt_with_depth_variables in
     let tester_keys = StrTbl.keys_list Ctx.t.adt_with_all_variables in
     let tester_axioms = generate_tester_axioms tester_keys in
     let finite_adt_axioms = generate_finite_adt_axioms () in
     let depths_list, _ = generate_depths () in
     let _ = generate_acyclicality_axioms acyclicality_keys 0 (-1) in
     ( depths_list
     , [PA.Stmt_set_logic Ctx.t.set_logic] @ stmts @ tester_axioms @ finite_adt_axioms @ Ctx.t.axioms
     )
   
   let reduce_axioms stmts =
     let _, new_stmts = reduce_axioms_with_depths stmts in
     new_stmts