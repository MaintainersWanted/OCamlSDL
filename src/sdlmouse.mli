(** Mouse event handling and cursors *)

(** {3 Mouse state} *)

type button = 
  | BUTTON_LEFT
  | BUTTON_MIDDLE
  | BUTTON_RIGHT
  | BUTTON_WHEELUP
  | BUTTON_WHEELDOWN

external get_state : ?relative:bool -> unit -> int * int * button list
    = "mlsdlevent_get_mouse_state"
(** Retrieve the current state of the mouse : 
   current mouse position and list of pressed buttons 
 @param relative if true returns mouse delta instead of position *)

external warp : int -> int -> unit
    = "ml_SDL_WarpMouse"
(** Set the position of the mouse cursor (generates a mouse motion event) *)


(** {3 Cursors } *)

open Bigarray

type cursor
(** abstract type for cursors *)

type cursor_data = {
   data  : (int, int8_unsigned_elt, c_layout) Array2.t ;
   (** B/W cursor data *)
   mask  : (int, int8_unsigned_elt, c_layout) Array2.t ;
   (** B/W cursor mask *)
   w     : int ; (** width in pixels *)
   h     : int ; (** height in pixels *)
   hot_x : int ; (** the "tip" of the cursor *)
   hot_y : int ; (** the "tip" of the cursor *)
  } 

external make_cursor : 
  data:(int, int8_unsigned_elt, c_layout) Array2.t ->
  mask:(int, int8_unsigned_elt, c_layout) Array2.t ->
  hot_x:int -> hot_y:int -> cursor
    = "ml_SDL_CreateCursor"
(** Create a cursor using the specified data and mask (in MSB format).

   The cursor is created in black and white according to the following:
   {v data  mask     resulting pixel on screen
    0     1       White
    1     1       Black
    0     0       Transparent
    1     0       Inverted color if possible, black if not. v}
  
   Cursors created with this function must be freed 
   with {!Sdlmouse.free_cursor}.
*)

external free_cursor : cursor -> unit
    = "ml_SDL_FreeCursor"
(** Deallocates a cursor. *)

external set_cursor : cursor -> unit
    = "ml_SDL_SetCursor"
(** Set the currently active cursor to the specified one.
   If the cursor is currently visible, the change will be immediately 
   represented on the display. *)

external get_cursor : unit -> cursor
    = "ml_SDL_GetCursor"
(** Returns the currently active cursor. *)

external cursor_visible : unit -> bool
    = "ml_SDL_ShowCursor_query"
(** Tests if cursor is shown on screen *)

external show_cursor : bool -> unit
    = "ml_SDL_ShowCursor"
(** Toggle cursor display *)

external cursor_data : cursor -> cursor_data
    = "ml_SDL_Cursor_data"
(** converts an abstract cursor value to concrete cursor data *)

val pprint_cursor : cursor -> unit
(** for debugging : prints on stdout *)

val convert_to_cursor : 
  data:int array -> mask:int array ->
  w:int -> h:int -> hot_x:int -> hot_y:int -> cursor
