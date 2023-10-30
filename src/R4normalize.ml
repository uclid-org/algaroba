(* Converting a flattened, inlined formula to NNF *)
module PA = Smtlib_utils.V_2_6.Ast
open Context
exception UnsupportedQuery of string

let negate (not_parity: bool) (term: PA.term) = 
  if not_parity then (PA.Not term)
  else term


let rec normalize (not_parity: bool)  (term : PA.term) =
  match term with
  | HO_app (_, _) -> raise (UnsupportedQuery "We do not support HO_App")
  | Match _ -> raise (UnsupportedQuery "We should have reduced Match to ITE by now")
  (* | If _ -> raise (UnsupportedQuery "If statements should be handled by flatten step") *)
  | Let _ -> raise (UnsupportedQuery "If statements should be handled by inline step")
  | Imply _ -> raise (UnsupportedQuery "Imply statements should be handled by flatten step")
  | And terms -> 
      if not_parity then PA.Or (List.map (normalize not_parity) terms)
      else PA.And (List.map (normalize not_parity) terms)
  | Or terms -> 
    if not_parity then And (List.map (normalize not_parity) terms)
    else Or (List.map (normalize not_parity) terms)
  | Not t -> (normalize (not not_parity) t)
  | Forall (_, _) -> raise (UnsupportedQuery "We do not support Forall")
  | Exists (_, _) -> raise (UnsupportedQuery "We do not support Exists")
  | Is_a (name, t) -> (negate not_parity (PA.App ("is-" ^ name, [t]))) (*NOT NORMALIZATION: but rather turning testers to uninterpreted functions*)
  | _ -> negate not_parity term (* catch all for everything else: note we assume that everything is flattened and typechecked*)

let normalize_statements stmts =
  let rec aux stmts acc =
    begin match stmts with
      | PA.Stmt_assert term :: rest -> let normalized_assert =  PA.Stmt_assert (normalize false term) in
                                       (aux rest (acc @ [normalized_assert]))
      | stmt :: rest -> (aux rest (acc @ [stmt]))
      | _ -> acc
    end in
  aux stmts []

