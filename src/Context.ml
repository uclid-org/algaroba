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
    mutable adt_with_depth_variables: ((string list) * PA.ty) StrTbl.t; (*The adt variables relevant for depth calculation will be stored here. used in R6*)
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
        if (contains variable var_list) then ()
        else  StrTbl.replace t.adt_with_depth_variables name ((variable :: var_list), ty)
      | None -> StrTbl.add t.adt_with_depth_variables name ([variable], ty)
    end

  let add_general_variable_to_adt name variable ty =
    begin match StrTbl.find_opt t.adt_with_all_variables name with
      | Some (var_list, _) -> StrTbl.replace t.adt_with_all_variables name ((variable :: var_list), ty)
      | None -> StrTbl.add t.adt_with_all_variables name ([variable], ty)
    end

    (* function that does a DFS to find if a data type is inductive*)
(*not tail recursive at all, but we shouldn't have more than a few adts*)
  let check_inductive_datatype (adt :string) =
    let rec aux adt parents = 
      if ((List.exists (fun x -> (String.equal x adt)) parents)) then true
      else (
          begin match StrTbl.find_opt t.adts adt with 
            | Some cstor_list -> 
                        let children = 
                              List.flat_map 
                                    (fun (cstor : PA.cstor) ->  List.map (fun x -> match (snd x) with 
                                                                                      |PA.Ty_app (s, _) -> s
                                                                                      | _ -> raise (UnsupportedQuery ("check_inductive_datatypes given incorrect adt: "^ adt)))
                                                                           cstor.cstor_args)
                                    cstor_list
                        in
                        List.fold_left 
                          (fun acc child -> (aux child (adt::parents)) || acc) 
                          false 
                          children

            | None -> false (* if adt is not actually an adt, we want to return false*)
        end
      )
      in
    aux adt []

(* function that does a DFS to find if a data type is well-founded*)
(*not tail recursive at all, but we shouldn't have more than a few adts*)
(*TODO: clean up this logic a little bit*)
  let check_not_well_founded_datatype (adt :string) =
    let rec aux adt parents = 
        if (List.exists (fun x -> (String.equal x adt)) parents) then true 
        else (
          if (not (check_inductive_datatype adt)) then false
          else (
            begin match StrTbl.find_opt t.adts adt with 
              | Some cstor_list -> 
                    let children = List.map 
                                      (fun (cstor : PA.cstor) ->  List.map (fun x -> match (snd x) with 
                                                                                        |PA.Ty_app (s, _) -> s
                                                                                        | _ -> raise (UnsupportedQuery ("check_well_founded_datatypes given incorrect adt: "^ adt)))
                                                                            cstor.cstor_args)
                                      cstor_list
                    in 
                  List.fold_left
                    (fun acc1 const_child_list -> 
                      if (List.is_empty const_child_list) then false
                      else (
                      (List.fold_left 
                        (fun acc2 child -> (aux child (adt::parents)) && acc2)) 
                        true 
                        const_child_list)
                      && acc1)
                      true
                      children
                | None -> false (* if adt is not actually an adt, we want to return true*)
              end
          )
        )
      in
    aux adt []


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

    
  let add_axiom new_axiom = 
    t.axioms <- new_axiom :: t.axioms


    

  let increment_vars_created () : unit = 
      t.vars_created <- t.vars_created + 1
  
  let increment_skip_counter () : unit = 
    t.skip_counter <- t.skip_counter + 1
  
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


(* will tell you if two PA.ty are equal*)

(*I think this is not necessary since we can ue the built in equaity*)
(* let ty_equal (ty1 : PA.ty) (ty2 : PA.ty) : bool = 
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
  | Ty_app of ty_var * ty list
  | Ty_arrow of ty list * ty *)