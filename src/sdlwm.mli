
(** Window Manager interaction *)


val set_caption : title:string -> icon:string -> unit  
(** Sets the title and icon text of the display window *)
val get_caption : unit -> string * string
(** Gets the title and icon text of the display window *)


val set_icon : Sdlvideo.surface -> unit
(** Sets the icon for the display window. 
   This function must be called before the first call to 
   {!Sdlvideo.set_video_mode}. *)

val iconify : unit -> bool
(** This function iconifies the window, and returns [true] if it
   succeeded.  If the function succeeds, it generates an
   {!Sdlevent.active_event} loss event.  This function is a noop and
   returns [false] in non-windowed environments. *)

val toggle_fullscreen : unit -> bool
(** Toggle fullscreen mode without changing the contents of the
  screen.  If this function was able to toggle fullscreen mode (change
  from running in a window to fullscreen, or vice-versa), it will
  return [true].  If it is not implemented, or fails, it returns
  [false].  *)


val grab_input : bool -> unit
(** Set the input grab state of the application.  Grabbing means that
   the mouse is confined to the application window, and nearly all
   keyboard input is passed directly to the application, and not
   interpreted by a window manager, if any.  *)

val query_grab : unit -> bool
 
