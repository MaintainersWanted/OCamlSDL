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

(* $Id: sdl.ml,v 1.7 2003/02/13 21:40:11 oliv__a Exp $ *)

(* Define a new exception for Sdl initialization errors and register 
   it to be callable from C code. *)

exception SDL_init_exception of string
let _ = 
  Callback.register_exception 
    "SDL_init_exception" (SDL_init_exception "Any string")

(* Native C external functions *)

(* Initialization. *)

type subsystem = [
  | `TIMER        (** init flag for the timer subsystem *)
  | `AUDIO        (** init flag for the audio subsystem *)
  | `VIDEO        (** init flag for the video subsystem *)
  | `CDROM        (** init flag for the cdrom subsystem *)
  | `JOYSTICK     (** init flag for the joystick subsystem *)
]

external init : ?auto_clean:bool -> 
  [< subsystem | `NOPARACHUTE | `EVENTTHREAD | `EVERYTHING ] list -> 
  unit = "sdl_init"
external init_subsystem : subsystem list -> unit = "sdl_init_subsystem"

external was_init : unit -> subsystem list = "sdl_was_init"

external quit : unit -> unit = "sdl_quit"
external quit_subsystem : subsystem list -> unit = "sdl_quit_subsystem"

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

let getenv = Sys.getenv
external putenv : string -> string -> unit = "sdl_putenv"

