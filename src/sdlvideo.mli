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

(** $Id: sdlvideo.mli,v 1.24 2002/08/08 15:42:14 xtrm Exp $ *)

(* Exception *)

exception SDLvideo_exception of string

(* Types *)

(** rectangular area *)
type rect = 
    RectMax
  | Rect of int * int * int * int

(** red, green, blue color system *)
type color = 
    IntColor of int * int * int
  | FloatColor of float * float * float

(** pixel type *)
type pixels =
    Pixels of string * int * int
  | APixels of string * int * int
  | RGBPixels of color array array
  | Buffer of int * int

(** abstract type for manipulating surface *)
type surface

(** misc. video informations *)
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

(** differents video flags *)
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

    
type common_video_flag = [
  | `SWSURFACE
  | `HWSURFACE
  | `SRCCOLORKEY
  | `SRCALPHA ] 

(*1 Operations on display *)

(** returns information about the video hardware *)
val get_video_info : unit -> video_info

(** returns the current display surface *)
val get_display_surface : unit -> surface

(** Set up a video mode with the specified width, height and bits-per-pixel.*)
val set_display_mode : width:int -> height:int -> bpp:int -> surface 

(** Check to see if a particular video mode is supported. *)
val video_mode_ok : width:int -> height:int -> bpp:int -> video_flag list -> bool

(* Set up a video mode with the specified width, height and bits-per-pixel. *)
val set_video_mode : int -> int -> int -> video_flag list -> surface

(** Allocate and free an RGB surface (must be called after set_video_mode) *)
external create_rgb_surface : common_video_flag list -> 
  width:int -> height:int -> bpp:int -> 
    rmask:int -> gmask:int -> bmask:int -> amask:int -> unit
	= "sdlvideo_create_rgb_surface_bc" "sdlvideo_create_rgb_surface"
(* [create_rgb_surface flags width height bpp rmask gmask bmask amask] *)

(** obsolete must use set_video_mode *)
val set_opengl_mode : int -> int -> int -> surface 

(** Maps an RGB triple to an opaque pixel value for a given pixel format *)
val map_rgb : surface -> color -> int32
(*  val map_rgb : surface -> int -> int -> int -> int *)

(**  Swaps screen buffers.
  
  On hardware that supports double-buffering ([DOUBLEBUF]), this function 
  sets up a flip and returns. The hardware will wait for vertical retrace, 
  and then swap video buffers before the next video surface blit or lock 
  will return. 
  
  On hardware that doesn't support double-buffering, this is equivalent to 
  calling [update_rect get_display_surface() RectMax]  
*)
val flip : surface -> unit

(** Makes sure the given area is updated on the given screen. *)
val update_rect : surface -> rect -> unit

(*1 Operations on surfaces *)

val surface_free : surface -> unit

(** Loads a surface from a named Windows BMP file.
  
  Returns the new [surface], or raise [SDLvideo_exception] 
  if there was an error *)
val surface_loadBMP : string -> surface

(** Saves tthe [surface] as a Windows BMP file named file. *)
val surface_saveBMP : surface -> string -> unit

(*1 Accessors *)

(** return the width of the given surface *)
val surface_width : surface -> int

(** return the height of the given surface *)
val surface_height : surface -> int

(** return a rectangular area corresponding of the given surface *)
val surface_rect : surface -> rect
      
(* Grabbed in ocamlsdl-0.3 made by Jean-Christophe FILLIATRE *)
(** return the bits per pixel of the given surface *)
val surface_bpp : surface -> int

(** return the value of the red mask of the given surface *)
val surface_rmask : surface -> int
(** return the value of the green mask of the given surface *)
val surface_gmask : surface -> int
(** return the value of the blue mask of the given surface *)
val surface_bmask : surface -> int
(** return the value of the alpha mask of the given surface *)
val surface_amask : surface -> int

(** performs a fast fill of the given rectangle with 'color' *)
val surface_fill_rect : surface -> rect -> color -> surface

(**  performs a fast blit from the source surface to the destination surface. *)
val surface_blit : surface -> rect -> surface -> rect -> unit

(** sets the alpha value for the entire surface, as opposed to using the alpha component of each pixel *)
val surface_set_alpha : surface -> float -> surface

(** sets the color key (transparent pixel) in a blittable surface *)
val surface_set_colorkey : surface -> color option -> unit

(** takes a surface and copies it to a new surface of the pixel format and 
    colors of the video framebuffer, suitable for fast blitting onto 
    the display surface.*)
val surface_display_format : surface -> surface

val surface_from_pixels : pixels -> surface
val surface_set_pixel : surface -> int -> int -> color -> unit
val surface_get_pixel : surface -> int -> int -> color

val unsafe_blit_buffer : surface -> string -> int -> unit

(*1 Operations on colors *)

(** converts list of int in color type *)
val color_of_int : (int * int * int) -> color

(** converts list of float in color type *)
val color_of_float : (float * float * float) -> color

(** convert color type in list of int *)
val rgb_vector_of_color : color -> (int * int * int)

(*1 Window manager interaction *)

(** return if we can talk to a window manager *)
val wm_available : unit -> bool

(**  sets the title and icon text of the display window *) 
val wm_set_caption : string -> string -> unit

(** iconifies the window*)
val wm_iconify_window : unit -> unit

(* TO FIX: val wm_toggle_fullscreen : surface -> int  *)
(* TO DO: val wm_get_caption : string -> string -> unit  *)
(* TO DO: val wm_set_icon : surface -> int  *)

val show_cursor : bool -> unit

(* UNTESTED *)

(** [obsolete] do not use *)
val must_lock : surface -> bool

(** [obsolete] do not use *)
val lock_surface : surface -> unit

(** [obsolete] do not use *)
val unlock_surface : surface -> unit 

val surface_pixel_data : surface -> pixel_data
val gl_swap_buffers : unit -> unit




