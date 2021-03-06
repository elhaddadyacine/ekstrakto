(*  Copyright 2004 INRIA  *)

open Expr
(* open Hashtbl *)

(* type inductive_arg =
  | Param of string
  | Self *)

(* type phrase = *)
  (* | Hyp of string * expr * int *)
  (* | Def of definition *)
  (* | Sig of string * string list * string *)
  (* | Inductive of
     string * string list * (string * inductive_arg list) list * string *)
  (* | Rew of string * expr * int *)

(* type zphrase =
  | Zhyp of string * expr * int
  | Zdef of definition
  | Zsig of string * string list * string
  | Zinductive of
     string * string list * (string * inductive_arg list) list * string
  | Zinclude of string *)

(* exception Bad_arg *)

let name_formula_tbl = Hashtbl.create 127

(* let extract_args l =
  List.map (function Evar _ as v -> v | _ -> raise Bad_arg) l *)

(* let rec no_duplicates = function
  | [] | [ _ ] -> true
  | h1 :: h2 :: t -> h1 <> h2 && no_duplicates (h2 :: t) *)

(* let check_args env args =
  try
    let arg = extract_args args in
    let senv = List.sort compare env in
    let sarg = List.sort compare arg in
    list_var_equal senv sarg && no_duplicates senv
  with Bad_arg -> false *)

(* let rec check_body env s e =
  match e with
  | Evar (v, _) -> v <> s || List.mem e env
  | Emeta _ -> assert false
  | Earrow _ -> false
  | Eapp (Evar(ss,_), args, _) ->
     ss <> s && List.for_all (check_body env s) args
  | Eapp(_) -> assert false
  | Enot (f, _) -> check_body env s f
  | Eand (f1, f2, _) | Eor (f1, f2, _) | Eimply (f1, f2, _) | Eequiv (f1, f2, _)
    -> check_body env s f1 && check_body env s f2
  | Etrue | Efalse
    -> true
  | Eall (v, f, _) | Eex (v, f, _)
  | Etau (v, f, _) | Elam (v, f, _)
    -> check_body (v::env) s f *)

(* let rec is_def predef env e =
  match e with
  | Eall (v, f, _) -> is_def predef (v::env) f
  | Eequiv (Eapp (Evar(s,_), args, _), body, _) when not (List.mem s predef) ->
     check_args env args && check_body [] s body
  | Eequiv (body, Eapp (Evar(s,_), args, _), _) when not (List.mem s predef) ->
     check_args env args && check_body [] s body
  | Eequiv (Evar (s, _), body, _) when not (List.mem s predef) ->
     env = [] && check_body [] s body
  | Eequiv (body, Evar (s, _), _) when not (List.mem s predef) ->
     env = [] && check_body [] s body
  | Eapp (Evar("=",_), [Evar (s, _); body], _) when not (List.mem s predef) ->
     env = [] && check_body [] s body
  | Eapp (Evar("=",_), [body; Evar (s, _)], _) when not (List.mem s predef) ->
     env = [] && check_body [] s body
  | Eapp (Evar("=",_), [Eapp (Evar(s,_), args, _); body], _)
       when not (List.mem s predef) ->
     check_args env args && check_body [] s body
  | Eapp (Evar("=",_), [body; Eapp (Evar(s,_), args, _)], _)
       when not (List.mem s predef) ->
     check_args env args && check_body [] s body
  | _ -> false *)

(* let rec make_def predef orig env e =
  match e with
  | Eall (v, f, _) -> make_def predef orig (v::env) f
  | Eequiv (Eapp (Evar(s,_), args, _), body, _)
    when not (List.mem s predef) && check_args env args ->
      DefPseudo (orig, s, type_iota, extract_args args, body)
  | Eequiv (body, Eapp (Evar(s,_), args, _), _) when
    not (List.mem s predef) && check_args env args ->
      DefPseudo (orig, s, type_iota, extract_args args, body)
  | Eequiv (Evar (s, _), body, _) when not (List.mem s predef) ->
      DefPseudo (orig, s, type_iota, [], body)
  | Eequiv (body, Evar (s, _), _) when not (List.mem s predef) ->
      DefPseudo (orig, s, type_iota, [], body)
  | Eapp (Evar("=",_), [Evar (s, _); body], _) when not (List.mem s predef) ->
      DefPseudo (orig, s, type_iota, [], body)
  | Eapp (Evar("=",_), [body; Evar (s, _)], _) when not (List.mem s predef) ->
      DefPseudo (orig, s, type_iota, [], body)
  | Eapp (Evar("=",_), [Eapp (Evar(s,_), args, _); body], _)
    when not (List.mem s predef) && check_args env args ->
      DefPseudo (orig, s, type_iota, extract_args args, body)
  | Eapp (Evar("=",_), [body; Eapp (Evar(s,_), args, _)], _)
    when not (List.mem s predef) && check_args env args ->
      DefPseudo (orig, s, type_iota, extract_args args, body)
  | _ -> assert false *)

(* let rec free_syms env accu e =
  match e with
  | Evar (v, _) -> if List.mem e env then accu else v :: accu
  | Emeta _ -> assert false
  | Eapp (Evar(s,_), args, _) -> List.fold_left (free_syms env) (s ::accu) args
  | Eapp (_) | Earrow _ -> assert false
  | Enot (f, _) -> free_syms env accu f
  | Eand (f, g, _) -> free_syms env (free_syms env accu f) g
  | Eor (f, g, _) -> free_syms env (free_syms env accu f) g
  | Eimply (f, g, _) -> free_syms env (free_syms env accu f) g
  | Eequiv (f, g, _) -> free_syms env (free_syms env accu f) g
  | Etrue | Efalse -> accu
  | Eall (v, f, _)
  | Eex (v, f, _)
  | Etau (v, f, _)
  | Elam (v, f, _)
    -> free_syms (v::env) accu f *)

(* let extract_dep = function
  | DefPseudo (_, s, _, args, body) -> (s, free_syms args [] body)
  | _ -> assert false *)
(* let rec follow_deps l deps =
  match l with
  | [] -> []
  | h::t ->
      begin try
        let hl = List.assoc h deps in
        hl @ follow_deps t deps
      with Not_found -> follow_deps t deps
      end *)

(* let rec looping (s, l) deps =
  if l = [] then false else
  List.mem s l || looping (s, (follow_deps l deps)) deps *)

(* let rec is_redef d ds =
  match d, ds with
  | _, [] -> false
  | _, (DefReal _ :: t) -> is_redef d t
  | _, (DefRec _ :: t) -> is_redef d t
  | DefPseudo (_, s1, _, _, _), (DefPseudo(_, s2, _, _, _) :: t) ->
      s1 = s2 || is_redef d t
  | DefReal _, _ -> assert false
  | DefRec _, _ -> assert false *)

(* let rec remove_def accu sym defs =
  match defs with
  | [] -> assert false
  | DefPseudo (orig, s, _, _, _) :: t when s = sym -> (accu @ t, orig)
  | h::t -> remove_def (h::accu) sym t *)

(* let get_symbol = function
  | DefPseudo (_, s, _, _, _) -> s
  | _ -> assert false *)

(* let rec xseparate predef deps multi defs hyps l =
  match l with
  | [] -> (List.rev defs, List.rev hyps)
  | Def d :: t -> xseparate predef deps multi (d :: defs) hyps t
  | Hyp (_, e, p) :: t when is_def predef [] e ->
      let d = make_def predef (e, p) [] e in
      let sym = get_symbol d in
      let newdep = extract_dep d in
      if List.mem sym multi || looping newdep deps then
        xseparate predef deps multi defs ((e, p) :: hyps) t
      else if is_redef d defs then
        let (ndefs, ep2) = remove_def [] sym defs in
        xseparate predef (List.remove_assoc sym deps) (sym::multi) ndefs
                  ((e, p) :: ep2 :: hyps) t
      else
        xseparate predef (newdep :: deps) multi (d :: defs) hyps t
  | Hyp (_, e, p) :: t -> xseparate predef deps multi defs ((e, p) :: hyps) t
  | Sig _ :: t -> xseparate predef deps multi defs hyps t
  | Inductive _ :: t -> xseparate predef deps multi defs hyps t
  | Rew _ :: t -> xseparate predef deps multi defs hyps t *)

(* let separate predef l = xseparate predef [] [] [] [] l *)

(* let change_to_def predef body =
  if is_def predef [] body then begin
    match make_def predef (body, 0) [] body with
    | DefPseudo (_, s, ty, args, def) -> DefReal ("", s, ty, args, def, None)
    | _ -> assert false
  end else raise (Invalid_argument "change_to_def") *)

type infoitem =
  | Cte of string
  | Fun of string * infoitem list

type tpannot =
  | File of string
  | Inference of string * infoitem list * tpannot list
  | Introduced of string
  | Name of string
  | List of tpannot list
  | Other of string

type tpphrase =
  | Include of string * string list option
  | Formula of string * string * expr * string option
  | Formula_annot of string * string * expr * tpannot option
  | Annotation of string
