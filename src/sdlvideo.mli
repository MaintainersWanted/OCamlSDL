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

(* $Id: sdlvideo.mli,v 1.12 2000/09/04 17:52:12 smkl Exp $ *)

(* Exception *)

exception SDLvideo_exception of string

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

type pixel_data =
  (int, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

(* Operations on display *)

val get_video_info : unit -> video_info;;
val get_display_surface : unit -> surface;;
val set_display_mode : int -> int -> int -> surface;; 

val flip : surface -> unit;;
val update_rect : surface -> rect -> unit;;

(* Operations on surfaces *)

val surface_free : surface -> unit;;
val surface_loadBMP : string -> surface;;
val surface_saveBMP : surface -> string -> unit;;
val surface_width : surface -> int;;
val surface_height : surface -> int;;
val surface_rect : surface -> rect;;
val surface_fill_rect : surface -> rect -> color -> surface;;
val surface_blit : surface -> rect -> surface -> rect -> unit;;
val surface_set_alpha : surface -> float -> surface;;
val surface_set_colorkey : surface -> color option -> unit;;
val surface_display_format : surface -> surface;;

val surface_from_pixels : pixels -> surface;;
val surface_set_pixel : surface -> int -> int -> color -> unit;;
val surface_get_pixel : surface -> int -> int -> color;;

val unsafe_blit_buffer : surface -> string -> int -> unit;;

(* Operations on colors *)

val color_of_int : (int * int * int) -> color;;
val color_of_float : (float * float * float) -> color;;
val rgb_vector_of_color : color -> (int * int * int);;

(* Window manager interaction *)

val wm_available : unit -> bool;;
val wm_set_caption : string -> string -> unit;;
val wm_iconify_window : unit -> unit;;
(* TO FIX: val wm_toggle_fullscreen : surface -> int ;; *)
(* TO DO: val wm_get_caption : string -> string -> unit ;; *)
(* TO DO: val wm_set_icon : surface -> int ;; *)

val show_cursor : bool -> unit;;

(* UNTESTED *)
val must_lock : surface -> bool;;
val lock_surface : surface -> unit;;
val unlock_surface : surface -> unit;; 
val surface_pixel_data : surface -> pixel_data;;

(* DO NOT USE. EXPERIMENTAL *)

val surface_final : unit -> surface;;


