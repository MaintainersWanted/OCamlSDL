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

let load str =
  try
    let chn = open_in_bin str in
    let _ = input_line chn in
    let rec ignore_comments () =
      let ln = input_line chn in
      if String.length ln < 1 or  ln.[0] = '#' then ignore_comments ()
      else ln in
    let ln = ignore_comments () in
    let l1 = String.index ln ' ' in
    let w = int_of_string (String.sub ln 0 l1) in
    let h = int_of_string (String.sub ln (l1+1) (String.length ln - l1 - 1)) in
    ignore (input_line chn);
    let buffer = String.create (w*h*3) in
    really_input chn buffer 0 (w*h*3);
    close_in chn;
    Sdlvideo.Pixels (buffer, w, h)
  with a ->
    begin
      prerr_string ("Bad file: " ^ str ^ "\n");
      raise a
    end

let save fname = function
  | Sdlvideo.Pixels (str, w, h) ->
    let chn = open_out fname in
    output_string chn "P6\n# CREATOR: OCamlSDL PPM loader\n";
    output_string chn (string_of_int w);
    output_char chn ' ';
    output_string chn (string_of_int h);
    output_string chn "\n255\n";
    output_string chn str;
    close_out chn
  | _ -> invalid_arg "Sdlppm.save"
