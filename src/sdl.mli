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

(* $Id: sdl.mli,v 1.4 2002/05/30 16:13:38 xtrm Exp $ *)

(*d Exception *)
exception SDL_init_exception of string

(*d Init flag type *)

type init_flag = [
  | `TIMER (*d init flag for the timer subsystem. *)
  | `AUDIO (*d init flag for the audio subsystem. *)
  | `VIDEO (*d init flag for the video subsystem. *)
  | `CDROM (*d init flag for the cdrom subsystem. *)
  | `JOYSTICK (*d init flag for the joystick subsystem. *)
  | `NOPARACHUTE  (*d Don't catch fatal signals *)
  | `EVENTTHREAD 
  | `EVERYTHING (*d init flag for initialize all subsystems *)
  ] 

(*1 Main functions *)
val init : init_flag list -> unit
(*d
  Initialize the SDL library. This should be called before all other 
  SDL functions. 
  The flags parameter specifies what part(s) of SDL to initialize.
*)

val init_with_auto_clean : init_flag list -> unit;;
(*d 
  Initialize the SDL library with automatic call the the [quit]
  function at normal program termination
*)

val quit : unit -> unit;;
(*d 
  [quit] shuts down all SDL subsystems and frees the resources allocated 
  to them. This should always be called before you exit. 
*)
