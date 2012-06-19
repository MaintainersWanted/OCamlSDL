(*
 * OCamlSDL - An ML interface to the SDL library
 * Copyright (C) 1999, 2000, 2001, 2002  OCamlSDL development team
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

(** Module for video manipulations *)

(* $Id: sdlvideo.mli,v 1.34 2012/06/19 18:20:59 oliv__a Exp $ *)

open Bigarray

exception Video_exn of string

(** {3 Rectangles} *)

type rect = {
    mutable r_x : int ;
    mutable r_y : int ;
    mutable r_w : int ;
    mutable r_h : int ;
  }
  (** rectangular area (x, y, w, h) *)

val rect : x:int -> y:int -> w:int -> h:int -> rect

val copy_rect : rect -> rect
(** @return a copy of the rectangle *)


(** {3 Video mode informations} *)

type pixel_format_info = {
    palette  : bool ;
    bits_pp  : int ;   (** bits per pixel *)
    bytes_pp : int ;   (** bytes per pixel *)
    rmask    : int32 ; (** red mask value *)
    gmask    : int32 ; (** green mask value *)
    bmask    : int32 ; (** blue mask value *)
    amask    : int32 ; (** alpha mask value *)
    rshift   : int ; 
    gshift   : int ;
    bshift   : int ;
    ashift   : int ;
    rloss    : int ;
    gloss    : int ;
    bloss    : int ;
    aloss    : int ;
    colorkey : int32 ; 	(** RGB color key information *)
    alpha    : int ; 	(** Alpha value information (per-surface alpha) *)
  } 
(** Structure describing how color are encoded as pixels *)

type video_info = {
    hw_available : bool;	(** Hardware surfaces? *)
    wm_available : bool;	(** Window manager present? *)
    blit_hw : bool;		(** Accelerated blits HW -> HW *)
    blit_hw_color_key : bool;	(** Accelerated blits with color key *)
    blit_hw_alpha : bool;	(** Accelerated blits with alpha *)
    blit_sw : bool;		(** Accelerated blits SW -> HW *)
    blit_sw_color_key : bool;	(** Accelerated blits with color key *)
    blit_sw_alpha : bool;	(** Accelerated blits with alpha *)
    blit_fill : bool;		(** Accelerated color fill *)
    video_mem : int;		(** Total amount of video memory (Ko) *)
  } 
(** Information on either the 'best' available mode (if called before
   [set_video_mode]) or the current video mode. *)

val get_video_info : unit -> video_info
   
(** @return information about the video hardware *)

val get_video_info_format : unit -> pixel_format_info
(** @return information about the pixel format *)

val driver_name : unit -> string
(** @return the name of the video driver *)

type video_flag = [
  | `SWSURFACE   (** Surface is in system memory *)
  | `HWSURFACE   (** Surface is in video memory *)
  | `ASYNCBLIT   (** Enables the use of asynchronous updates of the display
		    surface. This will usually slow down blitting on single
		    CPU machines, but may provide a speed increase on SMP
		    systems.*)
  | `ANYFORMAT   (** Normally, if a video surface of the requested 
		    bits-per-pixel (bpp) is not available, SDL will emulate
		    one with a shadow surface. Passing [`ANYFORMAT] prevents
		    this and causes SDL to use the video surface, regardless 
		    of its pixel depth. *)
  | `HWPALETTE   (** Give SDL exclusive palette access *)
  | `DOUBLEBUF   (** Enable hardware double buffering; only valid with
		    [`HWSURFACE]. Calling {!Sdlvideo.flip} will flip the
		    buffers and update the screen. All drawing will take place
		    on the surface that is not displayed at the moment. If
		    double buffering could not be enabled then {!Sdlvideo.flip}
		    will just perform a {!Sdlvideo.update_rect} on the entire
		    screen. *)
  | `FULLSCREEN  (** SDL will attempt to use a fullscreen mode. If a hardware
		    resolution change is not possible (for whatever reason), 
		    the next higher resolution will be used and the display
		    window centered on a black background. *)
  | `OPENGL      (** Create an OpenGL rendering context. You should have
		    previously set OpenGL video attributes with
		    SDL_GL_SetAttribute. *)
  | `OPENGLBLIT  (** Create an OpenGL rendering context, like above, but allow
		    normal blitting operations. The screen (2D) surface may
		    have an alpha channel, and {!Sdlvideo.update_rect} must
		    be used for updating changes to the screen surface. *)
  | `RESIZABLE   (** Create a resizable window. When the window is resized by
		    the user a {!Sdlevent2.VIDEORESIIZE} event is generated
		    and {!Sdlvideo.set_video_mode} can be called again with
		    the new size. *)
  | `NOFRAME     (** If possible, [`NOFRAME] causes SDL to create a window
		    with no title bar or frame decoration. Fullscreen modes
		    automatically have this flag set. *)
] 

type modes =
  | NOMODE   (** no dimensions available for the requested format *)
  | ANY      (** any dimension okay *)
  | DIM of (int * int) list

val list_modes : ?bpp:int -> video_flag list -> modes
(** @return a list of available screen dimensions for the given format 
  and video flags, sorted largest to smallest or NOMODE or ANY *)


val video_mode_ok : w:int -> h:int -> bpp:int -> video_flag list -> int
(** Check to see if a particular video mode is supported.  
   @return 0 if the requested mode is not supported or returns the
   bits-per-pixel of the closest available mode with the given width
   and height.  If this bits-per-pixel is different from the one used
   when setting the video mode, set_video_mode will succeed, but will
   emulate the requested bits-per-pixel with a shadow surface. *)


(** {3 Surfaces} *)

type surface 
(** Graphical surface datatype *)

type surface_flags = [
  | video_flag
  | `HWACCEL     (** Blit uses hardware acceleration *)
  | `SRCCOLORKEY (** Blit uses a source color key *)
  | `RLEACCEL    (** Surface is RLE encoded *)
  | `SRCALPHA    (** Blit uses source alpha blending *)
  | `PREALLOC    (** Surface uses preallocated memory *)
]
 
type surface_info = {
    flags     : surface_flags list ;
    w         : int ;   (** width *)
    h         : int ;   (** height *)
    pitch     : int ;   (** pitch *)
    clip_rect : rect ;  (** clipping information *)
    refcount  : int ;   (** reference count *)
  }

val surface_info : surface -> surface_info
(** @return information for the given [surface] *)

val surface_format : surface -> pixel_format_info
(** @return pixel format information for the given [surface] *)

val surface_dims   : surface -> int * int * int
(** @return width, height and pitch of the given [surface] *)

val surface_flags  : surface -> surface_flags list
(** @return flag list for the given [surface] *)

val surface_bpp    : surface -> int
(** @return bits-per-pixel for the given [surface] *)


(** {3 Video modes-related functions} *)

val get_video_surface : unit -> surface
(** @return the current display [surface] *)

val set_video_mode : 
  w:int -> h:int -> ?bpp:int -> video_flag list -> surface
(** Set up a video mode with the specified [width], [height] and
   [bits-per-pixel].  
   @param bpp if omited, it is treated as the current display bits per
   pixel
   @return the current display [surface] *)

val update_rect : ?rect:rect -> surface -> unit
(** @param rect makes sure the given area is updated on the given
   screen. The rectangle must be confined within the screen boundaries
   (no clipping is done). Updates the entire screen if omitted *)

val update_rects : rect list -> surface -> unit
(** Makes sure the given list of rectangles is updated on the given
   screen. The rectangles must all be confined within the screen
   boundaries (no clipping is done).
   This function should not be called while screen is locked.*)

val flip : surface -> unit
(**  Swaps screen buffers.
  
  On hardware that supports double-buffering ([`DOUBLEBUF]), this function 
  sets up a flip and returns. The hardware will wait for vertical retrace, 
  and then swap video buffers before the next video surface blit or lock 
  will return. 
  
  On hardware that doesn't support double-buffering, this is equivalent to 
  calling [update_rect]  
*)


(** {3 Color manipulation} *)

val set_gamma : r:float -> g:float -> b:float -> unit
(**  Set the gamma correction for each of the color channels. 
  The gamma values range (approximately) between 0.1 and 10.0 
  If this function isn't supported directly by the hardware, it will
  be emulated using gamma ramps, if available.*)

type color = int * int * int
(** Format independent color description [(r,g,b)] are 8 bits unsigned
   integers *)

val black   : color
val white   : color
val red     : color 
val green   : color
val blue    : color
val yellow  : color
val cyan    : color
val magenta : color

(** {4 Palettes} *)

val use_palette : surface -> bool
(** @return [true] if surface use indexed colors *)

val palette_ncolors     : surface -> int 
(** Number of colors in the surface's palette *)

val get_palette_color   : surface -> int -> color
(** Retrieve a color by its index in a surface's palette *)

type palette_flag =
  | LOGPAL (** set logical palette, which controls how blits are mapped
	     to/from the surface *)
  | PHYSPAL (** set physical palette, which controls how pixels 
	      look on the screen *)
  | LOGPHYSPAL

val set_palette : surface -> 
  ?flag:palette_flag -> ?firstcolor:int -> color array -> unit
(** Sets a portion of the palette for a given 8-bit [surface].
   @param flag defaults to LOGPHYSPAL
   @param firstcolor where to blit the color array given as argument
   (defaults to 0)
*)

(** {4 Conversions} *)

val map_RGB : surface -> ?alpha:int -> color -> int32
(** Maps an RGB triple or an RGBA quadruple to a pixel value for a given 
  pixel format *)

val get_RGB : surface -> int32 -> color
(** Maps a pixel value into the RGB components for a given pixel format 
   @return RGB color *)

val get_RGBA : surface -> int32 -> color * int
(** Maps a pixel value into the RGBA components for a given pixel format *
  @return RGB color and alpha value *)


(** {3 Creating RGB surface} *)

val create_RGB_surface : 
  [ `SWSURFACE | `HWSURFACE | `ASYNCBLIT | `SRCCOLORKEY | `SRCALPHA ] list ->
  w:int -> h:int -> bpp:int -> 
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
(** Creates a RGB surface.
  If the depth is 4 or 8 bits, an empty palette is allocated 
  for the surface. If the depth is greater than 8 bits, the pixel format is 
  set using the given masks.

  @return the new surface *)

val create_RGB_surface_format : surface ->
  [ `SWSURFACE | `HWSURFACE | `ASYNCBLIT | `SRCCOLORKEY | `SRCALPHA ] list ->
  w:int -> h:int -> surface
(** Creates a RGB surface with the same pixel format as the first
   parameter. *)

val create_RGB_surface_from_32 : 
  (int32, int32_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
val create_RGB_surface_from_24 : 
  (int, int8_unsigned_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int -> gmask:int -> bmask:int -> amask:int -> surface
val create_RGB_surface_from_16 : 
  (int, int16_unsigned_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int -> gmask:int -> bmask:int -> amask:int -> surface
val create_RGB_surface_from_8 : 
  (int, int8_unsigned_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int -> gmask:int -> bmask:int -> amask:int -> surface



(** {3 Locking/Unlocking surface} *)


val must_lock : surface -> bool
(** @return [true] if the surface should be locked before accessing
   its pixels *)

val lock : surface -> unit
(** Sets up a surface for directly accessing the pixels. *)

val unlock : surface -> unit
(** Releases the lock on the given [surface] *)


(** {3 Accessing surface pixels} *)

val pixel_data : surface -> (int, int8_unsigned_elt, c_layout) Array1.t

val pixel_data_8 : surface -> (int, int8_unsigned_elt, c_layout) Array1.t

val pixel_data_16 : surface -> (int, int16_unsigned_elt, c_layout) Array1.t

val pixel_data_24 : surface -> (int, int8_unsigned_elt, c_layout) Array1.t

val pixel_data_32 : surface -> (int32, int32_elt, c_layout) Array1.t


val get_pixel : surface -> x:int -> y:int -> int32
val get_pixel_color : surface -> x:int -> y:int -> color
(** Access an individual pixel on a surface and returns is as a [color].
   The surface may have to be locked before access. *)

val put_pixel : surface -> x:int -> y:int -> int32 -> unit
val put_pixel_color : surface -> x:int -> y:int -> color -> unit
(** Sets an individual pixel on a surface.
   The surface may have to be locked before access. *)


(** {3 Reading/writing in BMP files} *)

val load_BMP : string -> surface
(** Loads a surface from a named Windows BMP file.*)

val load_BMP_from_mem : string -> surface
(** Loads a BMP image from a memory buffer. *)

val save_BMP : surface -> string -> unit
(** Saves the [surface] as a Windows BMP file named file. *)


(** {3 Colorkey and alpha stuff} *)

val unset_color_key : surface -> unit

val set_color_key : surface -> ?rle:bool -> int32 -> unit
(** Sets the color key (transparent pixel) in a blittable [surface]. *)

val get_color_key : surface -> int32
(** @return the color key of the given [surface] *)

val unset_alpha : surface -> unit

val set_alpha : surface -> ?rle:bool -> int -> unit
(** sets the alpha value for the entire [surface], as opposed to
   using the alpha component of each pixel. *)

val get_alpha : surface -> int
(** @return the alpha value of the given [surface] *)



(** {3 Clipping} *)


val unset_clip_rect : surface -> unit
(** disable clipping for the given [surface] *)

val set_clip_rect : surface -> rect -> unit
(** Sets the clipping rectangle for the destination [surface] in a blit. *)

val get_clip_rect : surface -> rect
(** @return the clipping rectangle for the destination [surface] in a blit. *)

(** {3 Blitting} *)

val blit_surface : 
  src:surface -> ?src_rect:rect -> 
  dst:surface -> ?dst_rect:rect -> unit -> unit
(** Performs a fast blit from the source [surface] 
   to the destination [surface]. 

   @param src_rect the width and height determine the size of the
   copied rectangle. If omitted, the entire surface is copied.

   @param dst_rect only the position is used (the width and height are
   ignored). If omitted, the detination position (upper left corner)
   is (0, 0).

   The final blit rectangles are saved in [src_rect] and [dst_rect]
   after all clipping is performed.

   The blit function should not be called on a locked surface.
*)

val fill_rect : ?rect:rect -> surface -> int32 -> unit
(** performs a fast fill of the given rectangle with 'color' *)

val display_format : ?alpha:bool -> surface -> surface
(** This function takes a surface and copies it to a new surface of the
   pixel format and colors of the video framebuffer, suitable for fast
   blitting onto the display surface. 
   @param alpha if [true], include an alpha channel in the new surface *)
