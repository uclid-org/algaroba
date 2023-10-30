(* Rewrite: We will rewrite queries selector-constructor or tester-constructor applications back to back *)

module PA = Smtlib_utils.V_2_6.Ast
open Context
exception UnsupportedQuery of string

let assert_conjunctions = ref false
let constant_prop = ref false

let rec cone_of_influence_term (term : PA.term) = 
  begin match term with
    | True -> ()
    | False -> ()
    | Const s -> Ctx.add_to_cone s
    | Arith (_, terms) -> let _ = List.map cone_of_influence_term terms in ()
    | App (s, terms) -> Ctx.add_to_cone s; let _ = List.map cone_of_influence_term terms in ()
    | HO_app _ -> raise (UnsupportedQuery "We do not support HO_App")
    | Match (_, _) -> raise (UnsupportedQuery "We should have reduced Match to ITE by now")
    | If (i,t,e) -> cone_of_influence_term i; cone_of_influence_term t; cone_of_influence_term e; ()
    | Let _ -> raise (UnsupportedQuery "We should have inlined lets by now")
    | Is_a (_, term) -> cone_of_influence_term term
    | Fun (_, term) -> cone_of_influence_term term
    | Eq (left, right) -> cone_of_influence_term left; cone_of_influence_term right
    | Imply (a, b) -> cone_of_influence_term a; cone_of_influence_term b
    | And terms -> let _ = List.map cone_of_influence_term terms in ()
    | Or terms -> let _ = List.map cone_of_influence_term terms in ()
    | Not t -> cone_of_influence_term t
    | Distinct terms -> let _ = List.map cone_of_influence_term terms in ()
    | Cast (t, _) -> cone_of_influence_term t
    | Forall _ -> raise (UnsupportedQuery "We do not support Foralls")
    | Exists _ -> raise (UnsupportedQuery "We do not support Exists")
    | Attr (t, _) -> cone_of_influence_term t
  end
let cone_of_influence stmts =
  let rec helper stmts = (*takes in the statements in reverse order*)
    begin match stmts with
      | stmt :: rest ->
          begin match stmt with
            | PA.Stmt_assert term -> cone_of_influence_term term; stmt :: (helper rest)
            | Stmt_decl fun_decl -> if ((Ctx.in_cone fun_decl.fun_name) || (Ctx.is_adt_selector_constructor_tester fun_decl.fun_name)) then stmt :: (helper rest)
                                    else (helper rest)
            | _ -> stmt :: helper rest
          end
      | _ -> []
    end in
  let pruned_stmts = helper (List.rev stmts) in 
  List.rev pruned_stmts

let is_constant = function
  | Some t -> begin match t with 
                | PA.Const _ -> true 
                | _ -> false
              end
  | None -> false


(*Note we changed the get_adt_vars to only get variables with selectors added onto them; Ex: y = (tail x), we would add x*)
(*Note that constructors essentially have implicit selectors; Ex: y = (cons 1 x); here we add these in R5reduce_rules*)
let rec get_adt_vars_term (term : PA.term) = 
  begin match term with
  | True -> ()
  | False -> ()
  | Const _ -> ()
  | Arith (_, terms) -> let _ = List.map get_adt_vars_term terms in ()
  | App (s, terms) -> 
      begin match StrTbl.find_opt Ctx.t.selectors s with
        | Some (_, cstor, _) ->
              begin match (List.nth_opt terms 0) with
                | Some (PA.Const var) ->
                      if (not (Ctx.in_constructors var)) (*Dont want to count variables that are 0-ary cstors like Nil*)
                      then (
                        let term_ty, _ = StrTbl.find Ctx.t.constructors cstor.cstor_name in
                        (* let term_ty = (get_type term) in  *)
                        begin match term_ty with 
                          | PA.Ty_app (ty_name, _) -> Ctx.add_depth_variable_to_adt ty_name var term_ty
                          | _ -> raise (UnsupportedQuery "Incorrect typed term")
                        end
                      )
                      else ()
                | _ -> let _ = List.map get_adt_vars_term terms in ()
              end
        | None -> let _ = List.map get_adt_vars_term terms in ()
      end
  | HO_app _ -> raise (UnsupportedQuery "We do not support HO_App")
  | Match (_, _) -> raise (UnsupportedQuery "We should have reduced Match to ITE by now")
| If (i,t,e) -> get_adt_vars_term i; get_adt_vars_term t; get_adt_vars_term e; ()
  | Let _ -> raise (UnsupportedQuery "We should have inlined lets by now")
  | Is_a (_, term) -> get_adt_vars_term term
  | Fun (_, term) -> get_adt_vars_term term
  | Eq (left, right) -> get_adt_vars_term left; get_adt_vars_term right
  | Imply (a, b) -> get_adt_vars_term a; get_adt_vars_term b
  | And terms -> let _ = List.map get_adt_vars_term terms in ()
  | Or terms -> let _ = List.map get_adt_vars_term terms in ()
  | Not t -> get_adt_vars_term t
  | Distinct terms -> let _ = List.map get_adt_vars_term terms in ()
  | Cast (t, _) -> get_adt_vars_term t
  | Forall _ -> raise (UnsupportedQuery "We do not support Foralls")
  | Exists _ -> raise (UnsupportedQuery "We do not support Exists")
  | Attr (t, _) -> get_adt_vars_term t
end

(*Go through the entire query and tally the variables that are ADTs*)
let rec get_adt_vars stmts = 
  begin match stmts with
    | stmt :: rest -> 
        begin match stmt with
          | PA.Stmt_assert term -> get_adt_vars_term term; get_adt_vars rest
          | _ -> get_adt_vars rest
        end
    | _ -> ()
  end

let rec is_not (terms : PA.term list) = 
  begin match terms with
    | term :: rest ->
        begin match term with
          | PA.Not (PA.True) -> true
          | PA.False -> true
          | _ -> is_not rest
      end
    | _ -> false
  end


(*function that returns true if a term is an ADT Constant*)
let rec check_if_constant (term: PA.term) : bool =
  begin match term with 
    | PA.Const v ->
        begin match StrTbl.find_opt Ctx.t.constructors v with 
          | Some _ -> true 
          | None -> false 
        end
    | PA.App (f, terms) ->
        begin match StrTbl.find_opt Ctx.t.constructors f with 
          | Some _ -> List.fold_left (fun acc x -> acc && (check_if_constant x)) true terms
          | None -> false 
        end
    | _ -> false
  end



(* function that returns true if it is a ADT constant, but if it is an App, just assumes it is constant*)
(* this is used for when we are check values in a Ctx.t.consants since we know that if it is an App, it is a constant*)
let simplified_check_if_constant (term: PA.term) : bool =
  begin match term with
    | PA.Const v ->
      begin match StrTbl.find_opt Ctx.t.constructors v with 
      | Some _ -> true 
      | None -> false 
    end
    | PA.App _ -> true 
    | _ -> false
  end


(* function that unpacks a PA.Const to a string*)
let replace_const_with_string (term : PA.term) : string = 
  begin match term with
    | PA.Const v -> v 
    | _ -> raise (UnsupportedQuery "was given a non-constant into replace_const_with_string")
  end

let rec rewrite_term (t: PA.term) (toplevel : bool) : (PA.term * bool) = 
  begin match t with
    | PA.Const v ->
        begin match StrTbl.find_opt Ctx.t.constants v with 
          | Some v_s -> v_s, true 
          | _ -> t, false 
        end
    | PA.App (f, terms) -> 
        begin match terms with
          | _ -> 
              begin match StrTbl.find_opt Ctx.t.selectors f with
                | Some (_, cstor, selector_number) -> 
                  begin match (List.nth terms 0) with
                    | PA.App(inner_f, inner_terms) ->
                        if (cstor.cstor_name = inner_f) then ((fst (rewrite_term (List.nth inner_terms selector_number) false)), true)
                        else 
                          let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
                          (PA.App (f, new_terms), continue)
                    | _ -> let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
                            (PA.App (f, new_terms), continue)
                  end
                | None ->
                  begin match StrTbl.find_opt Ctx.t.testers f with
                  | Some (_, cstor) ->
                    begin match (List.nth terms 0) with
                      | PA.Const inner_f ->
                        if (cstor.cstor_name = inner_f) then (PA.True, true)
                        else 
                          (begin match StrTbl.find_opt Ctx.t.constructors inner_f with
                            | Some _ -> (PA.False, true) (*TODO: check if the type of the constructor matches the type of the tester, if not throw an erro*)
                            | None -> let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
                                      (PA.App (f, new_terms), continue)
                          end)
                      | PA.App(inner_f, _) ->
                          if (cstor.cstor_name = inner_f) then (PA.True, true)
                          else 
                            (begin match StrTbl.find_opt Ctx.t.constructors inner_f with
                              | Some _ -> (PA.False, true) (*TODO: check if the type of the constructor matches the type of the tester, if not throw an erro*)
                              | None -> let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
                                        (PA.App (f, new_terms), continue)
                            end)
                      | PA.If (a, b, c) ->
                          (* do the hoiting thing with ite and testers*)
                          let rewrite_b, _ = (rewrite_term (PA.App (f, [b])) false) in 
                          let rewrite_c, _ = (rewrite_term (PA.App (f, [c])) false) in
                          (PA.If (a, rewrite_b, rewrite_c)), true
                      | _ -> let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
                            (PA.App (f, new_terms), continue)
                    end
                  | None -> let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
                            (PA.App (f, new_terms), continue)
                  end
              end
            end
    | Is_a (name, t) -> rewrite_term (PA.App ("is-" ^ name, [t])) false (* turning selectors into unintepreted functions; Originally done in R4 normalize, but I added it here because necessary*)
    | Arith (op, terms) ->
        let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
        (PA.Arith (op, new_terms), continue)
    | Match (_, _) -> raise (UnsupportedQuery "We should have reduced Match to ITE by now")
    | If(a, b, c) ->
        begin match a with
         | PA.True -> 
            let b_term, _ = rewrite_term b false in 
            b_term, true
         | PA.False ->
            let c_term, _ = rewrite_term c false in 
            c_term, true
         | _ ->
            let a_term, a_continue = rewrite_term a false in 
            let b_term, b_continue = rewrite_term b false in 
            let c_term, c_continue = rewrite_term c false in 
            (If (a_term, b_term, c_term)), (a_continue || b_continue || c_continue)
         end
    | Eq (a, b) ->
      if (a = b) then PA.True, true (*if two terms are equal then we immediately replace them with true*)
      else (if ((check_if_constant a) && (check_if_constant b)) then (PA.False, true)
            else (
              let do_constant_merging = 
              if (!constant_prop && toplevel) then (
              (* print_string "in this with: "; stmt_printer [(PA.Stmt_assert a); (PA.Stmt_assert b)]; *)
              begin match a with 
                | PA.Const a_const ->
                  begin match b with 
                    | PA.Const b_const ->
                        begin match (StrTbl.find_opt Ctx.t.constants a_const) with 
                          | Some (a_s) ->
                            begin match (StrTbl.find_opt Ctx.t.constants b_const) with 
                              | Some (b_s) -> 
                                  if (not (simplified_check_if_constant a_s))
                                  then (
                                      (* a is not a constant and b may or may not be a constant*)
                                      (* print_endline ("1. rewriting with a: " ^ a_const ^ " and b: " ^ b_const); *)
                                      StrTbl.replace Ctx.t.constants a_const b_s;
                                      StrTbl.replace Ctx.t.constants (replace_const_with_string a_s) b_s;
                                      0
                                  ) else (
                                    if (not (simplified_check_if_constant b_s))
                                    then (
                                      (*b is not a constant but a is a constant*)
                                      (* print_endline ("2. rewriting with a: " ^ a_const ^ " and b: " ^ b_const); *)
                                      StrTbl.replace Ctx.t.constants b_const a_s;
                                      StrTbl.replace Ctx.t.constants (replace_const_with_string b_s) a_s;
                                      0
                                    ) else (
                                      1
                                    )
                                  )
                                  (* begin match (StrTbl.find_opt Ctx.t.constructors a_const) with
                                    | Some (_, _) -> 
                                      StrTbl.replace Ctx.t.constants b_const a_s;
                                      StrTbl.replace Ctx.t.constants b_s a_s;
                                      0
                                    | _ ->
                                      StrTbl.replace Ctx.t.constants a_const b_s;
                                      StrTbl.replace Ctx.t.constants a_s b_s;
                                      0
                                  end *)
                              | None ->
                                  (* print_endline ("3. rewriting with a: " ^ a_const ^ " and b: " ^ b_const); *)
                                  StrTbl.replace Ctx.t.constants b_const a_s;
                                  0
                            end
                          | None -> 
                            begin match (StrTbl.find_opt Ctx.t.constants b_const) with 
                              | Some (b_s) ->
                                  (* print_endline ("4. rewriting with a: " ^ a_const ^ " and b: " ^ b_const); *)
                                  StrTbl.replace Ctx.t.constants a_const b_s;
                                  0
                              | None -> 
                                begin match (StrTbl.find_opt Ctx.t.constructors a_const) with
                                  | Some _ ->
                                    (* print_endline ("5. rewriting with a: " ^ a_const ^ " and b: " ^ b_const); *)
                                    StrTbl.replace Ctx.t.constants b_const a;
                                    0
                                  | _ ->
                                    (* print_endline ("6. rewriting with a: " ^ a_const ^ " and b: " ^ b_const); *)
                                    StrTbl.replace Ctx.t.constants a_const b;
                                    0
                                end
                            end
                        end
                    | _ -> 
                      if (check_if_constant b) then (  
                          begin match (StrTbl.find_opt Ctx.t.constants a_const) with 
                            | Some a_s -> 
                              if (simplified_check_if_constant a_s) then 
                                (if (a_s = b) then 0 else 1)
                              else (
                              (* print_endline ("7. rewriting with a: " ^ a_const ^ " and b: constant"); *)
                              StrTbl.replace Ctx.t.constants (replace_const_with_string a_s) b;
                              StrTbl.replace Ctx.t.constants a_const b;
                              0
                              )
                            | _ -> 
                              (* print_endline ("8. rewriting with a: " ^ a_const ^ " and b: constant"); *)
                              StrTbl.replace Ctx.t.constants a_const b;
                              0
                          end;
                      ) else 2
                  end
                | _ -> 
                  begin match b with 
                    | PA.Const b_const -> 
                      if (check_if_constant a && (not (check_if_constant b))) then (
                        StrTbl.replace Ctx.t.constants b_const a;
                        begin match (StrTbl.find_opt Ctx.t.constants b_const) with 
                          | Some b_s -> 
                              (* print_endline ("10. rewriting with a: constant" ^ " and b: " ^ b_const); *)
                              if (check_if_constant b_s) then (
                                if (b_s = a) then 0 else 1
                              )
                              else ((StrTbl.replace Ctx.t.constants (replace_const_with_string b_s) a); 0)
                          | _ -> 
                            (* print_endline ("11. rewriting with a: constant" ^ " and b: " ^ b_const); *)
                            0
                        end    
                    ) else 2            
                    | _ -> 2
                  end
              end) else 2 in 
              if (do_constant_merging = 0) then (PA.True, true)
              else (if (do_constant_merging = 1) then (PA.False, true)
              else (
                  (*if we have two of the same constructor applications on LHS and RHS and they are equal then we rewrite the terms as equal*)
                  begin match a with
                    | PA.App (f_a, a_terms) ->
                        begin match b with 
                          | PA.App (f_b, b_terms) ->
                            if (f_a = f_b) then (
                              begin match StrTbl.find_opt Ctx.t.constructors f_a with
                                | Some _ -> 
                                  let rewritten_a_terms, a_terms_continue = 
                                    List.fold_left (fun acc term -> 
                                      let a_term, a_continue = rewrite_term term false in
                                      (a_term :: (fst acc), a_continue || (snd acc))
                                      ) ([], false) a_terms in
                                  let rewritten_b_terms, b_terms_continue = 
                                    List.fold_left (fun acc term -> 
                                      let b_term, b_continue = rewrite_term term false in
                                      (b_term :: (fst acc), b_continue || (snd acc))
                                      ) ([], false) b_terms in
                                    (PA.And (List.map2 (fun x y -> (PA.Eq (x, y))) rewritten_a_terms rewritten_b_terms)), (a_terms_continue || b_terms_continue)
                                | None ->
                                  let a_term, a_continue = rewrite_term a false in 
                                  let b_term, b_continue = rewrite_term b false in 
                                  (Eq (a_term, b_term)), (a_continue || b_continue)
                              end
                            ) else (
                              let a_term, a_continue = rewrite_term a false in 
                              let b_term, b_continue = rewrite_term b false in 
                              (Eq (a_term, b_term)), (a_continue || b_continue)
                            )
                    | _ ->
                        let a_term, a_continue = rewrite_term a false in 
                        let b_term, b_continue = rewrite_term b false in 
                        (Eq (a_term, b_term)), (a_continue || b_continue)
                    end
                    |_ -> 
                      let a_term, a_continue = rewrite_term a false in 
                      let b_term, b_continue = rewrite_term b false in 
                      (Eq (a_term, b_term)), (a_continue || b_continue)
                    end
              )
            )
          )
      )
    | Imply (a, b) ->
      if (a = PA.True) then (
        let b_term, _ = rewrite_term b false in 
        b_term, true
      ) else (if (a = PA.False) then PA.True, true
      else (
      let a_term, a_continue = rewrite_term a false in 
      let b_term, b_continue = rewrite_term b false in 
      (Imply (a_term, b_term)), (a_continue || b_continue)
      ))
    | And terms ->
      if (is_not terms) then (PA.False, true)
      else
        (let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x toplevel) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
        ((PA.And new_terms), continue))
    | Or terms ->
      let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
      (PA.Or new_terms), continue
    | Not term -> 
        let new_term, continue = rewrite_term term false in 
        (PA.Not new_term), continue
    | Distinct terms ->
      let new_terms, continue = List.fold_left (fun (acc1, acc2) x -> (let a, b = (rewrite_term x false) in ((acc1 @ [a]), (acc2 || b)))) ([], false) terms in 
      (PA.Distinct new_terms), continue
    | Attr (t, attributes) ->
      let new_term, continue = rewrite_term t false in 
      (Attr (new_term, attributes)), continue
    | _ -> t, false
  end

let rewrite_iteration (stmts : PA.stmt list) = (*TODO: this will do some funky things with the statement ordering that will not work on certain queries*)
  let rec aux stmts acc start_statements (change : bool) = 
    begin match stmts with
      | stmt :: rest ->
        begin match stmt with
          | PA.Stmt_data _ -> raise (UnsupportedQuery "Should have already removed datatypes in the inline stage.")
          | PA.Stmt_assert t ->  
              let new_term, continue = rewrite_term t true in
              let new_asserts =
                match new_term with
                | And children when !assert_conjunctions ->
                    List.map (fun x -> PA.Stmt_assert x) children
                | _ -> [PA.Stmt_assert new_term]
              in
              aux rest (acc @ new_asserts) start_statements (change || continue)
          | PA.Stmt_set_info _ -> aux rest (acc) (start_statements @ [stmt]) change
          | PA.Stmt_set_logic _ -> aux rest (acc) (start_statements @ [stmt]) change
          | _ -> aux rest (acc @ [stmt]) start_statements change
        end
      | _ -> acc, start_statements, change
    end in 
  aux stmts [] [] false



let rewrite_statements start_statements stmts = 
  let rec rewrite_statements_helper stmts start_stmts = 
    let new_statements, start_statements, continue = rewrite_iteration stmts in 
    if continue then (rewrite_statements_helper new_statements (start_stmts @ start_statements))
    else start_stmts @ start_statements @ new_statements
  in 
  let new_statements = rewrite_statements_helper stmts [] in
  let new_statements = start_statements @ new_statements in
  let pruned_statements = cone_of_influence new_statements in
  let _ = get_adt_vars pruned_statements in
  pruned_statements
