
open Bigarray

exception Video_exn of string
let _ = 
  Callback.register_exception "SDLvideo2_exception" (Video_exn "")

type color = int * int * int 
  (** (r, g, b) *)
      
type rect = {
    mutable r_x : int ;
    mutable r_y : int ;
    mutable r_w : int ;
    mutable r_h : int ;
  }
  (** (x, y, w, h) *)

let rect ~x ~y ~w ~h =
  { r_x = x ; r_y = y ; r_w = w ; r_h = h }
let copy_rect r =
  { r with r_x = r.r_x }

type pixel_format
type pixel_format_info = {
    palette  : bool ;
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

type video_flag = [
  | `SWSURFACE   (* Surface is in system memory *)
  | `HWSURFACE   (* Surface is in video memory *)
  | `ASYNCBLIT   (* Enables the use of asynchronous to the display surface *)
  | `ANYFORMAT   (* Allow any video pixel format *)
  | `HWPALETTE   (* Give SDL exclusive palette access *)
  | `DOUBLEBUF   (* Set up double-buffered video mode *)
  | `FULLSCREEN  (* Surface is a full screen display *)
  | `OPENGL      (* OpenGL rendering *)
  | `OPENGLBLIT  
  | `RESIZABLE   (* Create a resizable window *)
  | `NOFRAME     (* Frame without titlebar *)
] 

external pixel_format_info : pixel_format -> pixel_format_info
    = "ml_pixelformat_info"

external get_video_info : unit -> video_info
    = "ml_SDL_GetVideoInfo"

external driver_name : unit -> string
    = "ml_SDL_VideoDriverName"

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
  | `PREALLOC ] 

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

let surface_dims s =
  let { w = w; h = h; pitch = pitch } =
    surface_info s in
  (w, h, pitch)

let surface_format s = 
  pixel_format_info (surface_info s).fmt

let surface_flags s =
  (surface_info s).flags

let surface_bpps s = 
  (surface_format s).bits_pp

external use_palette : surface -> bool
    = "ml_sdl_surface_use_palette"
external palette_ncolors     : surface -> int = "ml_sdl_palette_ncolors"
external get_palette_color   : surface -> int -> color = "ml_sdl_palette_get_color"
type palette_flag =
  | LOGPAL
  | PHYSPAL
  | LOGPHYSPAL
external set_palette : surface -> ?flag:palette_flag -> ?firstcolor:int -> color array -> unit
    = "ml_SDL_SetPalette"


external set_video_mode : w:int -> h:int -> bpp:int -> video_flag list -> surface
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

external _create_RGB_surface_from : 
  ('a, 'b, c_layout) Array1.t ->
  w:int -> h:int -> bpp:int -> pitch:int ->
  rmask:int32 -> gmask:int32 -> bmask:int32 -> amask:int32 -> surface
    = "ml_SDL_CreateRGBSurfaceFrom_bc" "ml_SDL_CreateRGBSurfaceFrom"

let create_RGB_surface_from_32  =
  _create_RGB_surface_from ~bpp:32
let create_RGB_surface_from_24 a ~w ~h ~pitch ~rmask ~gmask ~bmask ~amask =
  _create_RGB_surface_from a ~w ~h ~pitch ~bpp:24 
    ~rmask:(Int32.of_int rmask) ~gmask:(Int32.of_int gmask)
    ~bmask:(Int32.of_int bmask) ~amask:(Int32.of_int amask)
let create_RGB_surface_from_16  a ~w ~h ~pitch ~rmask ~gmask ~bmask ~amask =
  _create_RGB_surface_from a ~w ~h ~pitch ~bpp:16
    ~rmask:(Int32.of_int rmask) ~gmask:(Int32.of_int gmask)
    ~bmask:(Int32.of_int bmask) ~amask:(Int32.of_int amask)
let create_RGB_surface_from_8  a ~w ~h ~pitch ~rmask ~gmask ~bmask ~amask =
  _create_RGB_surface_from a ~w ~h ~pitch ~bpp:8
    ~rmask:(Int32.of_int rmask) ~gmask:(Int32.of_int gmask)
    ~bmask:(Int32.of_int bmask) ~amask:(Int32.of_int amask)

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

external fill_rect : ?rect:rect -> surface ->  int32 -> unit
    = "ml_SDL_FillRect"

external display_format : ?alpha:bool -> surface -> surface
    = "ml_SDL_DisplayFormat"


external _pixel_data : surface -> int -> ('a, 'b, c_layout) Array1.t
    = "ml_bigarray_pixels"

let pixel_data s =
  (_pixel_data s 0 : (int, int8_unsigned_elt, c_layout) Array1.t)

let pixel_data_8 s =
  (_pixel_data s 1 : (int, int8_unsigned_elt, c_layout) Array1.t)

let pixel_data_16 s =
  (_pixel_data s 2 : (int, int16_unsigned_elt, c_layout) Array1.t)

let pixel_data_24 s =
  (_pixel_data s 3 : (int, int8_unsigned_elt, c_layout) Array1.t)

let pixel_data_32 s =
  (_pixel_data s 4 : (int32, int32_elt, c_layout) Array1.t)
