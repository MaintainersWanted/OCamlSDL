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

(* $Id: sdlevent.ml,v 1.2 2000/01/14 00:51:32 fbrunel Exp $ *)

(* Define a new exception for event errors and register 
   it to be callable from C code. *)

exception SDLevent_exception of string
let _ = Callback.register_exception "SDLevent_exception" (SDLevent_exception "Any string")

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

type keyboard_event_func = key -> key_state -> int -> int -> unit
type mouse_event_func = button -> button_state -> int -> int -> unit
type mousemotion_event_func = int -> int -> unit
type idle_event_func = unit -> unit

(* Native C external functions *)

external set_keyboard_event_func : keyboard_event_func -> unit = "sdlevent_set_keyboard_event_func";;
external set_mouse_event_func : mouse_event_func -> unit = "sdlevent_set_mouse_event_func";;
external set_mousemotion_event_func : mousemotion_event_func -> unit = "sdlevent_set_mousemotion_event_func";;
external set_idle_event_func : idle_event_func -> unit = "sdlevent_set_idle_event_func";;

external is_key_pressed : key -> bool = "sdlevent_is_key_pressed";;
external is_button_pressed : button -> bool = "sdlevent_is_button_pressed";;
external get_mouse_position : unit -> int * int = "sdlevent_get_mouse_position";;
external set_mouse_position : int -> int -> unit = "sdlevent_set_mouse_position";;

external start_event_loop : unit -> unit = "sdlevent_start_event_loop";;
external exit_event_loop : unit -> unit = "sdlevent_exit_event_loop";;
