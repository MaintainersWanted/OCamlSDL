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

(* $Id: sdl.mli,v 1.2 2001/04/24 19:39:28 xtrm Exp $ *)

(* Exception *)
exception SDL_init_exception of string

(* Init flag type *)

type init_flag =
  | TIMER
  | AUDIO
  | VIDEO
  | CDROM
  | JOYSTICK
  | NOPARACHUTE        (* Don't catch fatal signals *)
  | EVENTTHREAD
  | EVERYTHING

(* Initialize the SDL library *)
val init : init_flag list -> unit

(* Initialize the SDL library with automatic call the the sql_quit
 * function at normal program termination
 *)
val init_with_auto_clean : init_flag list -> unit;;

(* Shut down the SDL library *)
val quit : unit -> unit;;
