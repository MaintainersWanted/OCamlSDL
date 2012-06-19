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

(* $Id: sdljoystick.mli,v 1.4 2012/06/19 18:20:59 oliv__a Exp $ *)

(** Module for SDL joystick event handling *)

(** In order to use these functions, {! Sdl.init} must have been called
   with the `JOYSTICK flag.  This causes SDL to scan the system
   for joysticks, and load appropriate drivers.
*)

exception SDLjoystick_exception of string
(** exception for error reporting *)

(** The joystick abstract type used to identify an SDL joystick *)
type t

(** Count the number of joysticks attached to the system *)
val num_joysticks : unit -> int

(** Get the implementation dependent name of a joystick.
   This can be called before any joysticks are opened. *)
val name : int -> string

(** Open a joystick for use - the index passed as an argument refers to
   the N'th joystick on the system.  This index is the value which will
   identify this joystick in future joystick events. 
   @raise SDLjoystick_exception if an error occurred *)
val open_joystick : int -> t

(** @return [true] if joystick has been opened *)
val opened : int -> bool

(** Get the device index of an opened joystick *)
val index : t -> int

(** Get the number of general axis controls on a joystick *)
val num_axes : t -> int

(** Get the number of trackballs on a joystick
   Joystick trackballs have only relative motion events associated
   with them and their state cannot be polled. *)
val num_balls : t -> int

(** Get the number of POV hats on a joystick *)
val num_hats : t -> int

(** Get the number of buttons on a joystick *)
val num_buttons : t -> int

(** {3 Joystick state } *)

(** Update the current state of the open joysticks.
   This is called automatically by the event loop if any joystick
   events are enabled. *)
val update : t -> unit


(** Enable/disable joystick event polling.
   If joystick events are disabled, you must call {! Sdljoystick.update}
   yourself and check the state of the joystick when you want joystick
   information. *)

val set_event_state : bool -> unit
val get_event_state : unit -> bool

type hat_value = int

val hat_centered  : hat_value
val hat_up        : hat_value
val hat_right     : hat_value
val hat_down      : hat_value
val hat_left      : hat_value
val hat_rightup   : hat_value
val hat_rightdown : hat_value
val hat_leftup    : hat_value
val hat_leftdown  : hat_value

val get_axis : t -> int -> int
   
val get_hat  : t -> int -> hat_value
   
val get_ball : t -> int -> int * int
   
val get_button : t -> int -> bool
   

(** Close a joystick previously opened with {! Sdljoystick.open_joystick} *)
val close : t -> unit
