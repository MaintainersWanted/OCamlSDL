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

(* $Id: sdlttf.ml,v 1.3 2000/02/08 00:00:42 fbrunel Exp $ *)

(* Define a new exception for TTF errors and register 
   it to be callable from C code. *)

exception SDLttf_exception of string
let _ = Callback.register_exception "SDLttf_exception" (SDLttf_exception "Any string")

(* Types *)

type font

(* Native C external functions *)

external open_font : string -> int -> font = "sdlttf_open_font"
external close_font : font -> unit = "sdlttf_close_font"
external font_height : font -> int = "sdlttf_font_height"
external font_metrics : font -> int -> int = "sdlttf_font_metrics"
external render_text : font -> string -> (int*int*int) -> (int*int*int) -> Sdlvideo.surface = "sdlttf_render_text"

let make_glyph font col str =
  let text = render_text font str col (0,0,0) in
  let pf = Sdlvideo.surface_pixel_format text in
  let color = Sdlvideo.make_rgb_color pf 0.0 0.0 0.0 in
  Sdlvideo.surface_set_colorkey text (Some color);
  let conv = Sdlvideo.surface_display_format text in
  Sdlvideo.surface_free text;
  conv

(* ML functions *)

let make_printer font col =
  (* make a memo array *)
  let glyphs = Array.make 256 (make_glyph font col "a") in
  for i = 1 to 255 do
    glyphs.(i) <- make_glyph font col (String.make 1 (Char.chr i))
  done;
  let blaa = Array.make 256 0 in
  for i = 1 to 255 do
    blaa.(i) <- font_metrics font i
  done;
  let height = font_height font in
  let free_fonts () =
    for i = 0 to 255 do
      Sdlvideo.surface_free glyphs.(i)
    done in  
  let print_string screen x y str =
    let x = ref x in
    for i = 0 to String.length str - 1 do
      let code = Char.code str.[i] in
      let img = glyphs.(code) in
      let w = Sdlvideo.surface_width img
      and h = Sdlvideo.surface_height img
      and yplus = blaa.(code) in
      Sdlvideo.surface_blit img (Sdlvideo.Rect (0,0,w,h))
                            screen (Sdlvideo.Rect (!x, y-yplus,w,h));
      x := !x + w;
      if str.[i] = ' ' then x := !x + 5
    done in
  print_string, free_fonts

