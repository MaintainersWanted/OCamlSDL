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

(* $Id: sdl.ml,v 1.1.1.1 2000/01/02 01:32:24 fbrunel Exp $ *)

(* Define a new exception for CD-ROM errors and register 
   it to be callable from C code. *)

exception SDL_init_exception of string
let _ = Callback.register_exception "SDL_init_exception" (SDL_init_exception "Any string")

(* Native C external functions *)

external init : unit -> unit = "sdl_init";;
external init_with_auto_clean : unit -> unit = "sdl_init_with_auto_clean";;
external quit : unit -> unit = "sdl_quit";;
