module PA = Smtlib_utils.V_2_6.Ast

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
  | Match (t, branches) -> Match (substitute var args sub_term t, branches)
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
  let substitutions = if (substitutions = []) then [("", [], PA.Const "")] else substitutions in (*have to add sort of a blank subtition if there are none, otherwise nothing happsn*)
  List.fold_left
    (fun acc_term (var, args, sub_term) -> substitute var args sub_term acc_term)
    term substitutions


let inline_statements stmts =
  let rec aux defs acc = function
    | [] -> List.rev acc
    | stmt :: rest ->
      begin
        match stmt with
        | PA.Stmt_fun_def fun_def ->
          aux ((fun_def.fr_decl.fun_name, (List.map fst fun_def.fr_decl.fun_args), fun_def.fr_body) :: defs) acc rest
        | Stmt_fun_rec _ -> raise (UnsupportedQuery "We do not support Stmt_fun_rec")
        | Stmt_funs_rec _ -> raise (UnsupportedQuery "We do not support funs_rec_def")
        | Stmt_assert term ->
          let inlined_term = multi_substitute defs term in
          aux defs (PA.Stmt_assert (inlined_term) :: acc) rest
        | _ -> aux defs (stmt :: acc) rest
      end
  in
  aux [] [] stmts



