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

(* $Id: sdl.mli,v 1.7 2002/08/21 18:26:31 oliv__a Exp $ *)

(** This module contains functions for initialising/quitting the library *)

exception SDL_init_exception of string
(** Exception for repporting errors during initialization *)

(** {1 Main functions} *)

(** Initialization flag type *)
type subsystem = [
  | `TIMER        (** init flag for the timer subsystem *)
  | `AUDIO        (** init flag for the audio subsystem *)
  | `VIDEO        (** init flag for the video subsystem *)
  | `CDROM        (** init flag for the cdrom subsystem *)
  | `JOYSTICK     (** init flag for the joystick subsystem *)
]

val init : 
  ?auto_clean:bool -> 
  [< subsystem | `NOPARACHUTE | `EVENTTHREAD | `EVERYTHING ] list -> 
  unit
(** Initialize the SDL library. This should be called before all other 
   SDL functions. 
   The flags parameter specifies what part(s) of SDL to initialize.
 - `NOPARACHUTE : Don't catch fatal signals
 - `EVENTTHREAD : Automatically pump events in a separate threads
 - `EVERYTHING  : initialize all subsystems
*)
external init_subsystem : subsystem list -> unit = "sdl_init_subsystem"

external was_init : unit -> subsystem list = "sdl_was_init"

external quit : unit -> unit = "sdl_quit"
(** 
  [quit] shuts down all SDL subsystems and frees the resources allocated 
  to them. This should always be called before you exit. 
*)

external quit_subsystem : subsystem list -> unit = "sdl_quit_subsystem"


(** {1 Versioning information} *)

type version = {
    major : int ;
    minor : int ;
    patch : int ;
  } 

external version : unit -> version = "sdl_version"
(** version of the SDL library *)

val string_of_version : version -> string
