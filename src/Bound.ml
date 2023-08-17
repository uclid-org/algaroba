module PA = Smtlib_utils.V_2_6.Ast
open Context

let concat_map f lst =
  List.flatten (List.map f lst)

  
  let get_rec_selectors (c : PA.cstor) =
    List.filter_map
      (fun (s, (t : PA.ty)) ->
        match t with
        | Ty_app (t, []) when Ctx.check_inductive_datatype t -> Some (s, t)
        | _ -> None )
      c.cstor_args
  
  let get_rec_constructors t =
    StrTbl.find Ctx.t.adts t
    |> List.filter_map (fun c ->
           let rec_selectors = get_rec_selectors c in
           match rec_selectors with
           | [] -> None
           | _ -> Some (c.cstor_name, rec_selectors) )
  
  let is_leaf x t =
    match List.map (fun (c, _) -> c) (get_rec_constructors t) with
    | [] -> PA.True
    | c :: [] -> PA.Not (PA.App ("is-" ^ c, [x]))
    | cs -> PA.And (List.map (fun c -> PA.Not (PA.App ("is-" ^ c, [x]))) cs)
  
  let rec per_selector k x (s, t) =
    let y = PA.App (s, [x]) in
    [bound_var (k - 1) y t]
  
  and per_constructor k x (c, selectors) =
    match concat_map (per_selector k x) selectors with
    | [] -> PA.True
    | s :: [] -> PA.Imply (PA.App ("is-" ^ c, [x]), s)
    | ss -> PA.Imply (PA.App ("is-" ^ c, [x]), PA.And ss)
  
  and bound_var k x t =
    if k <= 0 then is_leaf x t
    else
      match get_rec_constructors t with
      | [] -> PA.True
      | c :: [] -> per_constructor k x c
      | cs -> PA.And (List.map (per_constructor k x) cs)
  
  let bound vars k =
    let components =
      List.filter_map
        (fun (x, t) ->
          match t with
          | PA.Ty_app (t, []) -> Some (bound_var k (PA.App (x, [])) t)
          | _ -> None )
        vars
    in
    PA.And components



(*function that returns true if a term is an ADT constant and returns the depth of that constant*)
  let rec check_if_constant_with_depth (term: PA.term) =
    begin match term with 
      | PA.Const v ->
          begin match StrTbl.find_opt Ctx.t.constructors v with 
            | Some _ ->  1
            | None -> 0
          end
      | PA.App (f, terms) ->
          begin match StrTbl.find_opt Ctx.t.constructors f with 
            | Some _ -> 
                let size = List.fold_left 
                                    (fun acc x -> 
                                    (max acc (check_if_constant_with_depth x))) 0 terms
                                    in
                if (size = 0 ) then 0 else size + 1
            | None ->  0 
          end
      | PA.If (_, b, c) ->
          let b_size = check_if_constant_with_depth b in
          let c_size = check_if_constant_with_depth c in 
          (max b_size c_size)
      | Arith (_, terms) -> List.fold_left max 0 (List.map check_if_constant_with_depth terms)
      | Eq (a, b) -> max (check_if_constant_with_depth a) (check_if_constant_with_depth b)
      | Imply (a, b) -> max (check_if_constant_with_depth a) (check_if_constant_with_depth b)
      | And terms -> List.fold_left max 0 (List.map check_if_constant_with_depth terms)
      | Or terms -> List.fold_left max 0 (List.map check_if_constant_with_depth terms)
      | Not t -> (check_if_constant_with_depth t)
      | Distinct terms -> List.fold_left max 0 (List.map check_if_constant_with_depth terms)
      | Cast (t, _) -> (check_if_constant_with_depth t)
      | _ -> 0
    end

let find_largest_constant stmts = 
  let rec aux (stmts : PA.stmt list) maximum = 
    begin match stmts with 
      | stmt :: rest ->
          begin match stmt with 
            | Stmt_assert term -> 
              let term_size = (check_if_constant_with_depth term) in
              aux rest (max term_size maximum)
            | _ -> aux rest maximum
          end
      | _ -> maximum
    end in 
    aux stmts 0

let average lst =
  let sum = List.fold_left (+) 0 lst in
  let length = List.length lst in
  if length = 0 then 0. else ((float_of_int sum) /. (float_of_int length)) 
