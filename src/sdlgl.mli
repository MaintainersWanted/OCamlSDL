
(** LablGL interaction *)

external swap_buffers : unit -> unit
    = "ml_SDL_GL_SwapBuffers"

type attr =
  | RED_SIZE of int
  | GREEN_SIZE of int
  | BLUE_SIZE of int
  | ALPHA_SIZE of int
  | BUFFER_SIZE of int
  | DOUBLEBUFFER of bool
  | DEPTH_SIZE of int
  | STENCIL_SIZE of int
  | ACCUM_RED_SIZE of int
  | ACCUM_GREEN_SIZE of int
  | ACCUM_BLUE_SIZE of int
  | ACCUM_ALPHA_SIZE of int
  | STEREO of int

external set_attr : attr list -> unit
    = "ml_SDL_GL_SetAttribute"

external get_attr : unit -> attr list
    = "ml_SDL_GL_GetAttribute"

external to_raw : Sdlvideo.surface -> [`ubyte] Raw.t
    = "ml_SDL_GL_to_raw"
