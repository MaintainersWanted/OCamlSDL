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

(* $Id: sdlpng.ml,v 1.2 2000/01/14 00:55:49 fbrunel Exp $ *)

(* Define a new exception for PNG errors and register 
   it to be callable from C code. *)

exception SDLpng_exception of string
let _ = Callback.register_exception "SDLpng_exception" (SDLpng_exception "Any string")

external load : string -> Sdlvideo.surface = "sdlpng_load_png";;
external load_with_alpha : string -> Sdlvideo.surface = "sdlpng_load_png_with_alpha";;

