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

(* $Id: sdlvideo.mli,v 1.1.1.1 2000/01/02 01:32:45 fbrunel Exp $ *)

(* Exception *)

exception SDLvideo_exception of string

(* Types *)

type rect = Rect of int * int * int * int
type surface
type pixel_format
type color

(* Operations on display *)

val get_display_surface : unit -> surface;;
val set_display_mode : int -> int -> int -> surface;; 

val flip : surface -> unit;;
val update_rect : surface -> rect -> unit;;

(* Operations on surfaces *)

val surface_free : surface -> unit;;
val surface_loadBMP : string -> surface;;
val surface_saveBMP : surface -> string -> unit;;
val surface_width : surface -> int;;
val surface_height : surface -> int;;
val surface_rect : surface -> rect;;
val surface_pixel_format : surface -> pixel_format;;
val surface_fill_rect : surface -> rect -> color -> surface;;
val surface_blit : surface -> rect -> surface -> rect -> unit;;
val surface_set_alpha : surface -> float -> surface;;

(* Operations on colors *)

val make_rgb_color : pixel_format -> float -> float -> float -> color;;

(* Window manager interaction *)

val wm_available : unit -> bool;;
