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

(* $Id: sdljoystick.mli,v 1.3 2003/01/05 11:23:53 oliv__a Exp $ *)

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
external num_joysticks : unit -> int = "ml_SDL_NumJoysticks"

(** Get the implementation dependent name of a joystick.
   This can be called before any joysticks are opened. *)
external name : int -> string = "ml_SDL_JoystickName"

(** Open a joystick for use - the index passed as an argument refers to
   the N'th joystick on the system.  This index is the value which will
   identify this joystick in future joystick events. 
   @raise SDLjoystick_exception if an error occurred *)
external open_joystick : int -> t = "ml_SDL_JoystickOpen"

(** @return [true] if joystick has been opened *)
external opened : int -> bool = "ml_SDL_JoystickOpened"

(** Get the device index of an opened joystick *)
external index : t -> int = "ml_SDL_JoystickIndex"

(** Get the number of general axis controls on a joystick *)
external num_axes : t -> int = "ml_SDL_JoystickNumAxes"

(** Get the number of trackballs on a joystick
   Joystick trackballs have only relative motion events associated
   with them and their state cannot be polled. *)
external num_balls : t -> int = "ml_SDL_JoystickNumBalls"

(** Get the number of POV hats on a joystick *)
external num_hats : t -> int = "ml_SDL_JoystickNumHats"

(** Get the number of buttons on a joystick *)
external num_buttons : t -> int = "ml_SDL_JoystickNumButtons"

(** {3 Joystick state } *)

(** Update the current state of the open joysticks.
   This is called automatically by the event loop if any joystick
   events are enabled. *)
external update : t -> unit = "ml_SDL_JoystickUpdate"


(** Enable/disable joystick event polling.
   If joystick events are disabled, you must call {! Sdljoystick.update}
   yourself and check the state of the joystick when you want joystick
   information. *)

external set_event_state : bool -> unit = "ml_SDL_JoystickSetEventState"
external get_event_state : unit -> bool = "ml_SDL_JoystickGetEventState"

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

external get_axis : t -> int -> int
    = "ml_SDL_JoystickGetAxis"
external get_hat  : t -> int -> hat_value
    = "ml_SDL_JoystickGetHat"
external get_ball : t -> int -> int * int
    = "ml_SDL_JoystickGetBall"
external get_button : t -> int -> bool
    = "ml_SDL_JoystickGetButton"

(** Close a joystick previously opened with {! Sdljoystick.open_joystick} *)
external close : t -> unit = "ml_SDL_JoystickClose"
