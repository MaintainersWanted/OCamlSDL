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

(** $Id: sdlloader.mli,v 1.4 2002/07/24 19:03:57 xtrm Exp $ *)

(* Exception *)

exception SDLloader_exception of string

(** load a ppm picture *)
val load_ppm : string -> Sdlvideo.surface
val load_ppm_pixels : string -> string * int * int

(** load any supported type of image *)
val load_image : string -> Sdlvideo.surface

(** load a png picture *)
val load_png : string -> Sdlvideo.surface

(** load a png picture with alpha *)
val load_png_with_alpha : string -> Sdlvideo.surface

