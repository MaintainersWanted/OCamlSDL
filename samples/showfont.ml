(*
    showfont:  An example of using the SDL_ttf library with 2D graphics.
    Copyright (C) 1997, 1998, 1999, 2000, 2001  Sam Lantinga

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Library General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Library General Public License for more details.

    You should have received a copy of the GNU Library General Public
    License along with this library; if not, write to the Free
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    Sam Lantinga
    slouken@libsdl.org

    OCamlSDL version by Eric Cooper
    ecc@cmu.edu
*)

let usage = "Usage: " ^ (Filename.basename Sys.executable_name) ^
  " [-solid] [-b|-i|-u] font.ttf [ptsize] [text]\n"

let default_ptsize = "18"
let default_text = "The quick brown fox jumps over the lazy dog"

let solid = ref false

let style = ref [ ] 

let set_style s () =
  style := s :: !style

let spec =
  [ "-solid", Arg.Set solid, "render solid";
    "-b", Arg.Unit (set_style Sdlttf.BOLD), "bold font style";
    "-i", Arg.Unit (set_style Sdlttf.ITALIC), "italic font style";
    "-u", Arg.Unit (set_style Sdlttf.UNDERLINE), "underline font style" ]

let usage_error () =
  Arg.usage spec usage;
  exit 1

open Sdlvideo
open Sdlevent

let initialize file ptsize message =
  Sdl.init [`VIDEO];
  let screen = set_video_mode ~w: 640 ~h: 480 [] in
  fill_rect screen (map_RGB screen white);
  update_rect screen;
  Sdlttf.init ();
  let font = Sdlttf.open_font file ptsize in
  if !style <> [] then 
    Sdlttf.set_font_style font !style;
  let render = if !solid then Sdlttf.SOLID black else Sdlttf.SHADED (black, white) in
  let caption = "Font file: " ^ file in
  Sdlwm.set_caption ~title: caption ~icon: caption;
  let text = Sdlttf.render_text font render caption in
  let (w, h, _) = surface_dims text in
  let r = rect ~x: 4 ~y: 4 ~w ~h in
  blit_surface ~src: text ~dst: screen ~dst_rect: r ();
  update_rect ~rect: r screen;
  let text = Sdlttf.render_text font render message in
  let (w, h, _) = surface_dims text in
  let blit_text x y =
    let r = rect ~x: (x - w / 2) ~y: (y - h / 2) ~w ~h in
    blit_surface ~src: text ~dst: screen ~dst_rect: r ();
    update_rect ~rect: r screen
  in
  let (w, h, _) = surface_dims screen in
  blit_text (w / 2) (h / 2);
  blit_text

let event_loop blit_text =
  while true do
    match wait_event () with
    | MOUSEBUTTONDOWN { mbe_x = x; mbe_y = y } -> blit_text x y
    | KEYDOWN _ | QUIT -> Sdl.quit (); exit 0
    | _ -> ()
  done

let showfont file points message =
  let ptsize =
    try int_of_string points
    with Failure "int_of_string" -> usage_error ()
  in
  event_loop (initialize file ptsize message)

let main () =
  let args = ref [] in
  let anon arg =
    args := !args @ [arg]
  in
  Arg.parse spec anon usage;
  let (file, points, message) = match !args with
  | [ file ] -> (file, default_ptsize, default_text)
  | [ file; points ] -> (file, points, default_text)
  | [ file; points; message ] -> (file, points, message)
  | _ -> usage_error ()
  in
  showfont file points message

let _ = main ()
