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

(* $Id: sdlevent.mli,v 1.3 2000/01/14 00:52:58 fbrunel Exp $ *)

(* Exception *)

exception SDLevent_exception of string

(* Types *)

type key = int

type key_state = 
    KEY_PRESSED
  | KEY_RELEASED

type button =
    BUTTON_LEFT
  | BUTTON_MIDDLE
  | BUTTON_RIGHT

type button_state =
    BUTTON_PRESSED 
  | BUTTON_RELEASED

(* Definition of the event callbacks *)

(* Keyboard event called with the activated key, its state and the 
   coordinates of the mouse pointer *)
type keyboard_event_func = key -> key_state -> int -> int -> unit

(* Mouse button event called with the activated button, its state and 
   the coordinates of the mouse pointer *)
type mouse_event_func = button -> button_state -> int -> int -> unit

(* Mouse motion event called with the coordinates of the mouse pointer *)
type mousemotion_event_func = int -> int -> unit

type idle_event_func = unit -> unit

(* Functions for setting the current event callbacks *)

val set_keyboard_event_func : keyboard_event_func -> unit
val set_mouse_event_func : mouse_event_func -> unit
val set_mousemotion_event_func : mousemotion_event_func -> unit
val set_idle_event_func : idle_event_func -> unit

(* Asynchronous functions for getting status of input devices *)

val is_key_pressed : key -> bool
val is_button_pressed : button -> bool
val get_mouse_position : unit -> int * int

(* Misc *)

(* Set the new position of the mouse cursor and generate a mouse motion
   event *)
val set_mouse_position : int -> int -> unit

(* Event loop *)

val start_event_loop : unit -> unit
val exit_event_loop : unit -> unit
