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

(* $Id: sdlttf.mli,v 1.9 2002/08/09 15:39:22 oliv__a Exp $ *)

(** This module provides TTF (TrueType Font) support *)

(** Exception for reporting errors *)
exception SDLttf_exception of string

type font
(** abstract font datatype *)


(** {1 General operations on font datatype} *)

external open_font : string -> ?index:int -> int -> font = "sdlttf_open_font"
(** open a font file and create a font of the specified point size 
   @return font datatype 
*)

external close_font : font -> unit = "sdlttf_close_font"
(** close a previouly opened font file *)

(** Set and retrieve the font style
   This font style is implemented by modifying the font glyphs, and
   doesn't reflect any inherent properties of the truetype font file.
*)

type font_style =
  | NORMAL
  | BOLD
  | ITALIC
  | UNDERLINE

external get_font_style : font -> font_style = "sdlttf_get_font_style"
external set_font_style : font -> font_style -> unit = "sdlttf_set_font_style"

(** {1 Font information } *)

external font_height : font -> int = "sdlttf_font_height"
(** @return the total height(int) of the font (usually equal to point size) *)

external font_ascent : font -> int = "sdlttf_font_ascent"
(**
  @return the offset(int) from the baseline to the top of the font
   this is a positive value, relative to the baseline *)

external font_descent : font -> int = "sdlttf_font_descent"
(**
   @return the offset from the baseline to the bottom of the font
   this is a negative value, relative to the baseline *)

external font_lineskip : font -> int = "ml_TTF_FontLineSkip"
(** Get the recommended spacing between lines of text for this font *)

external font_faces : font -> int = "ml_TTF_FontFaces"
(** Get the number of faces of the font *)

(** Get some font face attributes, if any *)

external is_fixed_width : font -> bool = "ml_TTF_FontFaceIsFixedWidth"
external family_name : font -> string = "ml_TTF_FontFaceFamilyName"
external style_name : font -> string = "ml_TTF_FontFaceStyleName"

(** {1 Text rendering functions} *)

(** Get the dimensions of a rendered string of text *)
external size_text : font -> string -> int * int = "sdlttf_size_text"

(** @return the metrics (minx,maxx,miny,maxy) of a glyph *) 
external glyph_metrics : font -> char -> int * int * int * int = "sdlttf_glyph_metrics"

(** Text rendering functions *)

external render_text_solid : font -> string -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_solid"
external render_text_shaded : font -> string -> 
  fg:Sdlvideo.color -> bg:Sdlvideo.color -> Sdlvideo.surface
    = "sdlttf_render_text_shaded"
external render_text_blended : font -> string -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_blended"

(** Glyph rendering functions *)

external render_glyph_solid : font -> char -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_glyph_solid"
external render_glyph_shaded : font -> char -> 
  fg:Sdlvideo.color -> bg:Sdlvideo.color -> Sdlvideo.surface
    = "sdlttf_render_glyph_shaded"
external render_glyph_blended : font -> char -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_glyph_blended"


(* Return a function to print strings, and another to clean up printer *)
(* val make_printer : font -> (int * int * int) ->
  (Sdlvideo.surface -> int -> int -> string -> unit) * (unit -> unit) *)
