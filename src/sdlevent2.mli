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

(* $Id: sdlevent2.mli,v 1.3 2002/09/04 16:36:56 oliv__a Exp $ *)


exception Event_exn of string

type active_state = 
  | MOUSEFOCUS
  | INPUTFOCUS
  | ACTIVE

external get_app_state : unit -> active_state list
    = "mlsdlevent_get_app_state"

type active_event = {
    gain     : bool ;
    ae_state : active_state list ;
  } 

type switch_state = 
  | RELEASED
  | PRESSED

type keyboard_event = {
    ke_which : int ;
    ke_state : switch_state ;
    keysym   : Sdlkey.key ;
    keymod   : Sdlkey.mod_state ;
    keycode  : char ;
  }

type mousemotion_event = {
    mme_which  : int ;
    mme_state  : Sdlmouse.mouse_button list ;
    mme_x    : int ;
    mme_y    : int ;
    mme_xrel : int ;
    mme_yrel : int ;
  } 

type mousebutton_event = {
    mbe_which  : int ;
    mbe_button : Sdlmouse.mouse_button ;
    mbe_state  : switch_state ;
    mbe_x : int ;
    mbe_y : int ;
  } 

type joyaxis_event = {
    jae_which : int ;
    jae_axis  : int ;
    jae_value : int ;
  } 

type joyball_event = {
    jle_which : int ;
    jle_ball  : int ;
    jle_xrel  : int ;
    jle_yrel  : int ;
  } 

type joyhat_event = {
    jhe_which : int ;
    jhe_hat   : int ;
    jhe_value : int ;
  } 

type joybuton_event = {
    jbe_which  : int ;
    jbe_button : int ;
    jbe_state  : switch_state ;
  } 

type event = 
  | ACTIVE          of active_event
  | KEYDOWN         of keyboard_event
  | KEYUP           of keyboard_event
  | MOUSEMOTION     of mousemotion_event
  | MOUSEBUTTONDOWN of mousebutton_event
  | MOUSEBUTTONUP   of mousebutton_event
  | JOYAXISMOTION   of joyaxis_event
  | JOYBALLMOTION   of joyball_event
  | JOYHATMOTION    of joyhat_event
  | JOYBUTTONDOWN   of joybuton_event
  | JOYBUTTONUP     of joybuton_event
  | QUIT
  | SYSWM
  | VIDEORESIZE     of int * int
  | VIDEOEXPOSE
  | USER            of int

val string_of_event : event -> string

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

type event_mask = int

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

val make_mask : event_kind list -> event_mask

val pump : unit -> unit

external peek : ?mask:event_mask -> int -> event list = "mlsdlevent_peek"
external get  : ?mask:event_mask -> int -> event list = "mlsdlevent_get"

external add : event list -> unit = "mlsdlevent_add"

external has_event : unit -> bool = "mlsdlevent_has_event"

val poll : unit -> event option

external wait : unit -> unit = "mlsdlevent_wait"
val wait_event : unit -> event
val wait_delay : ?mask:event_mask -> int  -> event

external get_state : event_kind -> bool = "mlsdlevent_get_state"
external set_state : bool -> event_kind -> unit = "mlsdlevent_set_state"

val enable_events  : event_mask -> unit
val disable_events : event_mask -> unit

val link_me : unit
