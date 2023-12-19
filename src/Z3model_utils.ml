(* helper functions for opearting on z3 models*)

module PA = Smtlib_utils.V_2_6.Ast
open Context
open Z3
open Containers

open R6reduce_axioms
open Z3_utils

exception UnsupportedQuery of string

module StrTbl = CCHashtbl.Make (CCString)


(* A version of generate disequalities & acyclicality_axioms_term that won't put things in Ctx.t.axioms, and instead returns them*)

let generate_disequalities_return term (term_ty : PA.ty) parents guards =
  if (List.is_empty parents) then []
  else
    let parent_term, parent_ty = fst (List.nth parents 0) in
    if (ty_equal parent_ty term_ty) then
      let stmt =
        PA.Stmt_assert
          (PA.Imply (PA.And guards, PA.Not (PA.Eq (term, parent_term))))
      in
      [stmt]
    else []

let generate_acyclicality_axioms_term_return term term_ty min_depth max_depth selector_list =
  let rec loop stack axioms =
    match stack with
    | [] -> axioms
    | (term, term_ty, selection_depth, selector_list, parents, guards) :: rest
      -> (
        let new_axioms = 
                (if
                  List.length selector_list = 0
                  && selection_depth - max_depth <= min_depth
                then generate_disequalities_return term term_ty parents guards
                else []) in
        (*NOTE: I did not have the if here before and this created multiple of
          the same axioms*)
        if selection_depth = 0 then (loop [@tailcall]) rest (new_axioms @ axioms)
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
                    :: rest ) (new_axioms @ axioms)
              | None ->
                  (loop [@tailcall])
                    ( ( term
                      , term_ty
                      , selection_depth
                      , selectors'
                      , parents
                      , guards )
                    :: rest ) (new_axioms @ axioms))
            | _ ->
                (loop [@tailcall])
                  ( (term, term_ty, selection_depth, selectors', parents, guards)
                  :: rest ) (new_axioms @ axioms))
          | _ -> (loop [@tailcall]) rest (new_axioms @ axioms))
  in
  loop [(term, term_ty, max_depth, selector_list, [], [])] []


(*we have to use some sort of stack rip to avoid tail recursision since the depths can branch*)
let find_one_cycle original_term original_term_ty max_depth model selector_list ctx func_decls sorts  =
  let z3_original_term = convert_smt_to_z3_term ctx func_decls sorts original_term in 
  let rec loop stack =
    match stack with
      | [] -> [], false
      | (term, term_ty, selection_depth, selector_list, guards) :: rest
        -> (
        (* print_string ("Checking "); stmt_printer [PA.Stmt_assert term]; print_string ("at a depth " ^ (string_of_int selection_depth)); *)
        let z3_term = convert_smt_to_z3_term ctx func_decls sorts term in
        let z3_term_ty = convert_smt_to_z3_ty ctx sorts term_ty in
        let z3_selector_list = List.map (fun (selector_name, selector_ty, _) -> selector_ty, Z3.FuncDecl.mk_func_decl_s ctx selector_name [z3_term_ty] (convert_smt_to_z3_ty ctx sorts selector_ty)) selector_list in
        let one_applications = List.filter_map 
                                  (fun selector -> if (ty_equal (fst selector) term_ty) then Some (Z3.Expr.mk_app ctx (snd selector) [z3_term]) else None) z3_selector_list in 
        (*I don't know if Z3.Expr.equal will work in the way that I want it to*)
        let equality_to_check = List.fold_left 
                                  (fun acc one_application -> 
                                    acc || 
                                    begin match (Z3.Model.eval model (Z3.Boolean.mk_and ctx ((Z3.Boolean.mk_eq ctx one_application z3_original_term) :: guards)) false) with 
                                      | Some value -> 
                                          if (Z3.Boolean.is_true value) then (true)
                                          else (
                                            if (Z3.Boolean.is_false value) then false
                                            else (raise (UnsupportedQuery "Model evaluates to something that is not true or false"))
                                          )
                                      | None -> raise (UnsupportedQuery "Model cannot evaluate and equality")
                                    end)
                                  false one_applications in
        if (equality_to_check) then (
          print_string "we get a cycle on the term: "; stmt_printer [PA.Stmt_assert term]; print_string "while compared to: "; stmt_printer [PA.Stmt_assert original_term];
          (*TODO: right now this just adds in duplicate axioms if we already instatiated up to a smaller depth*)
          let new_axioms = generate_acyclicality_axioms_term_return original_term original_term_ty 0 (max_depth - selection_depth + 1) selector_list, true in
          print_string "adding the axioms: "; stmt_printer (fst new_axioms);
          new_axioms
        ) else (
          if selection_depth = 0 then (loop [@tailcall]) rest
          else
            match selector_list with
            | (selector_name, selector_ty, cstor_name) :: selectors' -> (
              match selector_ty with
              | PA.Ty_app (adt_name, _) -> (
                match StrTbl.find_opt Ctx.t.adt_with_selectors adt_name with
                | Some new_selectors ->
                    (loop [@tailcall])
                      ( ( PA.App (selector_name, [term])
                        , selector_ty
                        , selection_depth - 1
                        , new_selectors
                        (*TODO: I think selector_ty here might be the wrong thing*)
                        ,  Z3.Expr.mk_app ctx (FuncDecl.mk_func_decl_s ctx ("is-" ^ cstor_name) [(convert_smt_to_z3_ty ctx sorts selector_ty)] (Z3.Boolean.mk_sort ctx)) [(convert_smt_to_z3_term ctx func_decls sorts term)] :: guards)
                      :: ( term
                        , term_ty
                        , selection_depth
                        , selectors'
                        , guards)
                      :: rest )
                | None ->
                    (loop [@tailcall])
                      ( ( term
                        , term_ty
                        , selection_depth
                        , selectors'
                        , guards)
                      :: rest ) )
              | _ ->
                  (loop [@tailcall])
                    ( (term, term_ty, selection_depth, selectors', guards)
                    :: rest ) )
            | _ -> (loop [@tailcall]) rest ))
  in
  loop [(original_term, original_term_ty, max_depth, selector_list, [])]


let find_cycles_in_model_adt terms_with_ty max_depth (selector_list : (string * PA.ty * string) list) model ctx func_decls sorts =
  let rec aux terms_with_ty max_depth (selector_list : (string * PA.ty * string) list) =
    match terms_with_ty with
    | value :: rest ->
        let new_axioms, found_cycle = find_one_cycle (fst value) (snd value) max_depth model selector_list ctx func_decls sorts
        in
        if (not found_cycle) then aux rest max_depth selector_list
        else (print_string "found loop"; stmt_printer new_axioms;
              new_axioms, true)
    | _ -> [], false
  in
  aux terms_with_ty max_depth selector_list 

let find_cycles_in_model keys model ctx func_decls sorts =
  let rec aux keys =
    match keys with
    | key :: rest ->
        let values, ty = StrTbl.find Ctx.t.adt_with_depth_variables key in
        let values_len = Ctx.get_vertex_weight key in
        (* print_endline (" For " ^ key ^ " we have a depth of " ^ (string_of_int values_len)); *)
        let stop = values_len in
        let constructor_list = StrTbl.find Ctx.t.adts key in
        let selector_list = generate_selector_list constructor_list in
        let _ = create_selector_values (StrTbl.keys_list Ctx.t.adts) in
        let new_axioms, found_cycle =
          find_cycles_in_model_adt
            (List.map (fun x -> (PA.Const (fst x), ty)) values)
            stop selector_list model ctx func_decls sorts
        in
        if found_cycle then new_axioms, true else (aux rest)
    | _ -> [], false
  in
  aux keys
(* 
(* more general function that finds if there a cycle of a specific adt type*)
let find_cycles_in_model_adt adt_constants selectors (model : Z3.Model.model) ctx depth = 
  let adt_z3_constants = List.map (fun x -> Z3.FuncDecl.mk_const_decl_s ctx (fst x) (snd x)) adt_constants in 
  let z3_selectors = List.map (fun x -> Z3.FuncDecl.mk_func_decl_s ctx (fst x) (fst (snd x)) (snd (snd x))) selectors in
   *)