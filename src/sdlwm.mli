
(** Window Manager interaction *)


external set_caption : title:string -> icon:string -> unit
    = "ml_SDL_WM_SetCaption"
(** Sets the title and icon text of the display window *)
external get_caption : unit -> string * string
    = "ml_SDL_WM_GetCaption"
(** Gets the title and icon text of the display window *)


external set_icon : Sdlvideo.surface -> unit
    = "ml_SDL_WM_SetIcon"
(** Sets the icon for the display window. 
   This function must be called before the first call to 
   {!Sdlvideo.set_video_mode}. *)

external iconify : unit -> bool
    = "ml_SDL_WM_IconifyWindow"
(** This function iconifies the window, and returns [true] if it
   succeeded.  If the function succeeds, it generates an
   {!Sdlevent.active_event} loss event.  This function is a noop and
   returns [false] in non-windowed environments. *)

external toggle_fullscreen : unit -> bool
    = "ml_SDL_WM_ToggleFullScreen"
(** Toggle fullscreen mode without changing the contents of the
  screen.  If this function was able to toggle fullscreen mode (change
  from running in a window to fullscreen, or vice-versa), it will
  return [true].  If it is not implemented, or fails, it returns
  [false].  *)


external grab_input : bool -> unit
  = "ml_SDL_WM_GrabInput" 
(** Set the input grab state of the application.  Grabbing means that
   the mouse is confined to the application window, and nearly all
   keyboard input is passed directly to the application, and not
   interpreted by a window manager, if any.  *)

external query_grab : unit -> bool
  = "ml_SDL_WM_GetGrabInput"
