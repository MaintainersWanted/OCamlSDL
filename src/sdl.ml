(*
 * OCamlSDL - An ML interface to the SDL library
 * Copyright (C) 1999  Frederic Brunel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)

(* $Id: sdl.ml,v 1.5 2002/07/30 18:32:50 oliv__a Exp $ *)

(* Define a new exception for Sdl initialization errors and register 
   it to be callable from C code. *)

exception SDL_init_exception of string
let _ = 
  Callback.register_exception 
    "SDL_init_exception" (SDL_init_exception "Any string")

(* Native C external functions *)

(* Initialization. *)

type init_flag = [
  | `TIMER
  | `AUDIO
  | `VIDEO
  | `CDROM
  | `JOYSTICK
  | `NOPARACHUTE   (* Don't catch fatal signals *)
  | `EVENTTHREAD   (* Not supported on all OS's *)
  | `EVERYTHING
  ] 

external init : init_flag list -> unit = "sdl_init";;
external init_with_auto_clean : init_flag list -> unit = "sdl_init_with_auto_clean";;
external quit : unit -> unit = "sdl_quit";;

type version = {
    major : int ;
    minor : int ;
    patch : int ;
  } 

external version : unit -> version = "sdl_version"

let string_of_version v =
  String.concat "." 
    (List.map string_of_int 
       [ v.major; v.minor; v.patch ])
