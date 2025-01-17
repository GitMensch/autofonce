(**************************************************************************)
(*                                                                        *)
(*  Copyright (c) 2023 OCamlPro SAS                                       *)
(*                                                                        *)
(*  All rights reserved.                                                  *)
(*  This file is distributed under the terms of the                       *)
(*  OCAMLPRO-NON-COMMERCIAL license.                                      *)
(*                                                                        *)
(**************************************************************************)

open Ezcmd.V2

open Autofonce_m4 (* for M4Types, M4Parser *)

let set_verbosity n =
  Globals.verbose := n;
  Call.debug := !Globals.verbose > 1

let get_verbosity () = !Globals.verbose

module PROGRAM = struct
  let command = "autofonce"
  let about = "autofonce COMMAND COMMAND-OPTIONS"
  let set_verbosity = set_verbosity
  let get_verbosity = get_verbosity
  let backtrace_var = Some "AUTOFONCE_BACKTRACE"
  let usage = "Modern runner for GNU Autoconf testsuites"
  let version = Version.version
  exception Error = Types.Error
end
module MAIN = EZCMD.MAKE( PROGRAM )
include PROGRAM

let commands = [
  Command_init.cmd ;
  Command_list.cmd ;
  Command_run.cmd ;
  Command_new.cmd ;
]

let main () =
  Printexc.record_backtrace true;

  let common_args = [
  ] in

  try
    MAIN.main
      ~on_error: (fun () -> () )
      ~on_exit: (fun () -> () )
      ~print_config: (fun () -> () )
      (* ~argv *)
      commands
      ~common_args;
  with
  | PROGRAM.Error s ->
      Printf.eprintf "Error: %s\n%!" s;
      exit 2
  | exn ->
      let bt = Printexc.get_backtrace () in
      let error = Printexc.to_string exn in
      Printf.eprintf "fatal exception %s\n%s\n%!" error bt;
      exit 2
