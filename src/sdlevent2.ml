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

(* $Id: sdlevent2.ml,v 1.1 2002/08/26 12:28:34 oliv__a Exp $ *)


exception Event_exn of string
let _ = 
  Callback.register_exception "sdlevent_exn" (Event_exn "")

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
    jhe_value : Sdljoystick.hat_value ;
  } 

type joybuton_event = {
    jbe_which  : int ;
    jbe_button : int ;
    jbe_state  : switch_state ;
  } 

type resize_event = {
    re_w : int ;
    re_h : int ;
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
  | VIDEORESIZE     of resize_event
  | VIDEOEXPOSE
  | USER            of int

let string_of_event = function
  | ACTIVE _        -> "active"
  | KEYDOWN _       -> "key down"
  | KEYUP _         -> "key up"
  | MOUSEMOTION _   -> "mouse motion"
  | MOUSEBUTTONDOWN _ -> "mouse button down"
  | MOUSEBUTTONUP _ -> "mouse button up"
  | JOYAXISMOTION _ -> "joystick axis motion"
  | JOYBALLMOTION _ -> "joystick ball motion"
  | JOYHATMOTION _  -> "joystick hat motion"
  | JOYBUTTONDOWN _ -> "joystick button down"
  | JOYBUTTONUP _   -> "joystick button up"
  | QUIT            -> "quit"
  | SYSWM           -> "syswm"
  | VIDEORESIZE _   -> "resize"
  | VIDEOEXPOSE     -> "expose"
  | USER c          -> "user " ^ (string_of_int c)

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

let active_mask          = 0x02
let keydown_mask         = 0x04
let keyup_mask           = 0x08
let mousemotion_mask     = 0x10
let mousebuttondown_mask = 0x20
let mousebuttonup_mask   = 0x40
let joyaxismotion_mask   = 0x80
let joyballmotion_mask   = 0x100
let joyhatmotion_mask    = 0x200
let joybuttondown_mask   = 0x400
let joybuttonup_mask     = 0x800
let quit_mask            = 0x1000
let syswmevent_mask      = 0x2000
let videoresize_mask     = 0x10000
let videoexpose_mask     = 0x20000
let userevent_mask       = 0x1000000

let keyboard_event_mask  = 0x0C
let mouse_event_mask     = 0x70
let joystick_event_mask  = 0xF80
let all_events_mask      = 0xFFFFFFFF

let make_mask = 
  List.fold_left
    (fun acc evt ->
      acc lor 
      ( match evt with
      | ACTIVE_EVENT -> active_mask
      | KEYDOWN_EVENT -> keydown_mask
      | KEYUP_EVENT -> keyup_mask
      | MOUSEMOTION_EVENT -> mousemotion_mask
      | MOUSEBUTTONDOWN_EVENT -> mousebuttondown_mask
      | MOUSEBUTTONUP_EVENT -> mousebuttonup_mask
      | JOYAXISMOTION_EVENT -> joyaxismotion_mask
      | JOYBALL_EVENT -> joyballmotion_mask
      | JOYHAT_EVENT -> joyhatmotion_mask
      | JOYBUTTONDOWN_EVENT -> joybuttondown_mask
      | JOYBUTTONUP_EVENT -> joybuttonup_mask
      | QUIT_EVENT -> quit_mask
      | SYSWM_EVENT -> syswmevent_mask
      | RESIZE_EVENT -> videoresize_mask
      | EXPOSE_EVENT -> videoexpose_mask
      | USER_EVENT-> userevent_mask ) )
    0x00

external pump : unit -> unit = "ml_SDL_PumpEvents"

external peek : ?mask:event_mask -> int -> event list = "mlsdlevent_peek"
external get  : ?mask:event_mask -> int -> event list = "mlsdlevent_get"

external add  : event list -> unit = "mlsdlevent_add"

external has_event : unit -> bool = "mlsdlevent_has_event"
external poll : unit -> event option = "mlsdlevent_poll"

external wait       : unit -> unit = "mlsdlevent_wait"
external wait_event : unit -> event = "mlsdlevent_wait_event"

let rec wait_delay ?mask delay =
  match pump () ; get ?mask 1 with
  | [] -> Sdltimer.delay delay ; wait_delay ?mask delay
  | evt :: _ -> evt

(* SDL_PushEvent ? *)

(* SDL_SetEventFilter *)
(* SDL_GetEventFilter *)

external get_state : event_kind -> bool = "mlsdlevent_get_state"
external set_state : bool -> event_kind -> unit = "mlsdlevent_set_state"

external set_state_by_mask : event_mask -> bool -> unit
    = "mlsdlevent_set_state_by_mask"

let enable_events mask =
  set_state_by_mask mask true

let disable_events mask =
  set_state_by_mask mask false

let link_me = 
  (* I need Sdlkey so that keysyms lookup tables are 
     initialised and registered *)
  Sdlkey.link_me
