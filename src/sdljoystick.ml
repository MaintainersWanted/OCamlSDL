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

(* $Id: sdljoystick.ml,v 1.1 2002/08/08 12:34:35 oliv__a Exp $ *)

(** Joystick handling *)

exception SDLjoystick_exception of string
let _ = Callback.register_exception 
    "SDLjoystick_exception" (SDLjoystick_exception "")

type t

external num_joysticks : unit -> int = "ml_SDL_NumJoysticks"
external name : int -> string = "ml_SDL_JoystickName"

external open_joystick : int -> t = "ml_SDL_JoystickOpen"
external opened : int -> bool = "ml_SDL_JoystickOpened"
external index : t -> int = "ml_SDL_JoystickIndex"
external num_axes : t -> int = "ml_SDL_JoystickNumAxes"
external num_balls : t -> int = "ml_SDL_JoystickNumBalls"
external num_hats : t -> int = "ml_SDL_JoystickNumHats"
external num_buttons : t -> int = "ml_SDL_JoystickNumButtons"

external update : t -> unit = "ml_SDL_JoystickUpdate"
external set_event_state : bool -> unit = "ml_SDL_JoystickSetEventState"
external get_event_state : unit -> bool = "ml_SDL_JoystickGetEventState"

external close : t -> unit = "ml_SDL_JoystickClose"
