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

(* $Id: sdlttf.mli,v 1.3 2000/02/08 00:01:26 fbrunel Exp $ *)

(* Exception *)

exception SDLttf_exception of string

(* Type *)

type font

(* Operations *)

val open_font : string -> int -> font
val close_font : font -> unit
val font_height : font -> int
val render_text : font -> string -> (int * int * int) -> (int * int * int) -> Sdlvideo.surface

(* Return a function to print strings, and another to clean up printer *)
val make_printer : font -> (int * int * int) ->
  (Sdlvideo.surface -> int -> int -> string -> unit) * (unit -> unit)
