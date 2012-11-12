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

(* $Id: sdlttf.mli,v 1.18 2012/11/12 18:37:25 oliv__a Exp $ *)

(** Provides TTF (TrueType Font) support *)

(** Exception for reporting errors *)
exception SDLttf_exception of string

(** Initialise SDL_tff and freetype *)
val init : unit -> unit

(** Quits the system *)
val quit : unit -> unit

(** {3 General operations on font datatype} *)

type font
(** abstract font datatype *)

val open_font : string -> ?index:int -> int -> font
(** open a font file and create a font of the specified point size 
   @return font datatype 
*)

(** Set and retrieve the font style
   This font style is implemented by modifying the font glyphs, and
   doesn't reflect any inherent properties of the truetype font file.
*)

type font_style =
  | NORMAL
  | BOLD
  | ITALIC
  | UNDERLINE

val get_font_style : font -> font_style list
(** Retrieve the font style : either [NORMAL] or a combination of 
   [BOLD], [ITALIC] and [UNDERLINE] *)

val set_font_style : font -> font_style list -> unit

(** {3 Font information } *)

val font_height : font -> int
(** @return the total height(int) of the font (usually equal to point size) *)

val font_ascent : font -> int
(**
  @return the offset(int) from the baseline to the top of the font
   this is a positive value, relative to the baseline *)

val font_descent : font -> int
(**
   @return the offset from the baseline to the bottom of the font
   this is a negative value, relative to the baseline *)

val font_lineskip : font -> int
(** Get the recommended spacing between lines of text for this font *)

val font_faces : font -> int
(** Get the number of faces of the font *)

(** Get some font face attributes, if any *)

val is_fixed_width : font -> bool
val family_name : font -> string
val style_name : font -> string

(** {3 Text rendering functions} *)

open Sdlvideo

(** Get the dimensions of a rendered string of text *)
val size_text : font -> string -> int * int

(* UTF8 *)
val size_utf8 : font -> string -> int * int

(** @return the metrics (minx,maxx,miny,maxy) of a glyph *) 
val glyph_metrics : font -> char -> int * int * int * int

(** Variant type for the generic rendering functions *)
type render_kind =
  | SOLID   of color
  | SHADED  of color * color
  | BLENDED of color

(** {4 Text rendering functions} *)

val render_text_solid : font -> string -> 
  fg:color -> surface
val render_text_shaded : font -> string -> 
  fg:color -> bg:color -> surface
val render_text_blended : font -> string -> 
  fg:color -> surface

(* UTF8 *)
val render_utf8_solid : font -> string -> 
  fg:color -> surface
val render_utf8_shaded : font -> string -> 
  fg:color -> bg:color -> surface
val render_utf8_blended : font -> string -> 
  fg:color -> surface

val render_text : font -> render_kind -> string -> surface

(** {4 Glyph rendering functions} *)

val render_glyph_solid : font -> char -> 
  fg:color -> surface
val render_glyph_shaded : font -> char -> 
  fg:color -> bg:color -> surface
val render_glyph_blended : font -> char -> 
  fg:color -> surface

val render_glyph : font -> render_kind -> char -> surface
