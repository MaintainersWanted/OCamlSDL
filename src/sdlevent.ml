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

(* $Id: sdlevent.ml,v 1.12 2004/07/26 00:28:49 oliv__a Exp $ *)

exception Event_exn of string
let _ = 
  Callback.register_exception "sdlevent_exn" (Event_exn "")

type active_state = 
  | MOUSEFOCUS
  | INPUTFOCUS
  | APPACTIVE

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
    keysym   : Sdlkey.t ;
    keymod   : Sdlkey.mod_state ;
    keycode  : char ;
  }

type mousemotion_event = {
    mme_which  : int ;
    mme_state  : Sdlmouse.button list ;
    mme_x    : int ;
    mme_y    : int ;
    mme_xrel : int ;
    mme_yrel : int ;
  } 

type mousebutton_event = {
    mbe_which  : int ;
    mbe_button : Sdlmouse.button ;
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

type joybutton_event = {
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
  | JOYBUTTONDOWN   of joybutton_event
  | JOYBUTTONUP     of joybutton_event
  | QUIT
  | SYSWM
  | VIDEORESIZE     of int * int
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
let all_events_mask      = 0x7FFFFFFF

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

external get_enabled_events : unit -> event_mask = "mlsdlevent_get_enabled"

let of_mask mask = 
  List.fold_left
    (fun acc (evt_t, m) ->
      if mask land m <> 0
      then evt_t :: acc 
      else acc )
    [] [ ( ACTIVE_EVENT, active_mask ) ;
	 ( KEYDOWN_EVENT, keydown_mask ) ;
	 ( KEYUP_EVENT, keyup_mask ) ;
	 ( MOUSEMOTION_EVENT, mousemotion_mask ) ;
	 ( MOUSEBUTTONDOWN_EVENT, mousebuttondown_mask ) ;
	 ( MOUSEBUTTONUP_EVENT, mousebuttonup_mask ) ;
	 ( JOYAXISMOTION_EVENT, joyaxismotion_mask ) ;
	 ( JOYBALL_EVENT, joyballmotion_mask ) ;
	 ( JOYHAT_EVENT, joyhatmotion_mask ) ;
	 ( JOYBUTTONDOWN_EVENT, joybuttondown_mask ) ;
	 ( JOYBUTTONUP_EVENT, joybuttonup_mask ) ;
	 ( QUIT_EVENT, quit_mask ) ;
	 ( SYSWM_EVENT, syswmevent_mask ) ;
	 ( RESIZE_EVENT, videoresize_mask ) ;
	 ( EXPOSE_EVENT, videoexpose_mask ) ;
	 ( USER_EVENT, userevent_mask ) ; ]


let link_me = 
  (* I need Sdlkey so that keysyms lookup tables are 
     initialised and registered *)
  Sdlkey.link_me

module Old = 
  struct

  type keyboard_event_func =
      Sdlkey.t -> switch_state -> int -> int -> unit
  type mouse_event_func =
      Sdlmouse.button -> switch_state -> int -> int -> unit
  type mousemotion_event_func = int -> int -> unit
  type idle_event_func = unit -> unit
  type resize_event_func = int -> int -> unit

  let keyboard_event_func = ref (fun _ _ _ _ -> ())
  let mouse_event_func = ref (fun _ _ _ _ -> ())
  let mousemotion_event_func = ref (fun _ _ -> ())
  let idle_event_func = ref ignore
  let resize_event_func = ref (fun _ _ -> ())

  let set_keyboard_event_func f = keyboard_event_func := f
  let set_mouse_event_func f = mouse_event_func := f
  let set_mousemotion_event_func f = mousemotion_event_func := f
  let set_idle_event_func f = idle_event_func := f
  let set_resize_event_func f = resize_event_func := f

  exception Quit

  let in_loop = ref false

  let exit_event_loop () = if !in_loop then raise Quit

  let start_event_loop () =
    let do_loop () =
      match poll () with
      | Some (KEYDOWN ev | KEYUP ev) ->
	  let x,y,_ = Sdlmouse.get_state () in
	  !keyboard_event_func ev.keysym ev.ke_state x y
      | Some (MOUSEBUTTONDOWN ev | MOUSEBUTTONUP ev) ->
	  let b = ev.mbe_button in
	  let x = ev.mbe_x in
	  let y = ev.mbe_y in
	  let st = ev.mbe_state in
	  !mouse_event_func b st x y
      | Some (MOUSEMOTION ev) ->
	  let x = ev.mme_x in
	  let y = ev.mme_y in
	  !mousemotion_event_func x y
      | Some (VIDEORESIZE (x,y)) -> !resize_event_func x y
      | None -> !idle_event_func ()
      | _ -> () in
    disable_events all_events_mask ;
    enable_events 
      (make_mask 
	 [ KEYDOWN_EVENT ; KEYUP_EVENT ;
	   MOUSEMOTION_EVENT ; MOUSEBUTTONUP_EVENT ;
	   MOUSEBUTTONDOWN_EVENT ; RESIZE_EVENT ; ]) ;
    try in_loop := true; while true do do_loop () done
    with Quit -> in_loop := false
end
