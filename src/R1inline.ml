module PA = Smtlib_utils.V_2_6.Ast
open R5reduce_rules

exception UnsupportedQuery of string
open Context
let rec substitute var args (sub_term : PA.term) (acc_term : PA.term)  =
  match acc_term with
  | Const v when v = var -> sub_term
  | Arith (op, terms) -> Arith (op, List.map (substitute var args sub_term) terms)
  | App (s, terms) ->
    if (s = var) then 
      multi_substitute (List.map2 (fun x y -> (x, [], y)) args terms) sub_term
    else
      App (s, List.map (substitute var args sub_term) terms)
  | HO_app (_, _) -> raise (UnsupportedQuery "We do not support HO_App") 
  (* we are going to reduce matches to ite statements using selectors*)
  (*TODO: we end up replicating match_term many times: it would be better for efficiency to not do this*)
  | Match (t, branches) -> 
      let match_term = substitute var args sub_term t in
      (List.fold_left 
        (fun (acc : PA.term -> PA.term) (branch : PA.match_branch) : (PA.term -> PA.term) -> 
            begin match branch with 
            | PA.Match_default term -> (fun _ -> (substitute var args sub_term term))
            | PA.Match_case (s, vars, term) -> (fun x -> acc (PA.If (PA.App ("is-" ^ s, [match_term]), 
                                                            (multi_substitute ((var, args, sub_term) :: (List.map2 (fun (x : string) (y : PA.term) -> (x, [], y)) 
                                                                                                                    vars 
                                                                                                                    (List.map (fun sel -> PA.App (sel, [match_term])) (Ctx.get_selectors s))))
                                                                              term), 
                                                            x)))
            end)
        (fun (x : PA.term) : PA.term -> x)
        branches) match_term (*TODO: maybe there is a more elegant way to do this*)
  | If (t1, t2, t3) ->
    If (substitute var args sub_term t1, substitute var args sub_term t2, substitute var args sub_term t3)
  | Let (bindings, t) ->
    if List.mem_assoc var bindings then multi_substitute ((List.map (fun x -> ((fst x), [], (snd x))) bindings)) t
    else multi_substitute ((var, args, sub_term) :: (List.map (fun x -> ((fst x), [], (snd x))) bindings)) t
  | Is_a (s, t) -> Is_a (s, substitute var args sub_term t)
  | Fun (vt, t) -> Fun (vt, substitute var args sub_term t)
  | Eq (t1, t2) -> Eq (substitute var args sub_term t1, substitute var args sub_term t2)
  | Imply (t1, t2) -> Imply (substitute var args sub_term t1, substitute var args sub_term t2)
  | And terms -> And (List.map (substitute var args sub_term) terms)
  | Or terms -> Or (List.map (substitute var args sub_term) terms)
  | Not t -> Not (substitute var args sub_term t)
  | Distinct terms -> Distinct (List.map (substitute var args sub_term) terms)
  | Cast (t, ty) -> Cast (substitute var args sub_term t, ty)
  | Forall (_, _) -> raise (UnsupportedQuery "We do not support Forall")
  | Exists (_, _) -> raise (UnsupportedQuery "We do not support Exists")
  | Attr (t, attrs) -> Attr (substitute var args sub_term t, attrs)
  | _ -> acc_term

  (*TODO: throw error for forall, exists, ho_app, fun_rec*)
(* Substitute multiple terms for their corresponding variables in a term *)
and multi_substitute (substitutions: (string * string list * PA.term) list) term =
  let substitutions = if (substitutions = []) then [("__shouldnotoccur__", [], PA.Const "__shouldnotoccur__")] else substitutions in (*have to add sort of a blank subtition if there are none, otherwise nothing happsn*)
  List.fold_left
    (fun acc_term (var, args, sub_term) -> substitute var args sub_term acc_term)
    term substitutions


(*TODO: Should I even inline anymore?? -> I guess I'll keep it right now but it seems like it could screw up efficienct*)
let inline_statements stmts =
  let rec aux defs acc start_statements = function
    | [] -> start_statements, List.rev acc
    | stmt :: rest ->
      begin
        match stmt with
        | PA.Stmt_set_info _ -> aux defs acc (start_statements @ [stmt]) rest
        | PA.Stmt_set_logic _ -> aux defs acc (start_statements @ [stmt]) rest
        | PA.Stmt_data data -> let reduced_adt_decl_sorts, reduced_adt_decl_funs = (add_adt_list_to_context data) in
                                (aux defs acc (start_statements @ reduced_adt_decl_sorts @ reduced_adt_decl_funs) rest)
        | PA.Stmt_decl_sort _ -> aux defs rest (acc) (start_statements @ [stmt])
        | PA.Stmt_fun_def fun_def ->
          let inlined_definition_body = multi_substitute defs fun_def.fr_body in
          aux ((fun_def.fr_decl.fun_name, (List.map fst fun_def.fr_decl.fun_args), inlined_definition_body) :: defs) acc start_statements rest 
        | Stmt_fun_rec fun_def ->
            let new_fun_decl = PA.Stmt_decl {fun_ty_vars = fun_def.fr_decl.fun_ty_vars; fun_name = fun_def.fr_decl.fun_name; fun_args = (List.map snd fun_def.fr_decl.fun_args); fun_ret = fun_def.fr_decl.fun_ret} in
            Ctx.add_recursive_function fun_def.fr_decl.fun_name fun_def;
            aux defs (new_fun_decl :: acc) start_statements rest 
        | Stmt_funs_rec _ -> raise (UnsupportedQuery "We do not support funs_rec_def")
        | Stmt_assert term ->
          let inlined_term = multi_substitute defs term in
          aux defs (PA.Stmt_assert (inlined_term) :: acc) start_statements rest
        | _ -> aux defs (stmt :: acc) start_statements rest 
      end
  in
  aux [] [] [] stmts



