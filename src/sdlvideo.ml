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

(* $Id: sdlvideo.ml,v 1.15 2001/05/11 09:29:56 xtrm Exp $ *)

(* Define a new exception for VIDEO errors and register 
   it to be callable from C code. *)

exception SDLvideo_exception of string
let _ = Callback.register_exception "SDLvideo_exception" (SDLvideo_exception "Any string")

(* Types *)

type rect = 
    RectMax
  | Rect of int * int * int * int

type color = 
    IntColor of int * int * int
  | FloatColor of float * float * float

type pixels =
    Pixels of string * int * int
  | APixels of string * int * int
  | RGBPixels of color array array
  | Buffer of int * int

type surface

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

type pixel_data = (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

(* Native C external functions *)

external get_video_info : unit -> video_info = "sdlvideo_get_video_info";;
external get_display_surface : unit -> surface = "sdlvideo_get_display_surface";;
external set_display_mode : int -> int -> int -> surface = "sdlvideo_set_display_mode";;
external set_opengl_mode : int -> int -> int -> surface = "sdlvideo_set_opengl_mode";;
external flip : surface -> unit = "sdlvideo_flip";;
external update_rect : surface -> rect -> unit = "sdlvideo_update_rect";;

external surface_free : surface -> unit = "sdlvideo_surface_free";;
external surface_loadBMP : string -> surface = "sdlvideo_surface_loadBMP";;
external surface_saveBMP : surface -> string -> unit = "sdlvideo_surface_saveBMP";;

external surface_width : surface -> int = "sdlvideo_surface_width";;
external surface_height : surface -> int = "sdlvideo_surface_height";;
external surface_bpp : surface -> int = "sdlvideo_surface_bpp" ;;
external surface_rmask : surface -> int = "sdlvideo_surface_rmask" ;;
external surface_gmask : surface -> int = "sdlvideo_surface_gmask" ;;
external surface_bmask : surface -> int = "sdlvideo_surface_bmask" ;;
external surface_amask : surface -> int = "sdlvideo_surface_amask" ;;

external surface_fill_rect : surface -> rect -> color -> surface = "sdlvideo_surface_fill_rect";;
external surface_blit : surface -> rect -> surface -> rect -> unit = "sdlvideo_surface_blit";;
external surface_set_alpha : surface -> float -> surface = "sdlvideo_surface_set_alpha";;

external wm_available : unit -> bool = "sdlvideo_wm_available";;
external wm_set_caption : string -> string -> unit = "sdlvideo_wm_set_caption" ;;
external wm_iconify_window : unit -> unit = "sdlvideo_wm_iconify_window";;

(* TO FIX: external wm_toggle_fullscreen : surface -> int = "sdlvideo_wm_toggle_fullscreen";; *)
(* TO DO: external wm_get_caption : string -> string -> unit = "sdlvideo_wm_get_caption" ;; *)
(* TO DO: extern wm_set_icon : surface -> int = "sdlvideo_wm_set_icon";; *)

external surface_set_colorkey : surface -> color option -> unit = "sdlvideo_surface_set_colorkey";;
external surface_display_format : surface -> surface = "sdlvideo_surface_display_format";;

external empty_surface : int -> int -> surface = "sdlvideo_empty_surface";;
external surface_from_rawrgb : string -> int -> int -> surface = "sdlvideo_surface_from_rawrgb";;
external surface_from_rawrgba : string -> int -> int -> surface = "sdlvideo_surface_from_rawrgba";;

external surface_set_pixel : surface -> int -> int -> color -> unit = "sdlvideo_surface_set_pixel_bytecode" "sdlvideo_surface_set_pixel";;
external surface_get_pixel : surface -> int -> int -> color = "sdlvideo_surface_get_pixel";;

external unsafe_blit_buffer : surface -> string -> int -> unit = "sdlvideo_blit_raw_buffer";;
external show_cursor : bool -> unit = "sdlvideo_show_cursor";;

(* UNTESTED *)
external must_lock : surface -> bool = "sdlvideo_must_lock";;
external lock_surface : surface -> unit = "sdlvideo_lock_surface";;
external unlock_surface  : surface -> unit = "sdlvideo_unlock_surface";;
external surface_pixel_data : surface -> pixel_data = "sdlvideo_surface_pixel_data";;
external gl_swap_buffers : unit -> unit = "sdlvideo_gl_swap_buffers";;

external surface_final : unit -> surface = "sdlvideo_surface_final";;

(* ML functions *)

let bound_int_comp c =
  if c < 0 then 0
  else if c > 255 then 255
  else c;;

let bound_float_comp c =
  if c < 0.0 then 0.0
  else if c > 1.0 then 1.0
  else c;;

let color_of_int (r, g, b) = 
  IntColor(bound_int_comp r,
	   bound_int_comp g,
	   bound_int_comp b);;
  
let color_of_float (r, g, b) = 
  FloatColor(bound_float_comp r,
	     bound_float_comp g,
	     bound_float_comp b);;

let rgb_vector_of_color color =
  match color with
    IntColor(r, g, b) -> (bound_int_comp r, bound_int_comp g, bound_int_comp b)
  | FloatColor(r, g, b) -> (bound_int_comp (int_of_float (r *. 255.0)), 
			    bound_int_comp (int_of_float (g *. 255.0)), 
			    bound_int_comp (int_of_float (b *. 255.0)));;

let surface_rect surf =
  Rect(0, 0, surface_width surf, surface_height surf);;

let surface_from_pixels = function
    RGBPixels mat ->
      let w = Array.length mat and h = Array.length mat.(0) in
      let str = String.create (w * h * 3) in
      for i = 0 to w - 1 do
      	for j = 0 to h - 1 do
          let (r,g,b) = rgb_vector_of_color mat.(i).(j) in
	  let ind = (i + j * w) * 3 in
	  str.[ind] <- Char.unsafe_chr r;
	  str.[ind + 1] <- Char.unsafe_chr g;
	  str.[ind + 2] <- Char.unsafe_chr b;
      	done
      done;
      surface_from_rawrgb str w h
  | Pixels (str, w, h) -> surface_from_rawrgb str w h
  | APixels (str, w, h) -> surface_from_rawrgba str w h
  | Buffer (w, h) -> empty_surface w h
