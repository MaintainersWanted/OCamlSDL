
(** Image loader module *)

exception SDLloader_exception of string
    (** Exception to report errors *)

val load_image : string -> Sdlvideo.surface
    (** load an image as a surface *)

val load_image_from_mem : string -> Sdlvideo.surface 

val read_XPM_from_array : string array -> Sdlvideo.surface
    (** creates a surface from an array of strings 
       (in the source code) *)
