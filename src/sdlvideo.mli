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

(* $Id: sdlvideo.mli,v 1.22 2002/07/13 17:06:31 oliv__a Exp $ *)

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

type video_flag = [
  | `SWSURFACE   (* Surface is in system memory *)
  | `HWSURFACE   (* Surface is in video memory *)
  | `SRCCOLORKEY (* Blit uses a source color key *)
  | `SRCALPHA    (* Blit uses source alpha blending *)
  | `ASYNCBLIT   (* Enables the use of asynchronous to the display surface *)
  | `ANYFORMAT   (* Allow any video pixel format *)
  | `HWPALETTE   (* Give SDL exclusive palette access *)
  | `DOUBLEBUF   (* Set up double-buffered video mode *)
  | `FULLSCREEN  (* Surface is a full screen display *)
  | `OPENGL      (* OpenGL rendering *)
  | `OPENGLBLIT  (* *)
  | `RESIZABLE   (* Create a resizable window *)
  | `NOFRAME     (* Frame without titlebar *)
] 

(*1 Operations on display *)

val get_video_info : unit -> video_info;;
(*d returns information about the video hardware *)

val get_display_surface : unit -> surface;;
(*d 
  returns the current display surface 
*)

val set_display_mode : height:int -> width:int -> bpp:int -> surface;; 

val video_mode_ok : int -> int -> int -> video_flag list -> bool
(*d
  [video_mode_ok width height bpp flags] 
*)

val set_video_mode : int -> int -> int -> video_flag list -> surface
(*d 
  [set_video_mode width height bpp flags] 
  Set up a video mode with the specified width, height and bits-per-pixel. 
*)
    
type common_video_flag = [
  | `SWSURFACE
  | `HWSURFACE
  | `SRCCOLORKEY
  | `SRCALPHA ] 
external create_rgb_surface : common_video_flag list -> 
  width:int -> height:int -> bpp:int -> 
    rmask:int -> gmask:int -> bmask:int -> amask:int -> unit
	= "sdlvideo_create_rgb_surface_bc" "sdlvideo_create_rgb_surface"
(* [create_rgb_surface flags width height bpp rmask gmask bmask amask] *)

val set_opengl_mode : int -> int -> int -> surface;; 
(*d
  obsolete must use [set_video_mode]
*)

val map_rgb : surface -> color -> int32
(*  val map_rgb : surface -> int -> int -> int -> int *)
(*d Maps an RGB triple to an opaque pixel value for a given pixel format *)

val flip : surface -> unit;;
(*d
  Swaps screen buffers.
  
  On hardware that supports double-buffering ([DOUBLEBUF]), this function 
  sets up a flip and returns. The hardware will wait for vertical retrace, 
  and then swap video buffers before the next video surface blit or lock 
  will return. 
  
  On hardware that doesn't support double-buffering, this is equivalent to 
  calling [update_rect get_display_surface() RectMax]  
*)
val update_rect : surface -> rect -> unit;;
(*d
  Makes sure the given area is updated on the given screen.
*)

(*1 Operations on surfaces *)

val surface_free : surface -> unit;;
val surface_loadBMP : string -> surface;;
(*d
  Loads a surface from a named Windows BMP file.
  
  Returns the new [surface], or raise [SDLvideo_exception] 
  if there was an error
*)

val surface_saveBMP : surface -> string -> unit;;
(*d 
  Saves tthe [surface] as a Windows BMP file named file.
*)

(*1 Accessors *)
val surface_width : surface -> int;;
val surface_height : surface -> int;;
val surface_rect : surface -> rect;;
      
(* Grabbed in ocamlsdl-0.3 made by Jean-Christophe FILLIATRE *)
val surface_bpp : surface -> int
val surface_rmask : surface -> int
val surface_gmask : surface -> int
val surface_bmask : surface -> int
val surface_amask : surface -> int

val surface_fill_rect : surface -> rect -> color -> surface;;
val surface_blit : surface -> rect -> surface -> rect -> unit;;
val surface_set_alpha : surface -> float -> surface;;
val surface_set_colorkey : surface -> color option -> unit;;
val surface_display_format : surface -> surface;;

val surface_from_pixels : pixels -> surface;;
val surface_set_pixel : surface -> int -> int -> color -> unit;;
val surface_get_pixel : surface -> int -> int -> color;;

val unsafe_blit_buffer : surface -> string -> int -> unit;;

(*1 Operations on colors *)

val color_of_int : (int * int * int) -> color;;
val color_of_float : (float * float * float) -> color;;
val rgb_vector_of_color : color -> (int * int * int);;

(*1 Window manager interaction *)

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
val gl_swap_buffers : unit -> unit;;




