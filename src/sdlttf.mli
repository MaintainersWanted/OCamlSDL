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

(* $Id: sdlttf.mli,v 1.6 2002/04/29 19:16:39 xtrm Exp $ *)

(* Exception *)

exception SDLttf_exception of string

(*1 Type *)

type font

(*1 Operations *)

val open_font : string -> int -> font
(*d open a font file and create a font of the specified point size *)

val close_font : font -> unit
(*d close an opened font file *)

val font_height : font -> int
(*d get the total height of the font (usually equal to point size *)

val font_ascent : font -> int
(*d get the offset from the baseline to the top of the font
    this is a positive value, relative to the baseline *)

val font_descent : font -> int
(*d get the offset from the baseline to the bottom of the font
    this is a negative value, relative to the baseline *)

val font_metrics : font -> int -> int*int*int*int
(*d get the metrics of the specified font *) 

(*1 Render text functions *)

val render_text_shaded : f:font -> text:string -> foreground:(int * int * int) -> background:(int * int * int) -> Sdlvideo.surface
val render_text_blended : f:font -> text:string -> foreground:(int * int * int) -> Sdlvideo.surface
val render_text_solid : f:font -> text:string -> foreground:(int * int * int) -> Sdlvideo.surface

(* deprecated *)
val render_text : font -> string -> (int * int * int) -> (int * int * int) -> Sdlvideo.surface

(* Return a function to print strings, and another to clean up printer *)
(*
val make_printer : font -> (int * int * int) ->
  (Sdlvideo.surface -> int -> int -> string -> unit) * (unit -> unit)
*)
