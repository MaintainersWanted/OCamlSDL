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

(* $Id: sdlttf.ml,v 1.9 2002/08/09 15:39:22 oliv__a Exp $ *)

(* Define a new exception for TTF errors and register 
   it to be callable from C code. *)

exception SDLttf_exception of string
let _ = Callback.register_exception "SDLttf_exception" (SDLttf_exception "Any string")

(* Types *)

type font

(* Native C external functions *)

external open_font : string -> ?index:int -> int -> font = "sdlttf_open_font"
external close_font : font -> unit = "sdlttf_close_font"

type font_style =
  | NORMAL
  | BOLD
  | ITALIC
  | UNDERLINE

external get_font_style : font -> font_style = "sdlttf_get_font_style"
external set_font_style : font -> font_style -> unit = "sdlttf_set_font_style"

external font_height : font -> int = "sdlttf_font_height"
external font_ascent : font -> int = "sdlttf_font_ascent"
external font_descent : font -> int = "sdlttf_font_descent"
external font_lineskip : font -> int = "ml_TTF_FontLineSkip"
external font_faces : font -> int = "ml_TTF_FontFaces"
external is_fixed_width : font -> bool = "ml_TTF_FontFaceIsFixedWidth"
external family_name : font -> string = "ml_TTF_FontFaceFamilyName"
external style_name : font -> string = "ml_TTF_FontFaceStyleName"

external size_text : font -> string -> int * int = "sdlttf_size_text"

external render_text_solid : font -> string -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_solid"
external render_text_shaded : font -> string -> 
  fg:Sdlvideo.color -> bg:Sdlvideo.color -> Sdlvideo.surface
    = "sdlttf_render_text_shaded"
external render_text_blended : font -> string -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_blended"

external render_glyph_solid : font -> char -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_glyph_solid"
external render_glyph_shaded : font -> char -> 
  fg:Sdlvideo.color -> bg:Sdlvideo.color -> Sdlvideo.surface
    = "sdlttf_render_glyph_shaded"
external render_glyph_blended : font -> char -> 
  fg:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_glyph_blended"


external glyph_metrics : font -> char -> int * int * int * int 
    = "sdlttf_glyph_metrics"

(* ML functions *)

(* let make_glyph font col str =*)
(*   let text = render_text_blended font str col (0,0,0) in*)
(*   Sdlvideo.surface_set_colorkey text (Some (Sdlvideo.IntColor(0, 0, 0)));*)
(*   let conv = Sdlvideo.surface_display_format text in*)
(*   Sdlvideo.surface_free text;*)
(*   conv*)

(* let make_printer font col =*)
(*   (* make a memo array *)*)
(*   let glyphs = Array.make 256 (make_glyph font col "a") in*)
(*   for i = 1 to 255 do*)
(*     glyphs.(i) <- make_glyph font col (String.make 1 (Char.chr i))*)
(*   done;*)
(*   let blaa = Array.make 256 0 in*)
(*   for i = 1 to 255 do*)
(*     let minx, maxx, miny, maxy = font_metrics font i in*)
(*     blaa.(i) <- miny*)
(*   done;*)
(*   let height = font_height font in*)
(*   let free_fonts () =*)
(*     for i = 0 to 255 do*)
(*       Sdlvideo.surface_free glyphs.(i)*)
(*     done in  *)
(*   let print_string screen x y str =*)
(*     let x = ref x in*)
(*     for i = 0 to String.length str - 1 do*)
(*       let code = Char.code str.[i] in*)
(*       let img = glyphs.(code) in*)
(*       let w = Sdlvideo.surface_width img*)
(*       and h = Sdlvideo.surface_height img*)
(*       and yplus = blaa.(code) in*)
(*       Sdlvideo.surface_blit img (Sdlvideo.Rect (0,0,w,h))*)
(*                             screen (Sdlvideo.Rect (!x, y-yplus,w,h));*)
(*       x := !x + w;*)
(*       if str.[i] = ' ' then x := !x + 5*)
(*     done in*)
(*   print_string, free_fonts*)

