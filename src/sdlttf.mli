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

(* $Id: sdlttf.mli,v 1.8 2002/08/08 15:44:08 xtrm Exp $ *)

(** This module provides TTF (TrueType Font) support *)

(* Exception *)

exception SDLttf_exception of string

type font
(** abstract font datatype *)


(** {1 General operations on font datatype} *)

external open_font : string -> int -> font = "sdlttf_open_font"
(**   open a font file and create a font of the specified point size 
  @return font datatype 
*)

external close_font : font -> unit = "sdlttf_close_font"
(**
  close a previouly opened font file 
  @param font a font datatype returned by open_font
*)

external font_height : font -> int = "sdlttf_font_height"
(**
  @return the total height(int) of the font (usually equal to point size 
*)

external font_ascent : font -> int = "sdlttf_font_ascent"
(**
  @return the offset(int) from the baseline to the top of the font
    this is a positive value, relative to the baseline *)

external font_descent : font -> int = "sdlttf_font_descent"
(**
  @return the offset from the baseline to the bottom of the font
  this is a negative value, relative to the baseline *)

external font_metrics : font -> int -> (int*int*int*int) = "sdlttf_font_metrics"
(**
  @return the metrics (minx,maxx,miny,maxy) of the specified font 
*) 

(** {1 Render text functions} *)


(* render text functions *)
external render_text_shaded : f:font -> text:string -> foreground:Sdlvideo.color -> background:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_shaded"
(**  
  @param f font datatype
  @param text string to render
  @param foreground the 'Sdlvideo.color' of the foreground
  @param background the 'Sdlvideo.color' of the background use for the shaded fx
  @return the surface where the shaded text is render
  *)
external render_text_blended : f:font -> text:string -> foreground:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_blended"
(**  
  @param f font datatype
  @param text string to render
  @param foreground the 'Sdlvideo.color' of the foreground
  @return the surface where the blended text is render
  *)

external render_text_solid : f:font -> text:string -> foreground:Sdlvideo.color -> Sdlvideo.surface = "sdlttf_render_text_solid"
(**  
  @param f font datatype
  @param text string to render
  @param foreground the 'Sdlvideo.color' of the foreground
  @return the surface where the text is render
  *)

(* deprecated *)
external render_text : font -> string -> (int*int*int) -> (int*int*int) -> Sdlvideo.surface = "sdlttf_render_text"

(* Return a function to print strings, and another to clean up printer *)
(* val make_printer : font -> (int * int * int) ->
  (Sdlvideo.surface -> int -> int -> string -> unit) * (unit -> unit) *)
