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

(* $Id: sdlevent.mli,v 1.12 2003/01/04 01:37:08 oliv__a Exp $ *)

(** SDL event handling *)

exception Event_exn of string
(** The exception used for reporting events-related errors. *)

(** {1 Application focus} *)

(** The available application states *)
type active_state = 
  | MOUSEFOCUS  (** The app has mouse coverage *)
  | INPUTFOCUS  (** The app has input focus *)
  | ACTIVE      (** The application is active *)

(** This function returns the current state of the application. If
   ACTIVE is set, then the user is able to see your application,
   otherwise it has been iconified or disabled. *)
external get_app_state : unit -> active_state list =
   "mlsdlevent_get_app_state"

(** {1 Events datatypes} *)

(** Application visibility event record *)
type active_event = {
    gain     : bool ; (** Whether given states were gained or lost *)
    ae_state : active_state list ; (** A list of the focus states *)
  } 

type switch_state = 
  | RELEASED
  | PRESSED

(** Keyboard event record *)
type keyboard_event = {
    ke_which : int ;              (** The keyboard device index *)
    ke_state : switch_state ;     (** PRESSED or RELEASED *)
    keysym   : Sdlkey.t ;         (** SDL virtual keysym *)
    keymod   : Sdlkey.mod_state ; (** current key modifiers *)
    keycode  : char ;             (** translated character *)
  }

(** Mouse motion event record *)
type mousemotion_event = {
    mme_which  : int ;            (** The mouse device index *)
    mme_state  : Sdlmouse.button list ; (** The current button state *)
    mme_x    : int ;              (** The X/Y coordinates of the mouse *)
    mme_y    : int ;
    mme_xrel : int ;              (** The relative motion in the X direction *)
    mme_yrel : int ;              (** The relative motion in the Y direction *)
  } 

(** Mouse button event record *)
type mousebutton_event = {
    mbe_which  : int ;            (** The mouse device index *)
    mbe_button : Sdlmouse.button ; (** The mouse button index *)
    mbe_state  : switch_state ;   (** PRESSED or RELEASED *)
    mbe_x : int ;                 (** The X/Y coordinates of the mouse at press time *)
    mbe_y : int ;
  } 

(** Joystick axis motion event record *)
type joyaxis_event = {
    jae_which : int ;             (** The joystick device index *)
    jae_axis  : int ;             (** The joystick axis index *)
    jae_value : int ;             (** The axis value (range: -32768 to 32767) *)
  } 

(** Joystick axis motion event record *)
type joyball_event = {
    jle_which : int ;             (** The joystick device index *)
    jle_ball  : int ;             (** The joystick trackball index *)
    jle_xrel  : int ;             (** The relative motion in the X direction *)
    jle_yrel  : int ;             (** The relative motion in the Y direction *)
  } 

(** Joystick hat position change event record *)
type joyhat_event = {
    jhe_which : int ;             (** The joystick device index *)
    jhe_hat   : int ;             (** The joystick hat index *)
    jhe_value : int ;             (**  The hat position value: {v
                          8   1   2
                          7   0   3
                          6   5   4 v}
                                       Note that zero means the POV is centered. *)
  } 

(** Joystick button event record *)
type joybutton_event = {
    jbe_which  : int ;            (** The joystick device index *)
    jbe_button : int ;            (** The joystick button index *)
    jbe_state  : switch_state ;   (** PRESSED or RELEASED *)
  } 

(** The main event type *)
type event = 
  | ACTIVE          of active_event      (** Application loses/gains visibility *)
  | KEYDOWN         of keyboard_event    (** Keys pressed *)
  | KEYUP           of keyboard_event    (** Keys released *)
  | MOUSEMOTION     of mousemotion_event (** Mouse moved *)
  | MOUSEBUTTONDOWN of mousebutton_event (** Mouse button pressed *)
  | MOUSEBUTTONUP   of mousebutton_event (** Mouse button released *)
  | JOYAXISMOTION   of joyaxis_event     (** Joystick axis motion *)
  | JOYBALLMOTION   of joyball_event     (** Joystick trackball motion *)
  | JOYHATMOTION    of joyhat_event      (** Joystick hat position change *)
  | JOYBUTTONDOWN   of joybutton_event   (** Joystick button pressed *)
  | JOYBUTTONUP     of joybutton_event   (** Joystick button released *)
  | QUIT                                 (** User-requested quit *)
  | SYSWM                                (** System specific event *)
  | VIDEORESIZE     of int * int         (** User resized video mode *)
  | VIDEOEXPOSE                          (** Screen needs to be redrawn *)
  | USER            of int               (** for your use ! *)

val string_of_event : event -> string
(** Returns a short string descriptive of the event type, for debugging *)

(** {1 Event masks } *)

type event_mask = int

(** Event masks values are ints and should be manipulated with [lor],
   [land], etc. *)

val active_mask          : event_mask
val keydown_mask         : event_mask
val keyup_mask           : event_mask
val mousemotion_mask     : event_mask
val mousebuttondown_mask : event_mask
val mousebuttonup_mask   : event_mask
val joyaxismotion_mask   : event_mask
val joyballmotion_mask   : event_mask
val joyhatmotion_mask    : event_mask
val joybuttondown_mask   : event_mask
val joybuttonup_mask     : event_mask
val quit_mask            : event_mask
val syswmevent_mask      : event_mask
val videoresize_mask     : event_mask
val videoexpose_mask     : event_mask
val userevent_mask       : event_mask

val keyboard_event_mask  : event_mask
val mouse_event_mask     : event_mask
val joystick_event_mask  : event_mask
val all_events_mask      : event_mask

type event_kind =
  | ACTIVE_EVENT 
  | KEYDOWN_EVENT 
  | KEYUP_EVENT 
  | MOUSEMOTION_EVENT 
  | MOUSEBUTTONDOWN_EVENT 
  | MOUSEBUTTONUP_EVENT 
  | JOYAXISMOTION_EVENT 
  | JOYBALL_EVENT 
  | JOYHAT_EVENT 
  | JOYBUTTONDOWN_EVENT 
  | JOYBUTTONUP_EVENT 
  | QUIT_EVENT 
  | SYSWM_EVENT 
  | RESIZE_EVENT 
  | EXPOSE_EVENT 
  | USER_EVENT

val make_mask : event_kind list -> event_mask
val of_mask   : event_mask -> event_kind list

(** {1 Enabling/Disabling event collecting} *)

val enable_events  : event_mask -> unit
(** Specified events are collected and added to the event queue (when
   [pump] is called). *)

val disable_events : event_mask -> unit
(** Specified events are not collected and won't appear in the event queue. *)

external get_enabled_events : unit -> event_mask = "mlsdlevent_get_enabled"
(** The mask of currently reported events. *)

external get_state : event_kind -> bool = "mlsdlevent_get_state"
(** Query the reporting state of an event type. *)

external set_state : bool -> event_kind -> unit = "mlsdlevent_set_state"
(** Set the reporting state of one individual event type. *)


(** {1 Handling events} *)

val pump : unit -> unit
(** Pumps the event loop, gathering events from the input devices.
   This function updates the event queue and internal input device
   state.  This should only be run in the thread that sets the video
   mode. *)

val wait_event : unit -> event
(** Wait indefinitely for the next available event and return it. *)

external wait : unit -> unit = "mlsdlevent_wait"
(** Wait indefinitely for the next available event but leave it in the
   queue. *)

val poll : unit -> event option
(** Poll for currently pending events and return one if available. *)

external has_event : unit -> bool = "mlsdlevent_has_event"
(** Poll for currently pending events and return [false] if the queue is empty. *)

external peek : ?mask:event_mask -> int -> event list = "mlsdlevent_peek"
(** Checks the event queue for messages : up to 'numevents' events at
   the front of the event queue, matching 'mask', will be returned and
   will not be removed from the queue. *)

external get  : ?mask:event_mask -> int -> event list = "mlsdlevent_get"
(** Checks the event queue for messages : up to 'numevents' events at
   the front of the event queue, matching 'mask', will be returned and
   will be removed from the queue. *)

external add : event list -> unit = "mlsdlevent_add"
(** Add events to the back of the event queue. *)

(** {1 Old event-handling interface } *)

(** Callback-based event handling.
   @deprecated this interface was used in version of ocamlsdl < 0.6
 *)
module Old : 
  sig

  (** {2 Definition of the event callbacks} *)

  (** Keyboard event called with the activated key, its state and the
   coordinates of the mouse pointer *)
  type keyboard_event_func =
    Sdlkey.t -> switch_state -> int -> int -> unit

  (** Mouse button event called with the activated button, its state
   and the coordinates of the mouse pointer *)
  type mouse_event_func =
    Sdlmouse.button -> switch_state -> int -> int -> unit

  (** Mouse motion event called with the coordinates of the mouse
  pointer *)
  type mousemotion_event_func = int -> int -> unit

  type idle_event_func = unit -> unit

  type resize_event_func = int -> int -> unit

  (** {2 Functions for setting the current event callbacks} *)

  val set_keyboard_event_func : keyboard_event_func -> unit
  val set_mouse_event_func : mouse_event_func -> unit
  val set_mousemotion_event_func : mousemotion_event_func -> unit
  val set_idle_event_func : idle_event_func -> unit
  val set_resize_event_func : resize_event_func -> unit

  (** {2 Event loop} *)

  val start_event_loop : unit -> unit
  val exit_event_loop : unit -> unit
end

(**/**)
val link_me : unit
