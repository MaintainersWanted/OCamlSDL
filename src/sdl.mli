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

(* $Id: sdl.mli,v 1.5 2002/07/30 18:32:50 oliv__a Exp $ *)

(** This module contains functions for initialising/quitting the library *)

exception SDL_init_exception of string
(** Exception for repporting errors during initialization *)

(** {1 Main functions} *)

(** Initialization flag type *)
type init_flag = [
  | `TIMER        (** init flag for the timer subsystem *)
  | `AUDIO        (** init flag for the audio subsystem *)
  | `VIDEO        (** init flag for the video subsystem *)
  | `CDROM        (** init flag for the cdrom subsystem *)
  | `JOYSTICK     (** init flag for the joystick subsystem *)
  | `NOPARACHUTE  (** Don't catch fatal signals *)
  | `EVENTTHREAD 
  | `EVERYTHING   (** same as `TIMER + `AUDIO + `VIDEO + `CDROM + `JOYSTICK *)
  ] 

external init : init_flag list -> unit
    = "sdl_init"
(**
  Initialize the SDL library. This should be called before all other 
  SDL functions. 
  The flags parameter specifies what part(s) of SDL to initialize.
*)

external init_with_auto_clean : init_flag list -> unit
    = "sdl_init_with_auto_clean"
(** 
  Initialize the SDL library with automatic call to the {! Sdl.quit}
  function at normal program termination
*)

external quit : unit -> unit
    = "sdl_quit"
(** 
  [quit] shuts down all SDL subsystems and frees the resources allocated 
  to them. This should always be called before you exit. 
*)

(** {1 Versioning information} *)

type version = {
    major : int ;
    minor : int ;
    patch : int ;
  } 

external version : unit -> version = "sdl_version"
(** version of the SDL library *)

val string_of_version : version -> string
