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

(* $Id: sdlevent.mli,v 1.1 2000/01/12 00:56:34 fbrunel Exp $ *)

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

type keyboard_event_func = key -> key_state -> int -> int -> unit
type mouse_event_func = button -> button_state -> int -> int -> unit
type mousemotion_event_func = int -> int -> unit
type idle_event_func = unit -> unit

(* Operations *)

val set_keyboard_event_func : keyboard_event_func -> unit
val set_mouse_event_func : mouse_event_func -> unit
val set_mousemotion_event_func : mousemotion_event_func -> unit
val set_idle_event_func : idle_event_func -> unit

val start_event_loop : unit -> unit
val exit_event_loop : unit -> unit
