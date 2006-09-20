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

(* $Id: sdlttf.ml,v 1.13 2006/09/20 10:38:49 jboulnois Exp $ *)

(* Define a new exception for TTF errors and register 
   it to be callable from C code. *)

exception SDLttf_exception of string
let _ = Callback.register_exception "SDLttf_exception" (SDLttf_exception "")

(* Types *)

type font

external init : unit -> unit = "sdlttf_init"
external quit : unit -> unit = "sdlttf_kill"

(* Native C external functions *)

external open_font : string -> ?index:int -> int -> font = "sdlttf_open_font"

type font_style =
  | NORMAL
  | BOLD
  | ITALIC
  | UNDERLINE

external get_font_style : font -> font_style list = "sdlttf_get_font_style"
external set_font_style : font -> font_style list -> unit = "sdlttf_set_font_style"

external font_height : font -> int = "sdlttf_font_height"
external font_ascent : font -> int = "sdlttf_font_ascent"
external font_descent : font -> int = "sdlttf_font_descent"
external font_lineskip : font -> int = "ml_TTF_FontLineSkip"
external font_faces : font -> int = "ml_TTF_FontFaces"
external is_fixed_width : font -> bool = "ml_TTF_FontFaceIsFixedWidth"
external family_name : font -> string = "ml_TTF_FontFaceFamilyName"
external style_name : font -> string = "ml_TTF_FontFaceStyleName"

external size_text : font -> string -> int * int = "sdlttf_size_text"

(* UTF8 *)
external size_utf8 : font -> string -> int * int = "sdlttf_size_utf8"

open Sdlvideo

external render_text_solid : font -> string -> 
  fg:color -> surface = "sdlttf_render_text_solid"
external render_text_shaded : font -> string -> 
  fg:color -> bg:color -> surface
    = "sdlttf_render_text_shaded"
external render_text_blended : font -> string -> 
  fg:color -> surface = "sdlttf_render_text_blended"

(* UTF8 *)
external render_utf8_solid : font -> string -> 
  fg:color -> surface = "sdlttf_render_utf8_solid"
external render_utf8_shaded : font -> string -> 
  fg:color -> bg:color -> surface = "sdlttf_render_utf8_shaded"
external render_utf8_blended : font -> string -> 
  fg:color -> surface = "sdlttf_render_utf8_blended"

type render_kind =
  | SOLID   of color
  | SHADED  of color * color
  | BLENDED of color

let render_text font kind txt =
  match kind with
  | SOLID fg -> render_text_solid font txt ~fg
  | SHADED (fg, bg) -> render_text_shaded font txt ~fg ~bg
  | BLENDED fg -> render_text_blended font txt ~fg

external render_glyph_solid : font -> char -> 
  fg:color -> surface = "sdlttf_render_glyph_solid"
external render_glyph_shaded : font -> char -> 
  fg:color -> bg:color -> surface
    = "sdlttf_render_glyph_shaded"
external render_glyph_blended : font -> char -> 
  fg:color -> surface = "sdlttf_render_glyph_blended"

let render_glyph font kind c =
  match kind with
  | SOLID fg -> render_glyph_solid font c ~fg
  | SHADED (fg, bg) -> render_glyph_shaded font c ~fg ~bg
  | BLENDED fg -> render_glyph_blended font c ~fg

external glyph_metrics : font -> char -> int * int * int * int 
    = "sdlttf_glyph_metrics"
