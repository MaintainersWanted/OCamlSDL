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

(* $Id: sdlvideo.ml,v 1.6 2000/01/19 23:58:57 fbrunel Exp $ *)

(* Define a new exception for VIDEO errors and register 
   it to be callable from C code. *)

exception SDLvideo_exception of string
let _ = Callback.register_exception "SDLvideo_exception" (SDLvideo_exception "Any string")

(* Types *)

type rect = 
    RectMax
  | Rect of int * int * int * int

type pixels =
    Pixels of string * int * int
  | APixels of string * int * int
  | RGBPixels of (int * int * int) array array

type surface
type pixel_format
type color = int

type video_info = {
    hw_available : bool;	(* Hardware surfaces? *)
    wm_available : bool;	(* Window manager present? *)
    blit_hw : bool;		(* Accelerated blits HW -> HW *)
    blit_hw_color_key : bool;	(* Accelerated blits with color key *)
    blit_hw_alpha : bool;	(* Accelerated blits with alpha *)
    blit_sw : bool;		(* Accelerated blits SW -> HW *)
    blit_sw_color_key : bool;	(* Accelerated blits with color key *)
    blit_sw_alpha : bool;	(* Accelerated blits with alpha *)
    blit_fill : bool;		(* Accelerated color fill *)
    video_mem : int;		(* Total amount of video memory (Ko) *)
  } 

(* Native C external functions *)

external get_video_info : unit -> video_info = "sdlvideo_get_video_info";;
external get_display_surface : unit -> surface = "sdlvideo_get_display_surface";;
external set_display_mode : int -> int -> int -> surface = "sdlvideo_set_display_mode";;
external flip : surface -> unit = "sdlvideo_flip";;
external update_rect : surface -> rect -> unit = "sdlvideo_update_rect";;

external surface_free : surface -> unit = "sdlvideo_surface_free";;
external surface_loadBMP : string -> surface = "sdlvideo_surface_loadBMP";;
external surface_saveBMP : surface -> string -> unit = "sdlvideo_surface_saveBMP";;
external surface_width : surface -> int = "sdlvideo_surface_width";;
external surface_height : surface -> int = "sdlvideo_surface_height";;
external surface_pixel_format : surface -> pixel_format = "sdlvideo_surface_pixel_format";;
external surface_fill_rect : surface -> rect -> color -> surface = "sdlvideo_surface_fill_rect";;
external surface_blit : surface -> rect -> surface -> rect -> unit = "sdlvideo_surface_blit";;
external surface_set_alpha : surface -> float -> surface = "sdlvideo_surface_set_alpha";;

external make_rgb_color : pixel_format -> float -> float -> float -> color = "sdlvideo_make_rgb_color";;

external wm_available : unit -> bool = "sdlvideo_wm_available";;

external surface_set_colorkey : surface -> color option -> unit = "sdlvideo_surface_set_colorkey";;
external surface_display_format : surface -> surface = "sdlvideo_surface_display_format";;
external surface_from_rawrgb : string -> int -> int -> surface = "sdlvideo_surface_from_rawrgb";;
external surface_from_rawrgba : string -> int -> int -> surface = "sdlvideo_surface_from_rawrgba";;

external surface_set_pixel : surface -> int -> int -> int -> int -> int -> unit = "sdlvideo_surface_set_pixel_bytecode" "sdlvideo_surface_set_pixel";;
external surface_get_pixel : surface -> int -> int -> (int * int * int) = "sdlvideo_surface_get_pixel";;

(* ML functions *)

let surface_rect surf =
  Rect(0, 0, surface_width surf, surface_height surf);;

let surface_from_pixels = function
    Pixels (str, w, h) -> surface_from_rawrgb str w h
  | APixels (str, w, h) -> surface_from_rawrgba str w h
  | RGBPixels mat ->
      let w = Array.length mat and h = Array.length mat.(0) in
      let str = String.create (w*h*3) in
      for i = 0 to w - 1 do
      	for j = 0 to h - 1 do
          let (r,g,b) = mat.(i).(j) in
	  str.[(i+j*w)*3+0] <- Char.chr r;
	  str.[(i+j*w)*3+1] <- Char.chr g;
	  str.[(i+j*w)*3+2] <- Char.chr b;
      	done
      done;
      surface_from_rawrgb str w h

