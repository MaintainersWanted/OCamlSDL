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

(* $Id: sdlloader.ml,v 1.3 2000/01/20 17:50:34 smkl Exp $ *)

(* Define a new exception for loader errors and register 
   it to be callable from C code. *)

exception SDLloader_exception of string
let _ = Callback.register_exception "SDLloader_exception" (SDLloader_exception "Any string")

external load_image : string -> Sdlvideo.surface = "sdlloader_load_image";;
external load_png : string -> Sdlvideo.surface = "sdlloader_load_png";;
external load_png_with_alpha : string -> Sdlvideo.surface = "sdlloader_load_png_with_alpha";;

let load_ppm_pixels str =
  try
    let chn = open_in_bin str in
    let _ = input_line chn in
    let rec ignore_comments () =
      let ln = input_line chn in
      if String.length ln < 1 or ln.[0] = '#' then ignore_comments ()
      else ln in
    let ln = ignore_comments () in
    let l1 = String.index ln ' ' in
    let w = int_of_string (String.sub ln 0 l1) in
    let h = int_of_string (String.sub ln (l1 + 1) (String.length ln - l1 - 1)) in
    ignore (input_line chn);
    let buffer = String.create (w * h * 3) in
    really_input chn buffer 0 (w * h * 3);
    close_in chn;
    (buffer, w, h)
  with a ->
    begin
      prerr_string ("Bad file: " ^ str ^ "\n");
      raise a
    end

let load_ppm str =
  let (buffer, w, h) = load_ppm_pixels str in
  Sdlvideo.surface_from_pixels (Sdlvideo.Pixels (buffer, w, h))
