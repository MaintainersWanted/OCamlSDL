
open Bigarray

(** SDL video functions *)

exception Video_exn of string

type color = int * int * int 
  (** (r, g, b) *)
      
type rect = {
    mutable r_x : int ;
    mutable r_y : int ;
    mutable r_w : int ;
    mutable r_h : int ;
  }
  (** (x, y, w, h) *)

val rect : x:int -> y:int -> w:int -> h:int -> rect
val copy_rect : rect -> rect

type palette = (int, int_elt, c_layout) Array1.t

val ncolors   : palette -> int
val get_color : palette -> int -> color

type pixel_format
type pixel_format_info = {
    palette  : palette option ;
    bits_pp  : int ;
    bytes_pp : int ;
    rmask    : int32 ;
    gmask    : int32 ;
    bmask    : int32 ;
    amask    : int32 ;
    rshift   : int ;
    gshift   : int ;
    bshift   : int ;
    ashift   : int ;
    rloss    : int ;
    gloss    : int ;
    bloss    : int ;
    aloss    : int ;
    colorkey : int32 ;
    alpha    : int ;
  } 

external pixel_format_info : pixel_format -> pixel_format_info
    = "ml_pixelformat_info"

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
    vi_fmt : pixel_format ;
  } 

external get_video_info : unit -> video_info
    = "ml_SDL_GetVideoInfo"

external driver_name : unit -> string
    = "ml_SDL_VideoDriverName"

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
  | NOMODE
  | ANY
  | DIM of (int * int) list

external list_modes : ?bpp:int -> video_flag list -> modes
    = "ml_SDL_ListModes"


external video_mode_ok : w:int -> h:int -> bpp:int -> video_flag list -> int
    = "ml_SDL_VideoModeOK"


type surface_flags = [
  | video_flag
  | `HWACCEL
  | `SRCCOLORKEY
  | `RLEACCEL
  | `SRCALPHA
  | `PREALLOC 
]
 
type surface
type surface_info = {
    flags     : surface_flags list ;
    fmt       : pixel_format ;
    w         : int ;
    h         : int ;
    pitch     : int ;
    clip_rect : rect ;
    refcount  : int ;
  }

external surface_info : surface -> surface_info
    = "ml_sdl_surface_info"

val surface_dims   : surface -> int * int * int
val surface_format : surface -> pixel_format_info
val surface_flags  : surface -> surface_flags list
val surface_bpps   : surface -> int

external use_palette : surface -> bool
    = "ml_sdl_surface_use_palette"

external set_video_mode : 
  w:int -> h:int -> bpp:int -> video_flag list -> surface
    = "ml_SDL_SetVideoMode"

external update_rect : ?rect:rect -> surface -> unit
    = "ml_SDL_UpdateRect"

external update_rects : rect list -> surface -> unit
    = "ml_SDL_UpdateRects"

external flip : surface -> unit
    = "ml_SDL_Flip"

external set_gamma : r:float -> g:float -> b:float -> unit
    = "ml_SDL_SetGamma"

external map_RGB : surface -> ?alpha:int -> color -> int32
    = "ml_SDL_MapRGB"

external get_RGB : surface -> int32 -> color
    = "ml_SDL_GetRGB"

external get_RGBA : surface -> int32 -> color * int
    = "ml_SDL_GetRGBA"

external create_RGB_surface : 
  [ `SWSURFACE | `HWSURFACE | `ASYNCBLIT | `SRCCOLORKEY | `SRCALPHA ] list ->
  w:int -> h:int -> bpp:int -> 
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
    = "ml_SDL_CreateRGBSurface_bc" "ml_SDL_CreateRGBSurface"

val create_RGB_surface_from_32 : 
  (int32, int32_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
val create_RGB_surface_from_24 : 
  (int, int8_unsigned_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
val create_RGB_surface_from_16 : 
  (int, int16_unsigned_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
val create_RGB_surface_from_8 : 
  (int, int8_unsigned_elt, c_layout) Array1.t ->
  w:int -> h:int -> pitch:int ->
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface

external free_surface : surface -> unit
    = "ml_SDL_FreeSurface"

external must_lock : surface -> bool
    = "ml_SDL_MustLock" "noalloc"
external lock : surface -> unit
    = "ml_SDL_LockSurface"
external unlock : surface -> unit
    = "ml_SDL_UnlockSurface" "noalloc"

external load_BMP : string -> surface
    = "ml_SDL_LoadBMP"
external save_BMP : string -> surface -> unit
    = "ml_SDL_SaveBMP"


external unset_color_key : surface -> unit
    = "ml_SDL_unset_color_key"
external set_color_key : surface -> ?rle:bool -> int32 -> unit
    = "ml_SDL_SetColorKey"
external get_color_key : surface -> int32 -> unit
    = "ml_SDL_get_color_key"

external unset_alpha : surface -> unit
    = "ml_SDL_unset_alpha"
external set_alpha : surface -> ?rle:bool -> int -> unit
    = "ml_SDL_SetAlpha"
external get_alpha : surface -> int
    = "ml_SDL_get_alpha"

external unset_clip_rect : surface -> unit
    = "ml_SDL_UnsetClipRect"
external set_clip_rect : surface -> rect -> unit
    = "ml_SDL_SetClipRect"
external get_clip_rect : surface -> rect
    = "ml_SDL_GetClipRect"

external blit_surface : 
  src:surface -> ?src_rect:rect -> 
  dst:surface -> ?dst_rect:rect -> unit -> unit
  = "ml_SDL_BlitSurface"

external fill_rect : ?rect:rect -> surface -> int32 -> unit
    = "ml_SDL_FillRect"

external display_format : ?alpha:bool -> surface -> surface
    = "ml_SDL_DisplayFormat"

open Bigarray

val pixel_data : surface -> (int, int8_unsigned_elt, c_layout) Array1.t

val pixel_data_8 : surface -> (int, int8_unsigned_elt, c_layout) Array1.t

val pixel_data_16 : surface -> (int, int16_unsigned_elt, c_layout) Array1.t

val pixel_data_24 : surface -> (int, int8_unsigned_elt, c_layout) Array1.t

val pixel_data_32 : surface -> (int32, int32_elt, c_layout) Array1.t
