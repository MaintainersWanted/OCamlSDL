
external set_caption : title:string -> icon:string -> unit
    = "ml_SDL_WM_SetCaption"
external get_caption : unit -> string * string
    = "ml_SDL_WM_GetCaption"

external set_icon : Sdlvideo.surface -> unit
    = "ml_SDL_WM_SetIcon"

external iconify : unit -> bool
    = "ml_SDL_WM_IconifyWindow"

external toggle_fullscreen : unit -> bool
    = "ml_SDL_WM_ToggleFullScreen"

external grab_input : bool -> unit
    = "ml_SDL_WM_GrabInput"
external query_grab : unit -> bool
    = "ml_SDL_WM_GetGrabInput"
